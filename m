Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2E03FBB2F
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbhH3Rmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:42:31 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:34248
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238292AbhH3Rm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630345295; bh=63tGWgI+91kZFLvxtV3AtuV+jYHX6c73k4KyOfXCONw=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=m48tD3xXUrfjx7+r1ALnguHUfE08MvFNc+crw47IKk1FPbyF1Dh2s4ZwjM9x3owroSJt0yStxemWNoVa4K/5/nFMBnDLvdaxsiiF1y7Bfxvrrz/FmZKaC6VuH603xoBaO6MabHZNPL9gPK1RlW5Mf3/7qd5/IgpC0tMf41yNFuiaV5j5JvV9WuFMYUbbwXGO5+YWT+aXkLJX8smSUn4WOqixGOU8fLWlFgtcy3Udbe68wPU/YmQoOq8oywLY8hJ9HuoWL8zwt32kU8DvGY8TBcwdUr7bsLRLtLbbtPIx4Ug93v3O5griDBcJN3GW5x0jEX1YspEuvJkN8hqxabKugA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1630345295; bh=TZQ50t//E90y1A1wAgklpP7i5tmD2Nnaxlb1IL7FWoN=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=DPcwZ7LEbKsUlOTC4zZlbkTiumeWiREeakRKa0HokC5Hs3YfXLJkBCsnsIDP52T6E1wOs0Y3/G0Fwc3beuIwBHdjG3ZCCVS/QvJkz+cYAc15L+2U9gCiUq0XH8uRxpYoI4vSy7OPLxrUJmgWal8LE0c7+j7kyqpI7+MHdU0l/U6GOdPzKfUaas67IAAZzrRFI6hi/SSPiicwgOC+yskvEi/QhqLLxIV6k8FOiBoJIl3vueWAxHB5iCOrR18aHPRPjmCwWNGzXG2Eklf8X9rF95qXESjMmFGBXsgq/i6LYhSdZIHzyL+PFbScLPnh7RfrK537yr1b5J4Cb3w5e5XLxw==
X-YMail-OSG: rpdanEUVM1kM9AmM5ooEUWSLyY3bQWRdUHvdUp4TdcvE10AxpMkqU40Zcbq.HFs
 1vkhSCukI0I_H0PggDeo_HfIHtldDIuf58y.j9l3Wv2um1j7XrdwHcZagw.l0ngYp8FFzfRHx1kk
 TJ_w44hhwl.fQoKXIg6GplwIQR2Jf1nQ0.TC4Ro4PhvOqWe6a4ynpZQxCDXLIS52HYYYButyB_xm
 1M.L3ytwCUtofWLm.B5iWgtpafHkVQeUaJ2LyWM5b8rc4DmJ4nRU92XmYPN45674Vnfmn33qcB8X
 jqc6H9zNUR6W0nkN_R0eXjFfsle4dTjKEJPcebzaKECTbdAN35VGBbvKzSVH_AY0b3bnN4ZMMQG0
 dGWDR0G3qA8WmViwKU7vWTHhxhLyDJAtLSTm3qbM1Oe0GkUvTGvZWB_uJMl8.7NIz9R6A_LqvhZ.
 16SDVSErmGIsQtNS4mxu0d7Gpc5wn1mKV0WMmRFWy6zqAsaqb2iXRonypuP6VJCLsZhktRyl_1vt
 .l4.0qGxGlNiQY94koPBdVqwVyvsMpntCYTxusoeht_Umy4lh0s9LTZ_dkZk0j4hfNGv0DmnC.0j
 EbRzXc00GnWYFkHYx_Ifz99_CFmTsBmMeS3kuLDKPNYYR6XVVTKatS8gTq6j3vCN7ki0nuNNT0Bu
 dCn77nT5pEys09IgnvcQqB5BJHstmF_FpxUXxAx4dxvaENLDqCmdHa6SZzlleQTJn.Rf7j6XZ5ic
 Y45ziRKML1j1nVsbgt25LFNuYVpVwusGwV4cZgASuAa1wj7H87gwBIcziI_pvBZceo7PWS0wRY4W
 PfPiRlIGJZ7wFFgWwhSulo_uleF.52uF0lEZaOmADGNHddXmdFwDtQHRCSfxXmZk7qHyC4sK7Y7c
 obnH74SPfUY8OYcjNvNmfpwUkl1KMiRC1idnTvEk6pMc7PyLpD0XSklkBCFiVV2wcULKbvJfjE81
 phYRkugSR7D406Gd5fGb7dWE0OwKcseXhRD6MY1jTYZMjsQ0rgiKobHVvCEfKI68Z9xrm8YGCCmP
 aNbZDoH9u4HFSFl8nm1T0yIvk1DEeeuesK5ISp1.rnto3TT3hIkmqEcvUpJyJO.5c7_JpiHUTHVB
 FHTIAnLcgJEb8JMWp841DNFuGmn7h_ZkpMEfjyBAxswFmqhUA2S_Q4XfxJuPjFaa6TMBHjibqDM2
 fWPO95B6aZHpHz_13I30yHiJo4bN12Ks_y01bHqg_T0zwzDff5B73gAg0e_fVi4Ai8AxjO34mL9R
 KnTCEaJo2W2IviZq_mLVdifQuuJGJt82LitF4tqPGll9ggKjuRsMLmzE.inwmj7LIzPBJOmut4ts
 Ipl6z5jPu4tlR3DEg7gptm38XeS3cZVfa1pzaXsU6poUiUNcZzIpvvZymH4EHdXNSxmp_p5Z24tN
 0.Kskn3Zc2CJTsdTYoBKyQRrMH9rfNv_9IUgn7mBHGnP3KK8HMNlaOdQKkRxXwyFde2yJckNFOSS
 9gIjih.OlN0rUe.r840.I8Yc2lJxDWX5RYK31axOhtxFghIxXupHkp9b91rFK47tDxxEkvKET1lu
 c1zmdxD4pE35ivA1fMPWOvpuwJEFmA6W5bwVjDmAGsano0LSLoxyBapksKArTpkHGg8eAzTjn5rF
 Evq6e7Tl.XQzv4p0po6EMvhHYng5TcgkRaxhid5WeJF6VhUifKSn3xX8vDIcCVRzfjVI1oNo5Juf
 L3NoiOrFJZWQRudg1tizyzoHpeafCPfZsVj.jTzTAICoAnUri.rkpVaR7fJFMT0.pyuCLMXEvnZY
 fygvySH9pjW2Kto7jK34R90730V9.GZLeLNKClbgIKpD0F8JuWgCD4vcwODqCeHumsWMF6MfU8mX
 VMSdeZ3oHxP5.YI5WqMZyjJbwAHvBa.edWJKU9YUbgPf7uvYfF08YW4XdBVKw2jlDpytJP9fa70E
 8CHugm0PaJT9llehDD1sndAsipxxS9X2TPxDHC61k_xy89tWrxoA0NEyREsmKs_BAySZANFI5het
 6skiXeOK71LiW..6jAiMBRSRBsI8r5ezFlGEcmQ7TsNG9jpjEo8AW9DDlIAcBP_sgOqFKNxwksMc
 667zkwbicXc062M7AkSzoKGn7gEMd9I7WIcVW1DWA9KVLXJiyh9NmINf_jfu5EyYCP9AQYYU8uxR
 tZPwOB3PGnxbQY7huybRXKUAbGJxU7RYYUG_0iVUOPwRZMpHBRBVkJBs.5Hlp2lcaJ5aeGB0MovG
 UHjsUIMGUr6p2fBaR5VUmFC_23mGu_r8IVAwMKMcxxHbUqANkuH3oROWZ_0rN7NJWVlATTNlwOe9
 tXUD9luptuBP8
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Mon, 30 Aug 2021 17:41:35 +0000
Received: by kubenode521.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a3d7a860b9579fd1561d3f4cd5329979;
          Mon, 30 Aug 2021 17:41:31 +0000 (UTC)
Subject: Re: [syzbot] general protection fault in legacy_parse_param
To:     Christian Brauner <christian.brauner@ubuntu.com>,
        David Howells <dhowells@redhat.com>
Cc:     syzbot <syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, dvyukov@google.com, jmorris@namei.org,
        kafai@fb.com, kpsingh@google.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        viro@zeniv.linux.org.uk, yhs@fb.com
References: <0000000000004e5ec705c6318557@google.com>
 <0000000000008d2a0005ca951d94@google.com>
 <20210830122348.jffs5dmq6z25qzw5@wittgenstein>
 <61bf6b11-80f8-839e-4ae7-54c2c6021ed5@schaufler-ca.com>
 <89d0e012-4caf-4cda-3c4e-803a2c6ebc2b@schaufler-ca.com>
 <20210830165733.emqlg3orflaqqfio@wittgenstein>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <3354839e-5e7a-08c7-277a-9bbebfbfc0bc@schaufler-ca.com>
Date:   Mon, 30 Aug 2021 10:41:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830165733.emqlg3orflaqqfio@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18924 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2021 9:57 AM, Christian Brauner wrote:
> On Mon, Aug 30, 2021 at 09:40:57AM -0700, Casey Schaufler wrote:
>> On 8/30/2021 7:25 AM, Casey Schaufler wrote:
>>> On 8/30/2021 5:23 AM, Christian Brauner wrote:
>>>> On Fri, Aug 27, 2021 at 07:11:18PM -0700, syzbot wrote:
>>>>> syzbot has bisected this issue to:
>>>>>
>>>>> commit 54261af473be4c5481f6196064445d2945f2bdab
>>>>> Author: KP Singh <kpsingh@google.com>
>>>>> Date:   Thu Apr 30 15:52:40 2020 +0000
>>>>>
>>>>>     security: Fix the default value of fs_context_parse_param hook
>>>>>
>>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160c5d75300000
>>>>> start commit:   77dd11439b86 Merge tag 'drm-fixes-2021-08-27' of git://ano..
>>>>> git tree:       upstream
>>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=150c5d75300000
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=110c5d75300000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=2fd902af77ff1e56
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=d1e3b1d92d25abf97943
>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126d084d300000
>>>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16216eb1300000
>>>>>
>>>>> Reported-by: syzbot+d1e3b1d92d25abf97943@syzkaller.appspotmail.com
>>>>> Fixes: 54261af473be ("security: Fix the default value of fs_context_parse_param hook")
>>>>>
>>>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>>> So ok, this seems somewhat clear now. When smack and 
>>>> CONFIG_BPF_LSM=y
>>>> is selected the bpf LSM will register NOP handlers including
>>>>
>>>> bpf_lsm_fs_context_fs_param()
>>>>
>>>> for the
>>>>
>>>> fs_context_fs_param
>>>>
>>>> LSM hook. The bpf LSM runs last, i.e. after smack according to:
>>>>
>>>> CONFIG_LSM="landlock,lockdown,yama,safesetid,integrity,tomoyo,smack,bpf"
>>>>
>>>> in the appended config. The smack hook runs and sets
>>>>
>>>> param->string = NULL
>>>>
>>>> then the bpf NOP handler runs returning -ENOPARM indicating to the vfs
>>>> parameter parser that this is not a security module option so it should
>>>> proceed processing the parameter subsequently causing the crash because
>>>> param->string is not allowed to be NULL (Which the vfs parameter parser
>>>> verifies early in fsconfig().).
>>> The security_fs_context_parse_param() function is incorrectly
>>> implemented using the call_int_hook() macro. It should return
>>> zero if any of the modules return zero. It does not follow the
>>> usual failure model of LSM hooks. It could be argued that the
>>> code was fine before the addition of the BPF hook, but it was
>>> going to fail as soon as any two security modules provided
>>> mount options.
>>>
>>> Regardless, I will have a patch later today. Thank you for
>>> tracking this down.
>> Here's my proposed patch. I'll tidy it up with a proper
>> commit message if it looks alright to y'all. I've tested
>> with Smack and with and without BPF.
> Looks good to me.
> On question, in contrast to smack, selinux returns 1 instead of 0 on
> success. So selinux would cause an early return preventing other hooks
> from running. Just making sure that this is intentional.
>
> Iirc, this would mean that selinux causes fsconfig() to return a
> positive value to userspace which I think is a bug; likely in selinux.
> So I think selinux should either return 0 or the security hook itself
> needs to overwrite a positive value with a sensible errno that can be
> seen by userspace.

I think that I agree. The SELinux and Smack versions of the
hook are almost identical except for setting rc to 1 in the
SELinux case. And returning 1 makes no sense if you follow
the callers back. David Howells wrote both the SELinux and
Smack versions. David - why are they different? which is correct?

>
>>
>>  security/security.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/security/security.c b/security/security.c
>> index 09533cbb7221..3cf0faaf1c5b 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -885,7 +885,19 @@ int security_fs_context_dup(struct fs_context *fc, struct fs_context *src_fc)
>>  
>>  int security_fs_context_parse_param(struct fs_context *fc, struct fs_parameter *param)
>>  {
>> -	return call_int_hook(fs_context_parse_param, -ENOPARAM, fc, param);
>> +	struct security_hook_list *hp;
>> +	int trc;
>> +	int rc = -ENOPARAM;
>> +
>> +	hlist_for_each_entry(hp, &security_hook_heads.fs_context_parse_param,
>> +			     list) {
>> +		trc = hp->hook.fs_context_parse_param(fc, param);
>> +		if (trc == 0)
>> +			rc = 0;
>> +		else if (trc != -ENOPARAM)
>> +			return trc;
>> +	}
>> +	return rc;
>>  }
>>  
>>  int security_sb_alloc(struct super_block *sb)
> <snip>
