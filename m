Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF172376C68
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhEGWSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:18:16 -0400
Received: from sonic317-39.consmr.mail.ne1.yahoo.com ([66.163.184.50]:34686
        "EHLO sonic317-39.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229978AbhEGWSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 18:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620425831; bh=+yQyyY7zclHTIByQYNIWTbhh35GfbYJfYE6s5N9CmTs=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=N/eZloie9OT6lcNUUv6AXxxIaGm8Y6m6aDNLPfPNsmllblo7x/WOithSwFS2YeBh1WZ5bBAy/g1OlhcLAzGtmKww3FU5CmSznhn1yYJg+gQuz4nWfIZanoT2fwrQ7tVlPyzFj0kLCJLWFgzd1bmFppg5Zzrz10uSb20MYCvTTAfzJ0Zv1BxscIN7PxPA54NdL+3PIEcyavUcGu0Obzw9VAO9nJ1hmsOyZ/z7uREfU3cx8tSWgUHT2vOcc2aC9Wof9GTNvTmZzkRDsCCLe+ZHUhKi0T4+yIRWXyHitZ8J2Iw4LtxJMojgY6XEBaVoiwASfI4Y+GfUNuxSwYMgdW4L7w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620425831; bh=nkygj/lE3+lZ/aZYa2pv6wTYWIu2xyuGcLrE866a1RK=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=qYk2wMaijlqOsizdzP4mSDSTrgWfFeMzZKS36QR4fjbxtrzt0/qQTHVDnb3gzEoH+7i/nb1JNn1fWvRxibPN4lzC7v6r4D8dcjdES4uMEJP2Mu+OqC7kSHXYcYVRIoDT8Tra/g6+EpGUQLGfiSZPjeIjhvgrqyTr+cAe4AdgXOKPsImJ8ANAu3v0CU/+hBTRWPi4uKW920kIDDKQXLE6Eoj3CS3yG47a9l2vZpfLUQi8vcGnGUFb9EgOL6me155d6yohxV/+3JUBHlib+emqCOcCn/9nynvxdmumG+wtlhMvQDxFgLlw2O1AxPS/2g9bmRmJDP+By0bFlnslZmDzZg==
X-YMail-OSG: rmsSlOcVM1mvhK60WN37ZRA2e6ho1Zk2u0QHTwpV77t9DzkzaG2oDRSGiNOYbDS
 E1oTaIkj2U.KX9Hr7Ktxw.bAPKFH6sJFuPZv6Ci7NHEUKLwaLpTyWoSrGy28fhzpM.PNuKw6k9A_
 ZEF6NOoGePp5WI7vMTzEHEmTmZSuOXYjV7UO4q117hbjszQ7llsedTCuTwfabFpeOgHlscD9HaYW
 x6NbEjqBVpkfQYiQhsBmFSppv3WLxAtTHdEJMGMR6u2uLI5A5vQig9qknefwxEhljxcJ8BiYhq7_
 UV043DiMabceyVipUShUzOnF22ndntTmdl734Q.m5HQ9qiLyI93KT6KfmuBTaKKAjG.PYFOgbsib
 z7ZiuuwjlqU0Purx_Zt555LnsKIQObZQEqPyjMcIoRRRoKCca1CCsK_C5ObBepIIFzB15tVCpnYR
 7I7r_MDBcohO1udA0FME6ZlceWAncy3hkAeWz_e0GiYehx13mXaNjeMJPTq6Be7kXnHADaePMVX4
 q_8ulnJh3ToB5mGI0by4Vy72oGVwtLZ_LwH8iJQKFyhwuOjlphwQp_p8A.CbMewV.qkuVCpuoveC
 WXQyMazoXuYbwqKE54LvkrSUpMIAIuUf4bdk0LZAngWr0QcWeD16vFFcUQIyQdsWkRQBVHIhFYxU
 OTkcsUvtXk1ikiGVWUffnf7bB7itgEIP3etXKKg_mZIFzx2EgyFzge_IktR1p3mWzdb.xrBISqb2
 B7N37biLlZJ1AAjcBe84XWcy1I8QKqzIdOMuIg6Rp.2kujBpmR_j_8uqzLn3hu_Ye_dg5dKhAlfp
 HFjoSttRHQtdhmStd_Nhd1fIdGqyOzobcbrEsuQkmNlETHyo2R1xTmRTxbG4r9GKXkVaimAIktqS
 BZB7RIB5emElOH3x7fJO_olkP.NBDGa9HFEViv9WyyF2iRjEZc8Hz8B4ySzZGyNUChYf_.quQB02
 uYm5Et81STEQ2xUpVMmRNIhl.tqsIYebFGLNCiP90..7ST1iFHk1kJj4fAMEngdC7RgdpdYjNhUr
 9TDwPatwrD1kYusx5MsSeHZa_Ca3YbusSW4eFZagPK2M5nRDtQGqN.dM0Q84yzZ_B0pCjYa.b43e
 0Xx4XoPJuVS2NSd_kQjxNA.MS_CU0VvodMf2ZhyzHHRTLA4TqaqehX9vh9nVgHgnst6SevHBnPxo
 To_JRbqJBKQV8TX.XPltF7nETr.Xuj7Dda4p__VOOTc.NzgUpAe4zaALfxk0JYZ4zkc5uKicdYG9
 aKO8CWHuHUOzCe_Ug9DF5Vxi8JkLrnDeA5_ETqaPycvsl4Qg2Mz63NutIEFzNBufb7UbzJSwJcVF
 1rqXOTWCUcl8j9TpX.eLRsEXE14vOw4QP39JtvOUUYB5PqEUCREPkU61DsFOh2ZNJYnAgyFgwHPp
 Im9Gbm4DToQ3cEyour.NO_HTvQExhEuWbHeTED50GVi59CHMM9OtbF.yvN5Nr5xfjzZvBI7y_X4p
 7Lxou.sh69LhI4nyUQcqB68Df1bsQjQWlMbq7XqQ4bpH9cpK.uu54suLv0oXmj8M4Xgdt_mU8ywL
 fRpMQTjiAFW49adt1wq5xpjACsPRoqhuHgIr.4reL7EKqgKwKX95GREx1AkjRqn7tBWCTG8sLnk8
 gaVE3Gd4C6nZ5Qou92otD7h.7TgzJbGmRVEkJxWBzlLuL_cpaadQq_eDYFq6eU157cPKIdDcp41p
 QZJACuk9pvFRKKlslvlKHkDA2FbpD8I9HhfEPSIcUQSfZPvcyC34lzRxExa5kJsDSyI6MRjSG83n
 z_OELBMicK40eR6DvA4PzYPSv3K2fBx_sBQ0RVO1P6Yn780hfu6j7cD3P1g00AXAV.Xsa7joSQf.
 UZATxuPC32DJPZz4XrkDm1ySySaByWRGWEOzSPiQZ.wYDI2hHT4jLnV.3LOcB96xXhDcoN_CRm0C
 OAxgaOZ1Yk4m2hYgvvGHDaM0fJDBKM92ki2Fgk1s5W6WEBZIp5ilX9GGalirNdDX.knRrAuTWAW8
 nClT7iQfGdnkfrU1PW_RgzbUvrDY0Dz5XIjQpAOEe.MyMR7fjrhR9JhLm2.8eMknGwYD843K2bfY
 jF.IgeGhNPbJEVDYx3e4KdiqeUPM3GIvdAw92hFAarC06ZgJ.4AKOJ07qGrTlc_owROoUkc1HMQ5
 H66KwomecOFlLW.gU0F5G.9More3oKxIgo5FAZjjL3OCHp8i_lyx_87q4Q5wi36NSL9Ve_GvMQi5
 AGUMeZdzJOvQmGMLoS9GnFhAd9R4j0jmqNh5FJmkYqB.kdpKx8gj80bz_J_I674O.aZJhwWMZvzp
 m04g.HOi9gyhT2UP1Bwe1UFn8JsrtBHVyDm_VYjWX6.QxIPF3UOfcJ5Qb1ksi0Yho5vI8SK.PpD4
 9SnI5vacM45njNi5Bb9XmE4Mk9ZVLsqKJE0QIENi7IbguMDTrAIlai7zqT62v1PO_4MYYnXKkBOT
 OfNUr7QWKTd.ARPLxiniGze5YEWZTNM0Iv55CkRcor5F7v_J_x6H5gZZDs4BqIk.1y5i6iWwEi_S
 ro2EYYKd9SAmxMD6UuvHSB6JkTsAaR90GHC5Nv5YACT2CSJ.XOKqaJUUkBpk_AttdcSkWtOl4Z2A
 loAqUJj8ozioO1MHF78HqQZB8D.D_s4M6QD8KXBfUhCS1LwQOy9Da_G6osLNuvYBPMQATaKBJ7AK
 .4ID7dLZnmQMMl.ngWMjSrrbbLx_pjvB52FErbCn0MOPVDvKfvE08RyI6XWinffAsK7taZ95Cam3
 n.kKAwPRUZkMIccAxUGZuO33kdpsJr1feqP3w7iLjzIq5g39L6PUvAl9iT76PKtTiynexcvp02.w
 iCN6d7bFfQXYkMEAW8T07o04oDJmEtXxUYyB3PTaLgmxGmPepuynY8CBieV5yeFdhnoKk.wVrZ_F
 1vvox4mt5m3IlXVbRCIWfN4sRa3FCnJ7vTgmRjW7AM8TsbtC1sQHV6qATpyrE6JcBqR12QHcGz.7
 gaKQuhraE9kQ5gB.YIziYG_aTdj02sN6fl5Vq6e.xlWQ18UZJpNxPIuASW2GXQ34qxfR.F.5JSGD
 S8ZioeHuVl1ZIlF5E1qRxGcFhjXe1zTav0OHLJ.KpSn2rbqq2JZtTsLMuEW2dM1UE0azatu7YbC4
 SDU63R1uCDptTcDFkPJAXLPAYD6jie2_jEq35CEbmHlx6xlAVTt4Pj7V1elnkzQCNcZjJBxEMFYT
 rDTl9PankJzh6oq5tKc9.Vy7Wn8nMW4fF5o8IEVIWkK3BFkChB7VpkE5qizzIWeYIjJiYk5fyutx
 GXaypF3OC3u5b
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 7 May 2021 22:17:11 +0000
Received: by kubenode565.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID d3800c9c0d52f5633b28fe4b012b96e7;
          Fri, 07 May 2021 22:17:09 +0000 (UTC)
Subject: Re: [PATCH] lockdown,selinux: fix bogus SELinux lockdown permission
 checks
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        selinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210507114048.138933-1-omosnace@redhat.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <a8d138a6-1d34-1457-9266-4abeddb6fdba@schaufler-ca.com>
Date:   Fri, 7 May 2021 15:17:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210507114048.138933-1-omosnace@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18295 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/2021 4:40 AM, Ondrej Mosnacek wrote:
> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> lockdown") added an implementation of the locked_down LSM hook to
> SELinux, with the aim to restrict which domains are allowed to perform
> operations that would breach lockdown.
>
> However, in several places the security_locked_down() hook is called in=

> situations where the current task isn't doing any action that would
> directly breach lockdown, leading to SELinux checks that are basically
> bogus.
>
> Since in most of these situations converting the callers such that
> security_locked_down() is called in a context where the current task
> would be meaningful for SELinux is impossible or very non-trivial (and
> could lead to TOCTOU issues for the classic Lockdown LSM
> implementation), fix this by adding a separate hook
> security_locked_down_globally()

This is a poor solution to the stated problem. Rather than adding
a new hook you should add the task as a parameter to the existing hook
and let the security modules do as they will based on its value.
If the caller does not have an appropriate task it should pass NULL.
The lockdown LSM can ignore the task value and SELinux can make its
own decision based on the task value passed.

>  that is to be used in such situations
> and convert all these problematic callers to call this hook instead. Th=
e
> new hook is then left unimplemented in SELinux and in Lockdown LSM it i=
s
> backed by the same implementation as the locked_down hook.
>
> The callers migrated to the new hook are:
> 1. arch/powerpc/xmon/xmon.c
>      Here the hook seems to be called from non-task context and is only=

>      used for redacting some sensitive values from output sent to
>      userspace.
> 2. fs/tracefs/inode.c:tracefs_create_file()
>      Here the call is used to prevent creating new tracefs entries when=

>      the kernel is locked down. Assumes that locking down is one-way -
>      i.e. if the hook returns non-zero once, it will never return zero
>      again, thus no point in creating these files.
> 3. kernel/trace/bpf_trace.c:bpf_probe_read_kernel{,_str}_common()
>      Called when a BPF program calls a helper that could leak kernel
>      memory. The task context is not relevant here, since the program
>      may very well be run in the context of a different task than the
>      consumer of the data.
>      See: https://bugzilla.redhat.com/show_bug.cgi?id=3D1955585
> 4. net/xfrm/xfrm_user.c:copy_to_user_*()
>      Here a cryptographic secret is redacted based on the value returne=
d
>      from the hook. There are two possible actions that may lead here:
>      a) A netlink message XFRM_MSG_GETSA with NLM_F_DUMP set - here the=

>         task context is relevant, since the dumped data is sent back to=

>         the current task.
>      b) When deleting an SA via XFRM_MSG_DELSA, the dumped SAs are
>         broadcasted to tasks subscribed to XFRM events - here the
>         SELinux check is not meningful as the current task's creds do
>         not represent the tasks that could potentially see the secret.
>      It really doesn't seem worth it to try to preserve the check in th=
e
>      a) case, since the eventual leak can be circumvented anyway via b)=
,
>      plus there is no way for the task to indicate that it doesn't care=

>      about the actual key value, so the check could generate a lot of
>      noise.
>
> Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lock=
down")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  arch/powerpc/xmon/xmon.c      | 4 ++--
>  fs/tracefs/inode.c            | 2 +-
>  include/linux/lsm_hook_defs.h | 1 +
>  include/linux/security.h      | 5 +++++
>  kernel/trace/bpf_trace.c      | 4 ++--
>  net/xfrm/xfrm_user.c          | 2 +-
>  security/lockdown/lockdown.c  | 1 +
>  security/security.c           | 6 ++++++
>  8 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index 3fe37495f63d..a4bad825d424 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -298,7 +298,7 @@ static bool xmon_is_locked_down(void)
>  	static bool lockdown;
> =20
>  	if (!lockdown) {
> -		lockdown =3D !!security_locked_down(LOCKDOWN_XMON_RW);
> +		lockdown =3D !!security_locked_down_globally(LOCKDOWN_XMON_RW);
>  		if (lockdown) {
>  			printf("xmon: Disabled due to kernel lockdown\n");
>  			xmon_is_ro =3D true;
> @@ -306,7 +306,7 @@ static bool xmon_is_locked_down(void)
>  	}
> =20
>  	if (!xmon_is_ro) {
> -		xmon_is_ro =3D !!security_locked_down(LOCKDOWN_XMON_WR);
> +		xmon_is_ro =3D !!security_locked_down_globally(LOCKDOWN_XMON_WR);
>  		if (xmon_is_ro)
>  			printf("xmon: Read-only due to kernel lockdown\n");
>  	}
> diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
> index 4b83cbded559..07241435efec 100644
> --- a/fs/tracefs/inode.c
> +++ b/fs/tracefs/inode.c
> @@ -396,7 +396,7 @@ struct dentry *tracefs_create_file(const char *name=
, umode_t mode,
>  	struct dentry *dentry;
>  	struct inode *inode;
> =20
> -	if (security_locked_down(LOCKDOWN_TRACEFS))
> +	if (security_locked_down_globally(LOCKDOWN_TRACEFS))
>  		return NULL;
> =20
>  	if (!(mode & S_IFMT))
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_def=
s.h
> index 477a597db013..d6e2a6b59277 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -390,6 +390,7 @@ LSM_HOOK(void, LSM_RET_VOID, bpf_prog_free_security=
, struct bpf_prog_aux *aux)
>  #endif /* CONFIG_BPF_SYSCALL */
> =20
>  LSM_HOOK(int, 0, locked_down, enum lockdown_reason what)
> +LSM_HOOK(int, 0, locked_down_globally, enum lockdown_reason what)
> =20
>  #ifdef CONFIG_PERF_EVENTS
>  LSM_HOOK(int, 0, perf_event_open, struct perf_event_attr *attr, int ty=
pe)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 8aeebd6646dc..e683dee84f46 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -468,6 +468,7 @@ int security_inode_notifysecctx(struct inode *inode=
, void *ctx, u32 ctxlen);
>  int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctx=
len);
>  int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctx=
len);
>  int security_locked_down(enum lockdown_reason what);
> +int security_locked_down_globally(enum lockdown_reason what);
>  #else /* CONFIG_SECURITY */
> =20
>  static inline int call_blocking_lsm_notifier(enum lsm_event event, voi=
d *data)
> @@ -1329,6 +1330,10 @@ static inline int security_locked_down(enum lock=
down_reason what)
>  {
>  	return 0;
>  }
> +static inline int security_locked_down_globally(enum lockdown_reason w=
hat)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_SECURITY */
> =20
>  #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b0c45d923f0f..f43bca95b261 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -215,7 +215,7 @@ const struct bpf_func_proto bpf_probe_read_user_str=
_proto =3D {
>  static __always_inline int
>  bpf_probe_read_kernel_common(void *dst, u32 size, const void *unsafe_p=
tr)
>  {
> -	int ret =3D security_locked_down(LOCKDOWN_BPF_READ);
> +	int ret =3D security_locked_down_globally(LOCKDOWN_BPF_READ);
> =20
>  	if (unlikely(ret < 0))
>  		goto fail;
> @@ -246,7 +246,7 @@ const struct bpf_func_proto bpf_probe_read_kernel_p=
roto =3D {
>  static __always_inline int
>  bpf_probe_read_kernel_str_common(void *dst, u32 size, const void *unsa=
fe_ptr)
>  {
> -	int ret =3D security_locked_down(LOCKDOWN_BPF_READ);
> +	int ret =3D security_locked_down_globally(LOCKDOWN_BPF_READ);
> =20
>  	if (unlikely(ret < 0))
>  		goto fail;
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index 5a0ef4361e43..5a56f74262d8 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -851,7 +851,7 @@ static int copy_user_offload(struct xfrm_state_offl=
oad *xso, struct sk_buff *skb
>  static bool xfrm_redact(void)
>  {
>  	return IS_ENABLED(CONFIG_SECURITY) &&
> -		security_locked_down(LOCKDOWN_XFRM_SECRET);
> +		security_locked_down_globally(LOCKDOWN_XFRM_SECRET);
>  }
> =20
>  static int copy_to_user_auth(struct xfrm_algo_auth *auth, struct sk_bu=
ff *skb)
> diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.=
c
> index 87cbdc64d272..4ac172eaa4b7 100644
> --- a/security/lockdown/lockdown.c
> +++ b/security/lockdown/lockdown.c
> @@ -73,6 +73,7 @@ static int lockdown_is_locked_down(enum lockdown_reas=
on what)
> =20
>  static struct security_hook_list lockdown_hooks[] __lsm_ro_after_init =
=3D {
>  	LSM_HOOK_INIT(locked_down, lockdown_is_locked_down),
> +	LSM_HOOK_INIT(locked_down_globally, lockdown_is_locked_down),
>  };
> =20
>  static int __init lockdown_lsm_init(void)
> diff --git a/security/security.c b/security/security.c
> index 5ac96b16f8fa..b9b990681ae9 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2547,6 +2547,12 @@ int security_locked_down(enum lockdown_reason wh=
at)
>  }
>  EXPORT_SYMBOL(security_locked_down);
> =20
> +int security_locked_down_globally(enum lockdown_reason what)
> +{
> +	return call_int_hook(locked_down_globally, 0, what);
> +}
> +EXPORT_SYMBOL(security_locked_down_globally);
> +
>  #ifdef CONFIG_PERF_EVENTS
>  int security_perf_event_open(struct perf_event_attr *attr, int type)
>  {

