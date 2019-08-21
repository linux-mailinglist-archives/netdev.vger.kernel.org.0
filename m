Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C07797D20
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfHUOet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:34:49 -0400
Received: from sonic307-15.consmr.mail.ne1.yahoo.com ([66.163.190.38]:45778
        "EHLO sonic307-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728502AbfHUOes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566398086; bh=c+ktxTchq1W7vlWOKuJS2QTEnt1jKeD9l42elwe5cpY=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=j8WhmQxoT42nFXkxcFnt2j83JiHbtkx22jmEPstpD8w6edNJYUnlxzsMOtRr8fpseqCOC58L0kCLpoDpasohbl2TUtHFQvNVViA0J7q34DVpxB4dVkE3kETDq7mNzJ+Tc9JDwAIDTIIZuR7fB51+XB0hkZ9H/rbMhbtIG7f10+6ocCLWAMGnFq48+kS5BlXv1gISMGCt0qzsYk27dYVZLMFujIEloh0a2KmvMSIM4JriRDPzXjiaUBmLMhcVKGvx02uq1t8Anzrp4WWc4kFDZad8o0skdjZmpQ/n7N/T0m9B2pH/+mkASHg5nezwCozEuay5AJC45051qU8VCbQIjA==
X-YMail-OSG: v__VqbQVM1myDsiiLNApWB5Zv.ydD_POrgCc1VMR6XsXirEIsxOMAdeyCAGYs2m
 rJbjMN_sAgc3ssN7dPHmuow9lyrqKkbCzGl7RlRN5Lgovo3g6KC3K12RW9NNLsPB8UOijedarTmY
 jYD5BSh0pFjhNJeWoq42OT63x.0Rg_NhtP6pTtZuE4kEgZSuKJfpceVEv90QLsdb1u6W6qTlWfXl
 nhI_fRRj5O7ojRgDo00JvKRJJW.uVhXfY3VVXqjttWliUu0q0dDAY5uZ21cuc_gE2zUY2GffuhZe
 uz7ZmYBzZmbi2Y_PyrDsGe8Z2L8vGGsxBnLZ4kujQLzswFN8YINKpiKqSJKzepzUdtns_z0hDXyE
 Xq3D6lyKRAZWcTNadWLLRt4XY8MMv_0M3R8XupDAKyX2kgUkMTDU99ChMau0lHzjCYJPqfH2GcDK
 3iTBobdr7OQMVSC2tKvhTyJVY0JTtFMoVYPa0H4ZB6CW2M_VuGSTsEyuCr.jMA0yM_hh3ILrhKbD
 vPBa2_9WdE278ycmD9k4.g4V9lQVNj44ZfJbDqiu2joc8GqmvkOUVqXi9iS.pR._UleYa9JJN6Hz
 VBIU_APCS0YGpONF55ODi.hQftY0VGgQr1liaDD5flB8OiM14QoOxdTcyRhkok2a2vGVUNvpphfk
 UgQkJRiufJNT5QCrbJJ6QrpSrwBTUTGK5sCqxtMfAPWMPN_sECpNrBoMbXsMYxAynhUrSpSlZ9Ff
 o7FhgA33vQQdLJ4kQl6tNRdqny4bZk8ZXijki_ASgRJCj8q0Ok34hDz53e_ypoUwrkWV6egIAq9T
 sS7d6p.42E_dBXpXwVzpHtULzo7WDtTyqJDraHq.4h_xQrXE9iJQEhm7icev6OjJdJx6s5Lh6hJ6
 NemefC4tHcYfQzNgOk.WnDhisZYGAfPm03B3XtsChQA04rbMMvWrcDRhpwkKKOTJ1qEeNhGzPN5l
 pRYxx3cAtSqJN9mN.eHuGMmlUW.KTj.0D1vCfwjbAYFi8BqlU97bHIEOOYxRc6fAN91hQT4ukYMw
 TycteaullznqxlwBFj0oEC3cxq9XrTRuQkmGSlzBvp_WNBUGz5AwV3GO06hAVmvut7cS1o3cVoe.
 GDKTz0FOgKorDkpvbkqGZdes2pUWkh7cc.cZRkUb.nHYZxxQjRMk8250LNGPGTVPPSZdRxqnSIAS
 93LUNyG7y6Lcpg3UEts5qyfU0LIYTty0zIKf9RNczScyl_FjahAY4z4Mp3jpo7tL9i0uABw9aM6t
 KdBYq6q.oPehNIXuLe95nYs.WbhDttxKZ0Oh8yiippPfngAZ2QXPz8O9gD7qK57g0QTAzqugfbsl
 meHQO2cU4BokYEOl_4.w71i5Dn_as
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Wed, 21 Aug 2019 14:34:46 +0000
Received: by smtp418.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 75c9412653c9ab979876bf5aee26bdb4;
          Wed, 21 Aug 2019 14:34:46 +0000 (UTC)
Subject: Re: [PATCH 1/2] rtnetlink: gate MAC address with an LSM hook
To:     Jeff Vander Stoep <jeffv@google.com>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
References: <20190821134547.96929-1-jeffv@google.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <e8f9e1ae-f9e4-987f-eb76-ebde8af4f4db@schaufler-ca.com>
Date:   Wed, 21 Aug 2019 07:34:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821134547.96929-1-jeffv@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/2019 6:45 AM, Jeff Vander Stoep wrote:
> MAC addresses are often considered sensitive because they are
> usually unique and can be used to identify/track a device or
> user [1].
>
> The MAC address is accessible via the RTM_NEWLINK message type of a
> netlink route socket[2]. Ideally we could grant/deny access to the
> MAC address on a case-by-case basis without blocking the entire
> RTM_NEWLINK message type which contains a lot of other useful
> information. This can be achieved using a new LSM hook on the netlink
> message receive path. Using this new hook, individual LSMs can select
> which processes are allowed access to the real MAC, otherwise a
> default value of zeros is returned. Offloading access control
> decisions like this to an LSM is convenient because it preserves the
> status quo for most Linux users while giving the various LSMs
> flexibility to make finer grained decisions on access to sensitive
> data based on policy.

Is the MAC address the only bit of skb data that you might
want to control with MAC? ( Sorry, couldn't help it ;) )
Just musing, but might it make more sense to leave the core
code unmodified and clear the MAC address in the skb inside
the LSM? If you did it that way you could address any other
data you want to control using the same hook. I would hate
to see separate LSM hooks for each of several bits of data.=20
On the other hand, I wouldn't want you to violate any layering
policies in the networking code. That would be wrong.

>
> [1] https://adamdrake.com/mac-addresses-udids-and-privacy.html
> [2] Other access vectors like ioctl(SIOCGIFHWADDR) are already covered
> by existing LSM hooks.
>
> Signed-off-by: Jeff Vander Stoep <jeffv@google.com>
> ---
>  include/linux/lsm_hooks.h |  8 ++++++++
>  include/linux/security.h  |  6 ++++++
>  net/core/rtnetlink.c      | 12 ++++++++++--
>  security/security.c       |  5 +++++
>  4 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index df1318d85f7d..dfcb2e11ff43 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -728,6 +728,12 @@
>   *
>   * Security hooks for Netlink messaging.
>   *
> + * @netlink_receive
> + *	Check permissions on a netlink message field before populating it.
> + *	@sk associated sock of task receiving the message.
> + *	@skb contains the sk_buff structure for the netlink message.
> + *	Return 0 if the data should be included in the message.
> + *
>   * @netlink_send:
>   *	Save security information for a netlink message so that permission
>   *	checking can be performed when the message is processed.  The secur=
ity
> @@ -1673,6 +1679,7 @@ union security_list_options {
>  	int (*sem_semop)(struct kern_ipc_perm *perm, struct sembuf *sops,
>  				unsigned nsops, int alter);
> =20
> +	int (*netlink_receive)(struct sock *sk, struct sk_buff *skb);
>  	int (*netlink_send)(struct sock *sk, struct sk_buff *skb);
> =20
>  	void (*d_instantiate)(struct dentry *dentry, struct inode *inode);
> @@ -1952,6 +1959,7 @@ struct security_hook_heads {
>  	struct hlist_head sem_associate;
>  	struct hlist_head sem_semctl;
>  	struct hlist_head sem_semop;
> +	struct hlist_head netlink_receive;
>  	struct hlist_head netlink_send;
>  	struct hlist_head d_instantiate;
>  	struct hlist_head getprocattr;
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 5f7441abbf42..46b5af6de59e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -382,6 +382,7 @@ int security_getprocattr(struct task_struct *p, con=
st char *lsm, char *name,
>  			 char **value);
>  int security_setprocattr(const char *lsm, const char *name, void *valu=
e,
>  			 size_t size);
> +int security_netlink_receive(struct sock *sk, struct sk_buff *skb);
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_ismaclabel(const char *name);
>  int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> @@ -1162,6 +1163,11 @@ static inline int security_setprocattr(const cha=
r *lsm, char *name,
>  	return -EINVAL;
>  }
> =20
> +static inline int security_netlink_receive(struct sock *sk, struct sk_=
buff *skb)
> +{
> +	return 0;
> +}
> +
>  static inline int security_netlink_send(struct sock *sk, struct sk_buf=
f *skb)
>  {
>  	return 0;
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1ee6460f8275..7d69fcb8d22e 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1650,8 +1650,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,=

>  		goto nla_put_failure;
> =20
>  	if (dev->addr_len) {
> -		if (nla_put(skb, IFLA_ADDRESS, dev->addr_len, dev->dev_addr) ||
> -		    nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast))
> +		if (skb->sk && security_netlink_receive(skb->sk, skb)) {
> +			if (!nla_reserve(skb, IFLA_ADDRESS, dev->addr_len))
> +				goto nla_put_failure;
> +
> +		} else {
> +			if (nla_put(skb, IFLA_ADDRESS, dev->addr_len,
> +				    dev->dev_addr))
> +				goto nla_put_failure;
> +		}
> +		if (nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast))
>  			goto nla_put_failure;
>  	}
> =20
> diff --git a/security/security.c b/security/security.c
> index 250ee2d76406..35c5929921b2 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1861,6 +1861,11 @@ int security_setprocattr(const char *lsm, const =
char *name, void *value,
>  	return -EINVAL;
>  }
> =20
> +int security_netlink_receive(struct sock *sk, struct sk_buff *skb)
> +{
> +	return call_int_hook(netlink_receive, 0, sk, skb);
> +}
> +
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb)
>  {
>  	return call_int_hook(netlink_send, 0, sk, skb);

