Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D936102F79
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfKSWrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:47:22 -0500
Received: from sonic306-28.consmr.mail.ne1.yahoo.com ([66.163.189.90]:37880
        "EHLO sonic306-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725978AbfKSWrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1574203639; bh=TJtpEcBOBDPAHkA5ODDpplBILw3At1N9YjMKukHkf9Q=; h=From:To:Subject:Date:References:From:Subject; b=Uxx3wCPLCKwTvMFJMKcCnzyj698KpOcsr4VbwX+kYx8+v6l6vxQ1CSM/y9JQcq2gjSk2DjiFMtkkwPac1ur1bCnyozqwVq0jX6A7VZBkMnWcDlcQnKZkAbDrymY2p0rj7aqwnmGd2XvJ3PjickAHwYj2FC5KPzKSL2Zvf4/eyK8kJ4uI0YzpPOFvwOczlPypgofMcoxWbNwpuh/Uujrtexsu45Ce1MCGMMvQjIFMmex5N16Ja3XhuAC8Tvpld7f6iVVgQtyAmdUaq3iPuUJq0L/QfGwHpFdIUKFt6FYIxwmAPkfc9+YhnqJdctI4qEaxFljBVIEcZrHtKMy+BIHuEQ==
X-YMail-OSG: XjgfHpMVM1k85aFmEcfIcpZk1Rp28Vd5gbKgTgMtjQuMQc163SBNZxXPkucuBTF
 3977U.BJAAgopZMc6iSDFzKGXy8.WH_I8O2_3wrnLnPdKIiQsImfaDvusDyb6ZTMDWF6ZpywwOO7
 Hh1tFozg7aMRdes7ko_SkzNnTMDhcDeAL_CsXWFhUxQP7PnomfdE___Ggo6FT0luyQptVa3UQIe4
 f_tedCl2_Fd_YBPtwhkEu.nJ88FcMw7_Zr.AGlTnn8c1QCIIfW_ZFiQ_P3xZG9knjAyn3X1wQ.Bg
 IgXDDwhpSwvNDDzn46ByE1JVGMe0mbDpBb1mqltrERLJcNQOrFpOPRh4SHFNIE9kce5DJbrZs.jr
 y0_jg5lCYGqC7zcAQy73zHWFTc7hJtZXhyjHgwbNaIpQb1waMV7yIf3biuzwSGuP1iBOX4Tq9NMF
 ZnHGYi0eDP4tgvCpSu4_O03cGSG2IBT9Za9XGi8tsKLm0dthIueE3oX8jq0Al.DIOQW.2U6mWMc6
 vSQ8jcdB55Wb6jpi7RPZbtILkdX1EQ5UbJRHhHv6ggNoBxNpdjZIWAOQDxrUaAEUpY.q8DK4aW7E
 rVCtyG4JXGxRPyl3d85eJsI88df.SjumxKOv8QL0PmaBW5F2gdOwesKLkh4vrxo1Y3uZixNwDJAT
 SV.AQIzCCSBniCg9LB2za4tFilyCw75ROSrpMvuGdUbifk1H6nSkYO571UxOW9TSCWtwvp3.d4zJ
 VjHkmk7TObap5W39zvFFbRExSUzGwSd7vxB9zdx1AGWNHD0mrcyRqAvt9N4tCdsFt2Ze35jTYBcc
 DmXjRGl8kr84y6Q2FtxxnVVhRsPA0C4ZMfej2MYZinY7ADSZRtaI0CMxQsluW5Gfnn_vKCDIKJ1B
 n9RqY.Hz7cughyzAAW5z4B25pBmlBAAT6VweMIWxUGXMqPcpEUguvFuq3YnZ1V2267FEup3ACa4D
 bpJIZJhhsJjnqN3kv0kOTwAaK5uoUTM3gtOf2YE3O_W3tGID7UrbTHQuWKQxAlIl5Rj8sFWcXNhW
 dHrtxBBk5_k1sz0lXxud0agwcFVBe4VMR3j6A1Uwm3rcm0Fm5Xvi1eKIxrJ9OjcOwnYILKqndj_x
 so_Ejv_3pPLlTaMXfPnDpd7krs9LOdeS0UdEsEHz2oWrYw.kDWF.pZIC2YHjDeqMBQbgRejgEJhK
 632jkN2s8PeiZR57gYXf3wTOrLTdiB20wpboVFfybXwS.9V2stMauic_oMwn2iQCuI5RLn2xK0SU
 KarUcViOe6hQjry1ej47Kke.Cv3TjbSnJvl.6ibMYkReldfq5_GLo66kC26n6e_iLHfNCbRFLpXe
 kXpC_t1ShegCMd4EVZ09.JXTnNBm_o3Y500_YIHhlunTvwGheGc0zWsINhwvGSAOXTYspf.28b7V
 e_1bouBc9
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 19 Nov 2019 22:47:19 +0000
Received: by smtp418.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID f0ce218b5cf5f7d004bf13262887f557;
          Tue, 19 Nov 2019 22:47:17 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     netdev@vger.kernel.org
Subject: [PATCH v11 00/25] LSM: Module stacking for AppArmor
Date:   Tue, 19 Nov 2019 14:47:02 -0800
Message-Id: <20191119224714.13491-1-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20191119224714.13491-1-casey.ref@schaufler-ca.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reposting relevant patches to netdev.

This patchset provides the changes required for
the AppArmor security module to stack safely with any other.

v11: Rebase to 5.4-rc6
     Incorporate feedback from v10
     - Disambiguate reading /proc/.../attr/display by restricting
       all use of the interface to the current process.
     - Fix a merge error in AppArmor's display attribute check

v10: Ask the security modules if the display can be changed.

v9: There is no version 9

v8: Incorporate feedback from v7
    - Minor clean-up in display value management
    - refactor "compound" context creation to use a common
      append_ctx() function.

v7: Incorporate feedback from v6
    - Make setting the display a privileged operation. The
      availability of compound contexts reduces the need for
      setting the display.

v6: Incorporate feedback from v5
    - Add subj_<lsm>= and obj_<lsm>= fields to audit records
    - Add /proc/.../attr/context to get the full context in
      lsmname\0value\0... format as suggested by Simon McVittie
    - Add SO_PEERCONTEXT for getsockopt() to get the full context
      in the same format, also suggested by Simon McVittie.
    - Add /sys/kernel/security/lsm_display_default to provide
      the display default value.

v5: Incorporate feedback from v4
    - Initialize the lsmcontext in security_secid_to_secctx()
    - Clear the lsmcontext in all security_release_secctx() cases
    - Don't use the "display" on strictly internal context
      interfaces.
    - The SELinux binder hooks check for cases where the context
      "display" isn't compatible with SELinux.

v4: Incorporate feedback from v3
    - Mark new lsm_<blob>_alloc functions static
    - Replace the lsm and slot fields of the security_hook_list
      with a pointer to a LSM allocated lsm_id structure. The
      LSM identifies if it needs a slot explicitly. Use the
      lsm_id rather than make security_add_hooks return the
      slot value.
    - Validate slot values used in security.c
    - Reworked the "display" process attribute handling so that
      it works right and doesn't use goofy list processing.
    - fix display value check in dentry_init_security
    - Replace audit_log of secids with '?' instead of deleting
      the audit log

v3: Incorporate feedback from v2
    - Make lsmblob parameter and variable names more
      meaningful, changing "le" and "l" to "blob".
    - Improve consistency of constant naming.
    - Do more sanity checking during LSM initialization.
    - Be a bit clearer about what is temporary scaffolding.
    - Rather than clutter security_getpeersec_dgram with
      otherwise unnecessary checks remove the apparmor
      stub, which does nothing useful.

Patche 0001 moves management of the sock security blob from the individual
modules to the infrastructure.

Patches 0002-0012 replace system use of a "secid" with
a structure "lsmblob" containing information from the
security modules to be held and reused later. At this
point lsmblob contains an array of u32 secids, one "slot"
for each of the security modules compiled into the
kernel that used secids. A "slot" is allocated when
a security module requests one.
The infrastructure is changed to use the slot number
to pass the correct secid to or from the security module
hooks.

It is important that the lsmblob be a fixed size entity
that does not have to be allocated. Several of the places
where it is used would have performance and/or locking
issues with dynamic allocation.

Patch 0013 provides a mechanism for a process to
identify which security module's hooks should be used
when displaying or converting a security context string.
A new interface /proc/self/attr/display contains the name
of the security module to show. Reading from this file
will present the name of the module, while writing to
it will set the value. Only names of active security
modules are accepted. Internally, the name is translated
to the appropriate "slot" number for the module which
is then stored in the task security blob. Setting the
display requires that all modules using the /proc interfaces
allow the transition. The "display" of other processess
can be neither read nor written. All suggested cases
for reading the display of a different process have race
conditions.

Patch 0014 Starts the process of changing how a security
context is represented. Since it is possible for a
security context to have been generated by more than one
security module it is now necessary to note which module
created a security context so that the correct "release"
hook can be called. There are several places where the
module that created a security context cannot be inferred.

This is achieved by introducing a "lsmcontext" structure
which contains the context string, its length and the
"slot" number of the security module that created it.
The security_release_secctx() interface is changed,
replacing the (string,len) pointer pair with a lsmcontext
pointer.

Patches 0015-0017 convert the security interfaces from
(string,len) pointer pairs to a lsmcontext pointer.
The slot number identifying the creating module is
added by the infrastructure. Where the security context
is stored for extended periods the data type is changed.

The Netlabel code is converted to save lsmblob structures
instead of secids in Patches 0018-0019.

Patch 0020 adds checks to the binder hooks which verify
that if both ends of a transaction use the same "display".

Patches 0021-0022 add addition data to the audit records
to identify the LSM specific data for all active modules.

Patches 0023-0024 add new interfaces for getting the
compound security contexts.

Finally, with all interference on the AppArmor hooks
removed, Patch 0025 removes the exclusive bit from
AppArmor. An unnecessary stub hook was also removed.

The Ubuntu project is using an earlier version of
this patchset in their distribution to enable stacking
for containers.

Performance measurements to date have the change
within the "noise". The sockperf and dbench results
are on the order of 0.2% to 0.8% difference, with
better performance being as common as worse. The
benchmarks were run with AppArmor and Smack on Ubuntu.

https://github.com/cschaufler/lsm-stacking.git#stack-5.4-rc6-v11-apparmor

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 arch/alpha/include/uapi/asm/socket.h    |   1 +
 arch/mips/include/uapi/asm/socket.h     |   1 +
 arch/parisc/include/uapi/asm/socket.h   |   1 +
 arch/sparc/include/uapi/asm/socket.h    |   1 +
 drivers/android/binder.c                |  26 +-
 fs/ceph/xattr.c                         |   6 +-
 fs/nfs/nfs4proc.c                       |  22 +-
 fs/nfsd/nfs4xdr.c                       |  20 +-
 fs/proc/base.c                          |   2 +
 include/linux/audit.h                   |   1 +
 include/linux/cred.h                    |   3 +-
 include/linux/lsm_hooks.h               |  37 +-
 include/linux/security.h                | 175 ++++++++--
 include/net/af_unix.h                   |   2 +-
 include/net/netlabel.h                  |   8 +-
 include/net/scm.h                       |  15 +-
 include/uapi/asm-generic/socket.h       |   1 +
 kernel/audit.c                          |  72 +++-
 kernel/audit.h                          |   9 +-
 kernel/audit_fsnotify.c                 |   1 +
 kernel/auditfilter.c                    |  10 +-
 kernel/auditsc.c                        | 127 ++++---
 kernel/cred.c                           |  12 +-
 net/core/sock.c                         |   7 +-
 net/ipv4/cipso_ipv4.c                   |   6 +-
 net/ipv4/ip_sockglue.c                  |  12 +-
 net/netfilter/nf_conntrack_netlink.c    |  20 +-
 net/netfilter/nf_conntrack_standalone.c |  11 +-
 net/netfilter/nfnetlink_queue.c         |  26 +-
 net/netfilter/nft_meta.c                |  13 +-
 net/netfilter/xt_SECMARK.c              |   5 +-
 net/netlabel/netlabel_kapi.c            |   6 +-
 net/netlabel/netlabel_unlabeled.c       |  97 +++---
 net/netlabel/netlabel_unlabeled.h       |   2 +-
 net/netlabel/netlabel_user.c            |  13 +-
 net/netlabel/netlabel_user.h            |   6 +-
 net/unix/af_unix.c                      |   6 +-
 net/xfrm/xfrm_policy.c                  |   2 +
 net/xfrm/xfrm_state.c                   |   2 +
 security/apparmor/include/apparmor.h    |   3 +-
 security/apparmor/include/net.h         |   6 +-
 security/apparmor/lsm.c                 | 117 +++----
 security/commoncap.c                    |   7 +-
 security/integrity/ima/ima.h            |  15 +-
 security/integrity/ima/ima_api.c        |  11 +-
 security/integrity/ima/ima_appraise.c   |   6 +-
 security/integrity/ima/ima_main.c       |  49 +--
 security/integrity/ima/ima_policy.c     |  19 +-
 security/integrity/integrity_audit.c    |   1 +
 security/loadpin/loadpin.c              |   8 +-
 security/safesetid/lsm.c                |   8 +-
 security/security.c                     | 593 +++++++++++++++++++++++++++++---
 security/selinux/hooks.c                | 109 +++---
 security/selinux/include/classmap.h     |   2 +-
 security/selinux/include/objsec.h       |   5 +
 security/selinux/include/security.h     |   1 +
 security/selinux/netlabel.c             |  25 +-
 security/selinux/ss/services.c          |   4 +-
 security/smack/smack.h                  |   6 +
 security/smack/smack_lsm.c              | 124 ++++---
 security/smack/smack_netfilter.c        |   8 +-
 security/smack/smackfs.c                |  10 +-
 security/tomoyo/tomoyo.c                |   8 +-
 security/yama/yama_lsm.c                |   7 +-
 64 files changed, 1376 insertions(+), 563 deletions(-)
