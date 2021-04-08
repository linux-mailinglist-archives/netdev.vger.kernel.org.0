Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5CF35897A
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhDHQSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:18:23 -0400
Received: from sonic310-30.consmr.mail.ne1.yahoo.com ([66.163.186.211]:44186
        "EHLO sonic310-30.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232218AbhDHQSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 12:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617898690; bh=enZo/Yda2EywT1nykAt0YKvcJZOkW+jSi0wjxRqh7jU=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=KIF9S5sIDj70Ygz5d0hfL+Ex4/Syb5WrH2WmiU5RXv7NadiOdsx4nlNkmD1hL8rdr3SYy7gaY7whdTouX6o9O1rIHVqrVxSBOrzUXWSUBSpLtFfiERJSfvruR2OfxKjxUWwfeB9NftHSGr+Nsuj5XXS3EDCPWzRmfs33kMbeSYa3zdmy132ETZd5kS3OBrc6okS2czx4c5KKT7Zxi+Um7q2PrKvlF9YA9Oa4kUYkToCE/LR1uQks9IOOBLNxBFkokePppckZmdbyZlWfTyuqkDHi7E7ipTxlSq30FbucNAiTMnyDF3FKZ7v0upowsm2BpTJHzQX+F0Sn3CMVWjgkMw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1617898690; bh=dORPfVfj3AyLqwbE4g200G2f6uLhT+gIDwy4A00IUik=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=O/tTaUTnlD2ldEybgMPa0+OSUuKzsFfevyXhvcHq6q+EhDn5V27nOZxlDjSw4N5vvKzeUdWLO6SIWDhWYk0zI830TvvxOdNwPdFToAxK3LMwoXTLpXJxRHUSy2BvqJPlBFqyzbMqZ1nYwbH9D5X992OWb+1zWIq0CWfm9YL92oMkACXounYtWh6HfSuPyeCb0vqyz1zxpueyBZlw98KrlrUaYp0SiFeqWEDTqonh7MXsHbyIunZ14J6WFxMuHDgVzcT64/VgXbYAjOBtd9+XF62U25J0jWfcQitd+///Mc5wP1+IG6znUsaGLuJhDJCU5GUyrYVIe9/+ClMfl+2AkQ==
X-YMail-OSG: I7wgwgEVM1kpdLSfejOArdcyK5CKCPF0eyIbxwYcP7umQvEB4uuFzFMh0VBDYSm
 8hVy2hTLn0qb5_GQFd.lfRyVAN2vMs4uXhOJ7wJZSjmESMywwtxye.PHmLMGp982ab_F5I6tQAM7
 kNiiBMhVzFCr3N1sY7EUw8XB2RB_CF.4bq01.mInlPzUslIhTmQJqfbZU8u.nFvXk6jX8OoYIIPO
 NBARAqC.Rv1KUfmU9KgmmkExgXX8Mh1PJOTU8AlTt.RsgluRhAtcb2xKVsdIFbeo.2Yq14wIMvRc
 WfIf12azjTEr3ykaYqifmrZplg5Ch5nYG0nFvNA_OiLrEMCJ.ZQRslBkpmodcHHyuWykLrxWKq24
 aogPYfhdm.vEjKe.YX371AKNbFV5bIbQF1mGPX0iaJv7fMmOaCwKF3BBMB1BIOh9gSzM9StOnZAL
 11HIDVcnVPR4NkSQRCX8kGL8sa649YEqo3CF..PlPFiCkd6gg38RNj6v1R4U_jJlj1r_4DW.t7bQ
 YMZL80rpF5zG4hMRoJNLwQCipStHPo_EcYCI_0dI5CsQa4zUMiBWOgreq6dSIUwYbXrOIaGQ.Ntx
 S_F26wEB7l6PXzuIz7pSWnvmTMAR9FU5fioRrAA46OBPJ3E6no4lQH8uK6Ppb1Il_6iW6FYLSY.E
 M3qxcvv9nh8ZnHg84IjNGqHQbF3VykLLNwfS6YaeI4idOPziFvkXcrs9jQxOKC16Zj7rk7H9E1eg
 ImkeR56UeTbd.ZXw3bzP0QJlpE6mtQytC3vhzUFAXEnYev9Ep6L8rT8W1lzydZvGQHbkjlTk8uXp
 FyxvAzRdsPf.h1fdQbHZ7Q3HFzeBjdy4JIldHKOL6wBqr81HJ9kYiUxBat.HdGFNQzS0nG5qoAZ9
 2TdECjgHLgjLYguwYXnS8_t8LctXqnltFGcXw33gBOhkerRQ9Xy.GWo3St74ayqIAA1z0_R8dky_
 sDrtrRCvcUzf0W2hf7AFCrCXsRDhWiz9NWEQ6rEoO4bvK0JeDaUUmsLBgiXkCO7UZn_oEodpuEl5
 8IG4fLJUbvEYVHDnicHbqUjR3oa5B.hG6bntUif0PVLhiWAxmrfCnZHoX4bG.LQTemZuObvofMl_
 ZkSm9o7ozThzy7J_cUN9CWNaOeqdm0W2s8D_Axw25elR90iVil4VYOW.XX.127cd2XEsRW2C2dK8
 to5D_ezlJ9dzdANH8.khIU8nuckL70llfjwtL0JqlpYZJ9oS3Ft_5ffd0rX_LvytnoQ_u4MaCmWr
 _Io0_69K25rzM.h64sSJxuIDjGOVxXsSYESenwjNWqYEsCfT5DMbJkek0c7zaXBuSOi1RqLxJEKT
 PUKxxE1InpPYaEK.0zVBs_4aP.lq.UpsMcmndL839wRSeNDlSTRA.jUo7vG1BtgKhCcWi_70p7nC
 4ZyGPmKEkUSUoyUdG6ImBVYxZdQ57Xq0UFJVeb4TBuhiM33q9iVmek0npRRhq5u_waucaANAzF6_
 67b8pGRJHuB1SoevgPCDef8ZVO.TkW4RVUHyC5wY2yFgAOcrp3lBhP0pI_6rKJaUoOBkf6vqCGWu
 puP9HQRiA_tKof0uWmKfM0x5P0U0FReZjtR30vZfiOnEgKoANMH3KtgGQJGKIPb_C3jXbmnTQHgE
 AlcAa7PVfVeEMIWowIarvZUPPcCrBvfXq6juuWizXRwxFYMt7q59coKWmK2aOmvXtDKdj6Bafcz7
 jj7K_vQvxboT6.7KwtsgF5qPX9sVimmsWckbUMNTX5GOuoQj_kKcywUbm6T.vpkJMhskW0qCA3Gq
 Cc8ha8BqdQB9oXq0MNcGaKBM5q4eT7oEGZfvipYVdW7M1soTgE_RvRRA.pLB7zXwR_sExZtgZZlv
 zV9kC...or3ZUJqEh8MuhjzzBrqUFUWADJWEq6801IzuBb1pb5WuDuhQ_sxOrNZ1zzJcjZL6uP5T
 yib2ck2fDodvOKFG36q5bjgBmgfbivaJoHbM40meAHWK5lk7D3IpEyLqk7EmWb9eyGSc2zt51xGd
 PYgh15n9h7qUB5RTQTSCmH1pQgQH24snygYt42jqEfVRLwfc6vhITR9YVa7qTZ6ogpopfLy63Npf
 gC9dTlDtrgfL3caAQGJYtUksk939sE2QOLM8HV0uYVxOKRVtbir4cz9jSr.eNwz5Z0YlqmGuQWtH
 mHCIg4NpnviYf7vLbvyrI8iZRlDdSjecmvzgrJaJUudwRHdlEOTG.kYWYarJ07qw0h0yMoq7IK4Z
 dJ1KMiIdoXXQqBQgQ8g._nHyo.F4mJEACKGN6PmATQzu24AyO7kPsCrkgKV7vLZ8H3CFKQwWCwPZ
 SWZDFQCNzbHANXITKQf9Hv2Rtt5NRoNiUtJKqg8hS6hEnqgZJXKBfOOz9kIs8nBNnLckStqmyIKO
 JlwCNGylRHDzY.SrnESHfChTZZ5f4FnkXi3XQVPjwPnqMtVOV6vAFAK.Xswa0xEs0inhQBAuIyQW
 otk6bWZA8rrZrue_POr2jHD0JsVbCKfROMiIK8ZYAyaifa0CfwbBhKy9UlthG9hdJzXBnSNClzE5
 .7aN23YaeXPq0.FzjviO7Rh9GzEYufLSvOKY9vKtoD_T2qMZt0amdJqnXN8XT1m1NrrYoabL4OAc
 Lh03di3uSMJ4CoBDS7_E1pv1yQ74XkA19b9r6oeQ9aYRInxkFwbHrlOweDeW1hshfHtBW_AZ9Vp.
 32tzSIrfLBOBI4ztUrbsc5sOz6EU5kgmm3gN.YX0cUuuSLAT1m0XkjdEybehzfJXTon3m1g0tHcK
 2JbJ.yDvvCwhEVbMbYY_BA08DWDF_lZWmsSW6sjDEzFbSriLOzDvCTjx8_9ct4npWLUznFhL3789
 jHfImeMlj556iZjgFPnLTKeesz8WbAta1O9Spgqm3o_CrQdI.lu_u9gQAq0xO8ywf6ImE.mmsQO_
 X9QzIwa8aJUcJX_HRyYZzA6aurn0eXrmsUO3eWiUJdK3u0Tw3f.V299b9NfUJ91q_YAvAs_zUV1L
 ZETX.aUHNuq2q9fGysIq6nlsVnTjnJ5NIM83FOBMT.UNjDfLh3LIYBE1nuNg_.fFjL4kuA0byCgh
 oUpuIeit2zHh0eLEYRTLoQ8aRGcJo5wTDOKnNy3tGmRLsGtTyQsl6ETHdpLs4cSadjncoI9R2LPo
 7Ok3.qAo5S10u50zdb2B05LNqqL.VOl936vdyX4xqub7OtJV_aTUClo.3KuDdZhYRSlpHyfd1gwx
 oraekI6p.lBihNwLHuudYQ2Y3Y6xs9kz9xLP18vcBT.bbV7sh_jOWNffVRISkJiDsOsg3lr0qPtG
 ifhbecajtBTrqmRabxmXgBeaYV7q_h4I3QikVpbRYXnUW5b1f0HoQ.wGE5XlhnSCT1RdME2QHu3a
 Hm4duivIJtYoE1rkQHMiA66Ei3Fn57658UTmv6caDYAEmuBtKtF8J96X5jEki0cj_t.g6oJUWgw9
 qIaBxfrYtrw--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Thu, 8 Apr 2021 16:18:10 +0000
Received: by kubenode518.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 63e14078f60baa386ac5fb2941f90919;
          Thu, 08 Apr 2021 16:18:08 +0000 (UTC)
Subject: Re: [PATCH] selinux:Delete selinux_xfrm_policy_lookup() useless
 argument
To:     Zhongjun Tan <hbut_tan@163.com>, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        jmorris@namei.org, serge@hallyn.com, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        keescook@chromium.org, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, dhowells@redhat.com,
        kpsingh@google.com, christian.brauner@ubuntu.com,
        zohar@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Zhongjun Tan <tanzhongjun@yulong.com>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210408084907.841-1-hbut_tan@163.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <2304b75f-a3d0-3cb3-183c-0a7f62de9895@schaufler-ca.com>
Date:   Thu, 8 Apr 2021 09:18:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408084907.841-1-hbut_tan@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18033 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/2021 1:49 AM, Zhongjun Tan wrote:
> From: Zhongjun Tan <tanzhongjun@yulong.com>
>
> Delete selinux selinux_xfrm_policy_lookup() useless argument.
>
> Signed-off-by: Zhongjun Tan <tanzhongjun@yulong.com>
> ---
>  include/linux/lsm_hook_defs.h   | 3 +--
>  include/linux/security.h        | 4 ++--
>  net/xfrm/xfrm_policy.c          | 6 ++----
>  security/security.c             | 4 ++--
>  security/selinux/include/xfrm.h | 2 +-
>  security/selinux/xfrm.c         | 2 +-
>  6 files changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 04c0179..2adeea4 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -358,8 +358,7 @@
>  	 struct xfrm_sec_ctx *polsec, u32 secid)
>  LSM_HOOK(void, LSM_RET_VOID, xfrm_state_free_security, struct xfrm_state *x)
>  LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
> -LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid,
> -	 u8 dir)
> +LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid)
>  LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
>  	 struct xfrm_policy *xp, const struct flowi_common *flic)
>  LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,

Please update the descriptive comment at the top of the file.

> diff --git a/include/linux/security.h b/include/linux/security.h
> index 06f7c50..24eda04 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1681,7 +1681,7 @@ int security_xfrm_state_alloc_acquire(struct xfrm_state *x,
>  				      struct xfrm_sec_ctx *polsec, u32 secid);
>  int security_xfrm_state_delete(struct xfrm_state *x);
>  void security_xfrm_state_free(struct xfrm_state *x);
> -int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
> +int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid);
>  int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  				       struct xfrm_policy *xp,
>  				       const struct flowi_common *flic);
> @@ -1732,7 +1732,7 @@ static inline int security_xfrm_state_delete(struct xfrm_state *x)
>  	return 0;
>  }
>  
> -static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
> +static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
>  {
>  	return 0;
>  }
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index 156347f..d5d934e 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -1902,8 +1902,7 @@ static int xfrm_policy_match(const struct xfrm_policy *pol,
>  
>  	match = xfrm_selector_match(sel, fl, family);
>  	if (match)
> -		ret = security_xfrm_policy_lookup(pol->security, fl->flowi_secid,
> -						  dir);
> +		ret = security_xfrm_policy_lookup(pol->security, fl->flowi_secid);
>  	return ret;
>  }
>  
> @@ -2181,8 +2180,7 @@ static struct xfrm_policy *xfrm_sk_policy_lookup(const struct sock *sk, int dir,
>  				goto out;
>  			}
>  			err = security_xfrm_policy_lookup(pol->security,
> -						      fl->flowi_secid,
> -						      dir);
> +						      fl->flowi_secid);
>  			if (!err) {
>  				if (!xfrm_pol_hold_rcu(pol))
>  					goto again;
> diff --git a/security/security.c b/security/security.c
> index b38155b..0c1c979 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2466,9 +2466,9 @@ void security_xfrm_state_free(struct xfrm_state *x)
>  	call_void_hook(xfrm_state_free_security, x);
>  }
>  
> -int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
> +int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
>  {
> -	return call_int_hook(xfrm_policy_lookup, 0, ctx, fl_secid, dir);
> +	return call_int_hook(xfrm_policy_lookup, 0, ctx, fl_secid);
>  }
>  
>  int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
> diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
> index 0a6f34a..7415940 100644
> --- a/security/selinux/include/xfrm.h
> +++ b/security/selinux/include/xfrm.h
> @@ -23,7 +23,7 @@ int selinux_xfrm_state_alloc_acquire(struct xfrm_state *x,
>  				     struct xfrm_sec_ctx *polsec, u32 secid);
>  void selinux_xfrm_state_free(struct xfrm_state *x);
>  int selinux_xfrm_state_delete(struct xfrm_state *x);
> -int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
> +int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid);
>  int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  				      struct xfrm_policy *xp,
>  				      const struct flowi_common *flic);
> diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
> index 634f3db..be83e5c 100644
> --- a/security/selinux/xfrm.c
> +++ b/security/selinux/xfrm.c
> @@ -150,7 +150,7 @@ static int selinux_xfrm_delete(struct xfrm_sec_ctx *ctx)
>   * LSM hook implementation that authorizes that a flow can use a xfrm policy
>   * rule.
>   */
> -int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
> +int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid)
>  {
>  	int rc;
>  
