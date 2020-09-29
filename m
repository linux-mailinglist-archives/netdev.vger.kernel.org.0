Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2129327DC2B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgI2WjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:39:03 -0400
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:43314
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728384AbgI2WjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601419139; bh=5H2Di+3rUkkCJ2VDEQ4Nf8oV0m+Uk7fsJ6yostsItLE=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=Jhn+rLxkKCk1Zb2ZrWCnc9ISLYyFViZhN+tYiXrJK+0ABVMlrvbHhWnCzREtejfj51qKtl7Q7EBu0AHVfurV+t43HayBhfo6QH5my6wfJRaVBb1y/JKM9E+2CrFv2HrMza76H+Sr12vcUI3EL+DPmTkDUZJCsmi3h5Qd0F30TqR/H6++xK4C6m8IT7OgPdsLM7JD3ooP/2WO+cwqazGVnZfgo8XKSZ5Ef1I0HBCsZamjKpxv6aO5mKdP2F9REfRna1XU4JaOp5COPkgQdTyJzAHKqlQImY9pUOO5F3p1VUW8I35ISxRhZwGJHUDOwgVK0lTmaGEAQ27vrPjadNabgw==
X-YMail-OSG: 5.K66VwVM1mtvjEvjGwCYWY8BYDodEWYV3Bty_gUYDxqF70lP1f4mB3lOGElnCS
 byrP7v51UVFqIhHBfA0Xjvp1Gvx6oWi4vDKS.TF2ob3ui7n3288vLwKhnu3U0vGzoBkEQYtRao0R
 mutO_M4.0ZKku9_moU458A.Ay0v6Wuyti3yPKtIKmjVQYsvoTeiOTyK5VncixegBuc9WESRIMgbj
 S5I2W8hrsjvdZizakh8W2P8UmAQWs3WNoOwTcvFa77cZxbWRQk_36xw94o9Xqtfhdh6a9XMGqKxj
 QxdoZbmcEkoRqE1zpgQjBsWYDv2tDZ0_3ikHypgW9Vs05blrWEIsT.f8JQWQIPIt9BIVKNH78Lal
 l0bGhFWhHwkEzBsCYwVITDrMWrGakT6cfGTAxRkFsyDRNm5967oEtDYFqhx0KOGbC7BOvkILCbmr
 W6rzXAYQRFHDsuF_hefXf4OoQy2sz3GTJ.RHB6_th2lHGu1UszoomV3l84aKk.zIPTDc3pLm3P2p
 k2qw4mcwOC23O6ScfOx_ck..tFU6.77dMvhkeAP.uZ3I7Scg8YyiRvfXlyjiDphKqK_vrJtBYBmf
 tc0hx4WFkYr5N4LXb2guXxsK3nRsRhp8EDXS9y2f5HCZ0feZWP0lMk6lwt9VSDPHFQqeK54Hjl7w
 hSzAc.63Kynf2W08Y.YMkl30ba_fiZuR3VTUMxljViv1._Rq82h1sFQwpeVnwT_TRbHMzWg1wrlh
 Fe8DJ0vH.uKI3e0uYlsTgJLawPqgFT1ct5JDxlZzD6UupgC10b.LQOlLXuMqdsmvIzAcGTmpEkP3
 .kWbmkjA0ZM4Xsz0QEh2xkwPld9mClujoh5N_POwp9TeoTYorcx.mWKHgfu3rh2iYYzyXs_X_tmE
 HEmpadtJv7v5B07XI0xcw1okBzSfTbYUGttwwpmQy_GKSAobMdoER7AT7VzKrvUMTs6oq2XH_fxQ
 xkgbHEDTXILYTJedb3ejsApF20Qwvdn63jzeIr6lhogYl9t48r7ZGNhjV4XVTfHAHVoGxoSxH9jm
 DAR4bBCyAj1bf7nl6pZCGCVsllgPuUhz6Uxv9RjUa7FrRD8OTGCz_qumkj8RW7hYNTSOZbNM5WUG
 o.Sh2VrQMVVmdYt92VTgcudl4oKYL91Is5rPRFkGHsFKAot.gQd4ayHPZo3by8kJtZbuPS3ou1Id
 pzd3VgJsVexYQFoWwAURz8R.BPkCgEUcqnNkhCmxzyYAtB9NHB9y3KlKsGyhKSXUG2RzWKV_cZ2l
 D8WUdhyksD_93_CXvsh4_ywLR0cCVIPx4O66bTQ.5CiY62iTsrmrknYhk5QnE87cf8PEMl1xe7AG
 dtHe2FcrTZu2lWnJ4BJSZ1pTuuqF7gMylznRHCFnQYrsUs2swcQsyTly5B_a4DRZluAnKY0DLuLM
 .FegG7oz7f8u4VGuzZ1wlSl41KNtKR8CUOkmz4B7G1S7_PuB4XMVBQJLcx6IfzKqfpVa.BbfDjbT
 vzsv2KTHEuR.nijf5eKbUOJpZ2ptfR4ug16nPAC1F9zIWF5jPDbO8rXCARr0y8MhEDdASgd7jrpO
 KH2w42D_VbJo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 29 Sep 2020 22:38:59 +0000
Received: by smtp402.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 22585821fbf3659c583798e09b6c7ac0;
          Tue, 29 Sep 2020 22:38:56 +0000 (UTC)
Subject: Re: [RFC PATCH] lsm,selinux: pass the family information along with
 xfrm flow
To:     Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org
References: <160141647786.7997.5490924406329369782.stgit@sifl>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <d42b766d-595a-b360-df13-0a3fe7a8bd7f@schaufler-ca.com>
Date:   Tue, 29 Sep 2020 15:38:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <160141647786.7997.5490924406329369782.stgit@sifl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.16718 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/2020 2:54 PM, Paul Moore wrote:
> As pointed out by Herbert in a recent related patch, the LSM hooks
> should pass the address family in addition to the xfrm flow as the
> family information is needed to safely access the flow.
>
> While this is not technically a problem for the current LSM/SELinux
> code as it only accesses fields common to all address families, we
> should still pass the address family so that the LSM hook isn't
> inherently flawed.  An alternate solution could be to simply pass
> the LSM secid instead of flow, but this introduces the problem of
> the LSM hook callers sending the wrong secid which would be much
> worse.
>
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

For what it may be worth

Acked-by: Casey Schaufler <casey@schaufler-ca.com>


> ---
>  include/linux/lsm_hook_defs.h   |    2 +-
>  include/linux/lsm_hooks.h       |    1 +
>  include/linux/security.h        |    7 +++++--
>  net/xfrm/xfrm_state.c           |    4 ++--
>  security/security.c             |    5 +++--
>  security/selinux/include/xfrm.h |    3 ++-
>  security/selinux/xfrm.c         |    3 ++-
>  7 files changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 2a8c74d99015..e3c3b5d20469 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -349,7 +349,7 @@ LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
>  LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid,
>  	 u8 dir)
>  LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
> -	 struct xfrm_policy *xp, const struct flowi *fl)
> +	 struct xfrm_policy *xp, const struct flowi *fl, unsigned short family)
>  LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,
>  	 int ckall)
>  #endif /* CONFIG_SECURITY_NETWORK_XFRM */
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 9e2e3e63719d..ea088aacfdad 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1093,6 +1093,7 @@
>   *	@x contains the state to match.
>   *	@xp contains the policy to check for a match.
>   *	@fl contains the flow to check for a match.
> + *	@family the flow's address family.
>   *	Return 1 if there is a match.
>   * @xfrm_decode_session:
>   *	@skb points to skb to decode.
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 0a0a03b36a3b..701b41eb090c 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1625,7 +1625,8 @@ void security_xfrm_state_free(struct xfrm_state *x);
>  int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
>  int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  				       struct xfrm_policy *xp,
> -				       const struct flowi *fl);
> +				       const struct flowi *fl,
> +				       unsigned short family);
>  int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid);
>  void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
>  
> @@ -1679,7 +1680,9 @@ static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_s
>  }
>  
>  static inline int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
> -			struct xfrm_policy *xp, const struct flowi *fl)
> +						     struct xfrm_policy *xp,
> +						     const struct flowi *fl,
> +						     unsigned short family)
>  {
>  	return 1;
>  }
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 69520ad3d83b..f90d2f1da44a 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1020,7 +1020,7 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
>  	if (x->km.state == XFRM_STATE_VALID) {
>  		if ((x->sel.family &&
>  		     !xfrm_selector_match(&x->sel, fl, x->sel.family)) ||
> -		    !security_xfrm_state_pol_flow_match(x, pol, fl))
> +		    !security_xfrm_state_pol_flow_match(x, pol, fl, family))
>  			return;
>  
>  		if (!*best ||
> @@ -1033,7 +1033,7 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
>  	} else if (x->km.state == XFRM_STATE_ERROR ||
>  		   x->km.state == XFRM_STATE_EXPIRED) {
>  		if (xfrm_selector_match(&x->sel, fl, x->sel.family) &&
> -		    security_xfrm_state_pol_flow_match(x, pol, fl))
> +		    security_xfrm_state_pol_flow_match(x, pol, fl, family))
>  			*error = -ESRCH;
>  	}
>  }
> diff --git a/security/security.c b/security/security.c
> index 70a7ad357bc6..62dd0af7c6bc 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2391,7 +2391,8 @@ int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
>  
>  int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  				       struct xfrm_policy *xp,
> -				       const struct flowi *fl)
> +				       const struct flowi *fl,
> +				       unsigned short family)
>  {
>  	struct security_hook_list *hp;
>  	int rc = LSM_RET_DEFAULT(xfrm_state_pol_flow_match);
> @@ -2407,7 +2408,7 @@ int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  	 */
>  	hlist_for_each_entry(hp, &security_hook_heads.xfrm_state_pol_flow_match,
>  				list) {
> -		rc = hp->hook.xfrm_state_pol_flow_match(x, xp, fl);
> +		rc = hp->hook.xfrm_state_pol_flow_match(x, xp, fl, family);
>  		break;
>  	}
>  	return rc;
> diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
> index a0b465316292..36907dd06647 100644
> --- a/security/selinux/include/xfrm.h
> +++ b/security/selinux/include/xfrm.h
> @@ -26,7 +26,8 @@ int selinux_xfrm_state_delete(struct xfrm_state *x);
>  int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
>  int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  				      struct xfrm_policy *xp,
> -				      const struct flowi *fl);
> +				      const struct flowi *fl,
> +				      unsigned short family);
>  
>  #ifdef CONFIG_SECURITY_NETWORK_XFRM
>  extern atomic_t selinux_xfrm_refcount;
> diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
> index 7314196185d1..5beb30237d3a 100644
> --- a/security/selinux/xfrm.c
> +++ b/security/selinux/xfrm.c
> @@ -175,7 +175,8 @@ int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
>   */
>  int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
>  				      struct xfrm_policy *xp,
> -				      const struct flowi *fl)
> +				      const struct flowi *fl,
> +				      unsigned short family)
>  {
>  	u32 state_sid;
>  
>
