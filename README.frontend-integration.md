Integration steps performed and next actions

- A PowerShell helper script `scripts/merge_frontend.ps1` was added to copy the frontend `src` from the other repository into this project as `src_etherx_frontend` (backup of current `src` created).

How to run the script (PowerShell):

```powershell
cd "c:\Users\Dell\Downloads\EtherX-_Excel-main\EtherX-_Excel-main"
.\scripts\merge_frontend.ps1
```

After the copy, recommended manual steps:

- Inspect `src_etherx_frontend` and decide which files to merge into `src` (for example `App.tsx`, `components/`, `styles/`).
- Keep `firebaseConfig.ts` and `settings.json` from the target project; merge auth or API calls as needed.
- Run `npm install` to install merged dependencies.
- Run `npm run dev` to start the dev server.

Notes:
- `package.json` was updated to include the frontend's dependencies (without downgrading core libs already present in this project). Review versions and adjust React/React-DOM versions if required.
- This script does not overwrite `src` directly to avoid accidental loss — it places the frontend into `src_etherx_frontend` for you to review and merge.
