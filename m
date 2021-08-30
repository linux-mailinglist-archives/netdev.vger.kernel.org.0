Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0C13FBA45
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 18:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbhH3Ql6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 12:41:58 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:36559
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237710AbhH3Qlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 12:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630341661; bh=9e+InX2yoD3vOlO4uXb1izvCNJEhR+3LkCCENa3dxj0=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=aggIJrgCda5GfCw8n/SiWTkmk0O7+9D1hrg8yZvGkueTcuAarx+MZ3sj1LL8+MRmVVVFkcNcFvd/1pcjDEG1S9D7aGagcgj6080rU2Itjoh8iSJNb/nCHrrYJMOYJ+WUpZi3YiqIGfS6q3fagZUhyxojVj3TvYWUEQWSMlTICsyageKHpSG+PeAWBIRdR9zYUY/OvbxvEqbpNDyRWKQBq18I4z8cRzDRtZ955bOle/lLeEm+uzSJdyGgVSDSGRkACvAE/vxF59nmmY4ONqUhqhrAHuC3mcd4m5k5fbxUuy8Zss53EnblNpJJxK7RNvwKIdLrhdg0++Rj9DiD4S2vmQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630341661; bh=HiVUKwmwXb5G5riqVhD9vgmCLHfsT/I9mX3jNzMiPo6=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=hCBShcLnCP2Lv1AMs6Si1QUy6hCLmsF89i33lA3SthWfyCwqzMvOh2aTeTMqLmCaA7ZZB0FRIvK0+dBA1hgL8A8fgVdenJZD8LYZ3l9QFJleTHbi6R5hUL5MuwMbxyXsCgbGORI8j+Wutv3Y0DhO1ZIpdBZA0+VmIbJdRm9z0SzpqlmEPGkmilQT8MfR/C/9CdhOQbBTk6LVuA7e9OMWz+/G3a0EZ6R7UbFBxzOSHKa44ysVGjI+pUrDbxy9hJXH9eS1xzN/ENmRcLuCow/AOCHQk07XNqvN+gf/WW/kRI9ZMNWNqev/+q3X9qbwmHMmMZgApxnVRVM33+36m+zAnA==
X-YMail-OSG: jqMab54VM1nMOIHYArs_QvhnT4BZFYwvZdTbpjEEXf2BPhlxEBVd5fNWyzFBoNQ
 WIYTk9WbFkh4MJ4eqlSnEos2Bhpl1LHjkFlzig9TpBsYdJ03lVPtB5f1oNObDT3QHz0j7ccz89iI
 XeagaYzrp7y5LazDQU3.qkvzrMMJbSOZ2E9Wz2XnPZBha.DgMgrTI5LMlaW1Xf8zI9q.VG.hLJIh
 QZ9s6NO_4AeEhtbjmKHpTZZnu03pGiNDr8rdzEI50SruRhlA9uGMdpGensMjNNYBP8Tc_uOL.Goh
 cXOdkVwGDnTI8cYkpalT6XLABxNIi2LLXMyXA83jd.KvLjDvNa2OcLhYkLjwDmMXuAb16hhvrgde
 EjY8Ynvl59A2NfhDKeXnYu9H9SXljCNWLt6z4czh3Dg4nljgnpG_TJh4MW5P5SGgb3Wpv2fIC7J4
 G7hMb4E9gsDtwBsI3dC3bxNaE3Dj1gO2HZzRW_XjRcMzcYD59ITzwzN2t_cXlaH7DTfHErLQE7jV
 MLupkZH3.uOaqalozX3qweN3A7d8kHmvnQdu4MGtbrtstd_pftWfSNYpPD_j.NnWvy5fG.Ol3jff
 GSxzCisuJaDyfrKZnnW2tJ6l8D3jTq.Hv5prm0BythLxggopmd557dti9uQihdaf4wSQEhr97tJ5
 EVIkNikrLyhDm3xosOJUCz.eVLLtjmVzMT4m_Cb5YA5.R3fkNcXn9HK4GdHpn09H.WcselWyNfaD
 qcX6LoQnbMYMq9JQxU0n._0Q4rYs2Ga5F1lSFCQCdzRmP6ua1XqloxYvTTxaaiSKf8GhW70e7nMQ
 tuqvVb8ExiRDREPvPGXhBHfDP4I5DhuMS1gV1tRDKrFAwHsCRBJpypTFFJcLRJ9A4v.m1jwiK_zi
 2kc5cLspmvhvoz.VF7cKlKMm5RQzFxo8anMes6AAcu_xeMzVaQD8lx1tWhnnIfv0ou43S_IEkMBe
 uaG_0BVROEYScvideIcyTl9Yg5nUHqa04ktzepw1UBPvEFxw1Hy3cD._JxwidaM7zUWRKPeTOb6C
 r05I0BYmPn3_gxqomN8RFvt3Mjxcns9lvJN8F64UD6Zv1xPQKuIQrjQjEKW36td48iGxE4VTvI3b
 ryQFmRdubCCV5UFAFkxsGodeZtVHUeZNYfoV.CDoNb8hkllhApLY0zIRrQP.LMkMaAjXmi7F3sWH
 8cfTunIflGns56PMOCgLf_HXROvqs6M5M_vSlk9uj5UPl_J4NMRRfO3Wxlomxa3A0c3Slz_Qn7ja
 MyZNLGWs.KiSDlcqUvj_NYINRDr0IMkE18Y_v_g6yc96UXT8XntXlFqi93Bx925p2kV6g1rDtVIw
 8YTMYV72EMC91s3KkCW.mZzVNq.H7mQEL.5.GdDwJmQCv5vKWgkcptgeyEc3rpQ2W.jQtY0As_xw
 LpX4QF6_kQzGDUG8Ejd1AQVCcaiaODImFh2Zsy__TWuS33xKLMcP_APr0uS8qBwZ0J0VB52ZGbko
 FWvSKPvayBEBSOho5biN76CquoIw6vj5Jj2H3KOPgkhKw61cLuSVBYoJBrUS88Ol0xzpYuMiysMk
 qYj5oFKcpakNhfw4ql50G7oiZuuGg1LbmREKzlrPEbdZUA.VIACxdF03U.ZG7ls5KONEmNmklq0b
 4kGTfgnfXh1Atw70BURIPUQLsY4adAhoHPZlK9dlXpgdhpyzGD_FSogVx4I0VxEABZZFqSNi0fF6
 MhZw.EP8NSaXD6yIDIvTPLXm6AefAGIu.bMUsSKRt_8nwEDestJRdnGhnhDg2bEef2KIDvEauZ5R
 hLOV0mgtt
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Mon, 30 Aug 2021 16:41:01 +0000
Received: by kubenode558.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 4a904bcbd979e290234fa6ef5a120131;
          Mon, 30 Aug 2021 16:40:59 +0000 (UTC)
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
 <61bf6b11-80f8-839e-4ae7-54c2c6021ed5@schaufler-ca.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <89d0e012-4caf-4cda-3c4e-803a2c6ebc2b@schaufler-ca.com>
Date:   Mon, 30 Aug 2021 09:40:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <61bf6b11-80f8-839e-4ae7-54c2c6021ed5@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18924 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2021 7:25 AM, Casey Schaufler wrote:
> On 8/30/2021 5:23 AM, Christian Brauner wrote:
>> On Fri, Aug 27, 2021 at 07:11:18PM -0700, syzbot wrote:
>>> syzbot has bisected this issue to:
>>>
>>> commit 54261af473be4c5481f6196064445d2945f2bdab
>>> Author: KP Singh <kpsingh@google.com>
>>> Date:   Thu Apr 30 15:52:40 2020 +0000
>>>
>>>     security: Fix the default value of fs_context_parse_param hook
>>>
>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D160c5d=
75300000
>>> start commit:   77dd11439b86 Merge tag 'drm-fixes-2021-08-27' of git:=
//ano..
>>> git tree:       upstream
>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D150c5d=
75300000
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D110c5d753=
00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D2fd902af7=
7ff1e56
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd1e3b1d92d2=
5abf97943
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D126d084=
d300000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16216eb13=
00000
>>>
>>> Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
>>> Fixes: 54261af473be ("security: Fix the default value of fs_context_p=
arse_param hook")
>>>
>>> For information about bisection process see: https://goo.gl/tpsmEJ#bi=
section
>> So ok, this seems somewhat clear now. When smack and=20
>> CONFIG_BPF_LSM=3Dy
>> is selected the bpf LSM will register NOP handlers including
>>
>> bpf_lsm_fs_context_fs_param()
>>
>> for the
>>
>> fs_context_fs_param
>>
>> LSM hook. The bpf LSM runs last, i.e. after smack according to:
>>
>> CONFIG_LSM=3D"landlock,lockdown,yama,safesetid,integrity,tomoyo,smack,=
bpf"
>>
>> in the appended config. The smack hook runs and sets
>>
>> param->string =3D NULL
>>
>> then the bpf NOP handler runs returning -ENOPARM indicating to the vfs=

>> parameter parser that this is not a security module option so it shoul=
d
>> proceed processing the parameter subsequently causing the crash becaus=
e
>> param->string is not allowed to be NULL (Which the vfs parameter parse=
r
>> verifies early in fsconfig().).
> The security_fs_context_parse_param() function is incorrectly
> implemented using the call_int_hook() macro. It should return
> zero if any of the modules return zero. It does not follow the
> usual failure model of LSM hooks. It could be argued that the
> code was fine before the addition of the BPF hook, but it was
> going to fail as soon as any two security modules provided
> mount options.
>
> Regardless, I will have a patch later today. Thank you for
> tracking this down.

Here's my proposed patch. I'll tidy it up with a proper
commit message if it looks alright to y'all. I've tested
with Smack and with and without BPF.


 security/security.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/security/security.c b/security/security.c
index 09533cbb7221..3cf0faaf1c5b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -885,7 +885,19 @@ int security_fs_context_dup(struct fs_context *fc, s=
truct fs_context *src_fc)
=20
 int security_fs_context_parse_param(struct fs_context *fc, struct fs_par=
ameter *param)
 {
-	return call_int_hook(fs_context_parse_param, -ENOPARAM, fc, param);
+	struct security_hook_list *hp;
+	int trc;
+	int rc =3D -ENOPARAM;
+
+	hlist_for_each_entry(hp, &security_hook_heads.fs_context_parse_param,
+			     list) {
+		trc =3D hp->hook.fs_context_parse_param(fc, param);
+		if (trc =3D=3D 0)
+			rc =3D 0;
+		else if (trc !=3D -ENOPARAM)
+			return trc;
+	}
+	return rc;
 }
=20
 int security_sb_alloc(struct super_block *sb)

>
>> If you take the appended syzkaller config and additionally select
>> kprobes you can observe this by registering bpf kretprobes for:
>> security_fs_context_parse_param()
>> smack_fs_context_parse_param()
>> bpf_lsm_fs_context_parse_param()
>> in different terminal windows and then running the syzkaller provided
>> reproducer:
>>
>> root@f2-vm:~# bpftrace -e 'kretprobe:smack_fs_context_parse_param { pr=
intf("returned: %d\n", retval); }'
>> Attaching 1 probe...
>> returned: 0
>>
>> root@f2-vm:~# bpftrace -e 'kretprobe:bpf_lsm_fs_context_parse_param { =
printf("returned: %d\n", retval); }'
>> Attaching 1 probe...
>> returned: -519
>>
>> root@f2-vm:~# bpftrace -e 'kretprobe:security_fs_context_parse_param {=
 printf("returned: %d\n", retval); }'
>> Attaching 1 probe...
>> returned: -519
>>
>> ^^^^^
>> This will ultimately tell the vfs to move on causing the crash because=

>> param->string is null at that point.
>>
>> Unless I missed something why that can't happen.
>>
>> Christian

