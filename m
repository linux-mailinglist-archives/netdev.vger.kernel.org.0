Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C143FB837
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 16:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbhH3O0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 10:26:18 -0400
Received: from sonic308-14.consmr.mail.ne1.yahoo.com ([66.163.187.37]:34040
        "EHLO sonic308-14.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237340AbhH3O0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 10:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630333521; bh=0pxK8TOsLSSsgIq4Lo5ECQG0ClbIJTlF/6mdGZc7k/c=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=WusjcrWm3DkvbDeQIkHFqVseRlbmYkKVMlo+OWoYomxGv+BlXwWYZw5XNtG6tl0ReLLodPUx/QVujP3hH5trBAAVWAFl98pbgm36P3kkpgCfXtvDR7J4/kdbfjO/fz3eXY/HQpi4/niK/u60V/hiexvxrZkerQNAdHWRMt2e5fx9B5EIqEZLa6LXBG967DsBl08HtEjDYEBz9lm0oCIvW1nAz/TIUqB2wJMBkygWs8lVUZKYDeRmTwX9xZL0jSI7ewulWsG5FO6OMfd5pshhINr7dNqEs/aaGJSPgGHPfz4j8j3unVk0YX2BmWN1ZMeJJ32k//o3PKD7QxQt7PKLKg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630333521; bh=g8c29hjVoX7EBTcnwTq6gowo7IaOPvAHTDt7LNSkT09=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=uhYgdD+p1K4+3QkYN2gUE/0nfKVS0BNlHn0Xq1awNiWXwaGQsSJHdJEEmJ9Y/E1sr2N2tIUi9LGeNkdoysl3UHbKANKFlKEpGG/zYqtdHZ/6/g4O5gpVnwtqDgRIGmdLNiC0huiz3qsZl9LuL+Xk7lbFTJ0v7hqy9dageVPePx5O/rMAwKglt8yj1PR2//F0DbqY7nU2VpLWhH29QakV6rz8e9FuOJ2h/BVifS3ltawlHyGyDMzkQZVniL7s5Hu18Zz8mAxie2Mh9ACOunUV81KGxa53lXdu71L0lKC3dBeto8gsR4Ryhw9po1gJO8pI0ytvTrr+QjR5fl09dy7Gow==
X-YMail-OSG: elb0DNYVM1k.p6ZKpjRZ8vfyWh9mK.roguxlODXE6GvCbs6ZOomvUmbMvt5Ik55
 ISxK6ohrhSgv1qc_x0LyfnTXqoztF8AbZW9X9nSRHsajaYSX9FqTAvq04etlmpEW1UEBrrC8tZeR
 Ljbz7.TU0INvvGOYnMsrfqgKpX.lhjbPgIQEwQnPQUyPgZEZKE.xNE2NL0jnW_R6AUfdTanLg06P
 jItq1xVR.g3x8C57_qyShWY0Hnzk3VrzqCzfGMiizgJLv.YA.ySm1fcgdLTbqkX6S3wgr5fbDnFo
 ryecO7CZ9g59YiiUXhqt05RvtVnOR9Jrtmd1s.pgn73Sri5FShgBz9fRrXH5RWlyNpm6aVjR4tG4
 h8TkaP99T9CeTOl7bkNxa7C.FTxPMWB0VZW0KPCOQ0_TscagwmmPqrZQ.0BiYVKgjbHFHmJ.lWH0
 .HRuBpa.wm8lH7Mww4UI30ZhxGEYVax1L0CsIwNyoCpUC2Xay3EUaYAywo9sLr8NDkR7fhpbiyZX
 iyo7ieSIBbp_UJypYX77jXq5fbISTaeDEVCdqQpynkECVt4NefLHBVUbo4_DJDlqtUKcQkFmSzoB
 RI5h2MHHCHDDkVYx_fvQWjN9k8rMSOzpO9x5wjcbK9uUY83q1X_2o1NJhBCYqGtIl6Dq2IPbOTBL
 2c.JAnEcJh4bSdf2DzFtbUoe5h2MQ.dB1vs1ciq_hY7GWYnB5wlJ4ypFIXxRYWxLO0ZW.A1K2pEe
 dBVcepymhGJaNyTYWXhYLVT0v0apVCyOhcnQsvCvZb76Gxjz5_MBtMVByRVpNA6KMBLwi5adSgdA
 FHhPqCJWktkxg58TOSAERhXdaEmAH9YWD8L8jqu36q4UwxE2x2c8juKu8xs5wOo8Q.s_gDoxhRXf
 SJliMRCBJyrcM_2Yl3jgXbYbKlM_grXtresNdFsDQVaEbnyYH7prLce7Bo2RZx1biO_pf5QSTE_B
 FzF.RIgjKZNmLuXOvBTN94XhwdEG3_2LV5PcAJ5HSSjRcHSzauFwdk0F7A2_1nAiFvvMgBedFQWX
 vKbsX4VRWUAIN1OXmjxskOhnHo82461I3OTqd59XUfC1oYCRKRFOqHPT079gWUsNeVRKXhtrbDZq
 ZUQCs4hTe0tOCreeLry9xHafenMi8559v3Nt6Hirt.xQM.OBhSB_wGEoCrAdjYNxR7YAYNWVsXeG
 ad03wQioN_NYP6suVE2okFwQqEWVO5eHpWeylrEsnWCigxtfZtggFqHOdQJwPYp8H3xK1PsFgyDM
 8vcfnmuY4FuNw5DHT0hB57b4nEsyiBi6Sco2w2lHMt8lupfthvXAT_lbNXhv49ejj78UFnJYift3
 fTdMksZWnC_pU6faKHyk2K73Fh9NBDXXN8j7ZUIYZUuRKp367Nbm4LjuKX3KRpCl.6N6a9VNy3qG
 XOLfTt.56sOzZSDIbbdzLw3od.bPjaz8AseUn68AtqaYoh_S.Znx1bzbAgMKTWkjj3iApcU8R4qQ
 3IE5jY2jFTGFhREeKssCNVcx8N_SeSAq3MNlGdtR1Sxra1wmmbPtjH5yR1C9YmJeFjtAoWg7W9Bb
 S87jo6HIVs_ixOok_6hr3lIib5qkyMsIXKp2Go_JU4fUnsY1e7yH6SUt_pt3174acZY5lwG0rpig
 tJzL9M69L5Y8Tel_U9entVUTDruHEXOsAE5iH29p3UUp368nCbEizyQnocE.yo2Ejq6LRlKHEe9U
 Xq3FyJlvlaBsZVSO2gB657g8s8MLKxdjSuZCKZMVEAWzXwctPhmh2RPzBWccZ1X9NnUd3ZC8n3.M
 bOf_KR65BdDrrK6cjekW7BKw55.6BS_uwFwKT0nIE4EMEQxSFXTnrVupFN2UpijP3l6Y9o5PDfci
 FxN50hXS8Dh8u4GJ0ARBDKQT3yK6h9m5t71ANSPXodeKhfGCLppNqwHvFsWM_d3ExReZJIrd68MA
 z71v_BPUimf.xHvOk1wu.dLwAkCGpktboWCCatl5tfjenL9CL0Cv3GS4Rb1n_yp1jEewunj0cFwR
 VFccC_gUShEjGrs0NjNCnYQT3n4MrI9ivLr.Uj.fqdFSJz1dOHVLP7At0zI1u9_IArhPgDOiZCck
 nF8bVSrGrLHuYh69EPUaQwtF9Qw4TxG9u2xg9GX7nq15TZKAhplE6p.rVM7GBAdiSqXUHWKz4ERE
 sL2Xi0_Dc.tGRElkf2FA.Ye4VF7rqujWk5VqgZrVLOPFpo23P2Pyi9ejhJ0x.ausc85aAF0TkSs3
 Vsfp_MG8bbMqSh8A5uwDpYWs_GhmEuxILnItrqPSzOiUGJ.0bPVwovbJ.f9vocTBoCErYnohT6Wo
 HzR4S
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Mon, 30 Aug 2021 14:25:21 +0000
Received: by kubenode558.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID feaa928858b93704f05540583ecfdccd;
          Mon, 30 Aug 2021 14:25:18 +0000 (UTC)
Subject: Re: [syzbot] general protection fault in legacy_parse_param
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        syzbot <syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dhowells@redhat.com, dvyukov@google.com,
        jmorris@namei.org, kafai@fb.com, kpsingh@google.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        viro@zeniv.linux.org.uk, yhs@fb.com,
        Casey Schaufler <casey@schaufler-ca.com>
References: <0000000000004e5ec705c6318557@google.com>
 <0000000000008d2a0005ca951d94@google.com>
 <20210830122348.jffs5dmq6z25qzw5@wittgenstein>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <61bf6b11-80f8-839e-4ae7-54c2c6021ed5@schaufler-ca.com>
Date:   Mon, 30 Aug 2021 07:25:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830122348.jffs5dmq6z25qzw5@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18924 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2021 5:23 AM, Christian Brauner wrote:
> On Fri, Aug 27, 2021 at 07:11:18PM -0700, syzbot wrote:
>> syzbot has bisected this issue to:
>>
>> commit 54261af473be4c5481f6196064445d2945f2bdab
>> Author: KP Singh <kpsingh@google.com>
>> Date:   Thu Apr 30 15:52:40 2020 +0000
>>
>>     security: Fix the default value of fs_context_parse_param hook
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D160c5d7=
5300000
>> start commit:   77dd11439b86 Merge tag 'drm-fixes-2021-08-27' of git:/=
/ano..
>> git tree:       upstream
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D150c5d7=
5300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D110c5d7530=
0000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D2fd902af77=
ff1e56
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd1e3b1d92d25=
abf97943
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D126d084d=
300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16216eb130=
0000
>>
>> Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
>> Fixes: 54261af473be ("security: Fix the default value of fs_context_pa=
rse_param hook")
>>
>> For information about bisection process see: https://goo.gl/tpsmEJ#bis=
ection
> So ok, this seems somewhat clear now. When smack and=20
> CONFIG_BPF_LSM=3Dy
> is selected the bpf LSM will register NOP handlers including
>
> bpf_lsm_fs_context_fs_param()
>
> for the
>
> fs_context_fs_param
>
> LSM hook. The bpf LSM runs last, i.e. after smack according to:
>
> CONFIG_LSM=3D"landlock,lockdown,yama,safesetid,integrity,tomoyo,smack,b=
pf"
>
> in the appended config. The smack hook runs and sets
>
> param->string =3D NULL
>
> then the bpf NOP handler runs returning -ENOPARM indicating to the vfs
> parameter parser that this is not a security module option so it should=

> proceed processing the parameter subsequently causing the crash because=

> param->string is not allowed to be NULL (Which the vfs parameter parser=

> verifies early in fsconfig().).

The security_fs_context_parse_param() function is incorrectly
implemented using the call_int_hook() macro. It should return
zero if any of the modules return zero. It does not follow the
usual failure model of LSM hooks. It could be argued that the
code was fine before the addition of the BPF hook, but it was
going to fail as soon as any two security modules provided
mount options.

Regardless, I will have a patch later today. Thank you for
tracking this down.

>
> If you take the appended syzkaller config and additionally select
> kprobes you can observe this by registering bpf kretprobes for:
> security_fs_context_parse_param()
> smack_fs_context_parse_param()
> bpf_lsm_fs_context_parse_param()
> in different terminal windows and then running the syzkaller provided
> reproducer:
>
> root@f2-vm:~# bpftrace -e 'kretprobe:smack_fs_context_parse_param { pri=
ntf("returned: %d\n", retval); }'
> Attaching 1 probe...
> returned: 0
>
> root@f2-vm:~# bpftrace -e 'kretprobe:bpf_lsm_fs_context_parse_param { p=
rintf("returned: %d\n", retval); }'
> Attaching 1 probe...
> returned: -519
>
> root@f2-vm:~# bpftrace -e 'kretprobe:security_fs_context_parse_param { =
printf("returned: %d\n", retval); }'
> Attaching 1 probe...
> returned: -519
>
> ^^^^^
> This will ultimately tell the vfs to move on causing the crash because
> param->string is null at that point.
>
> Unless I missed something why that can't happen.
>
> Christian

