Return-Path: <netdev+bounces-2553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5657A7027DC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11825281149
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03CD5A92A;
	Mon, 15 May 2023 09:09:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C4E8BFB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:09:16 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E09A7
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:09:14 -0700 (PDT)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20230515090912euoutp01636215e77e84b4fc229e1b7f9ce56379~fRgBQ4LB31070310703euoutp01k
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:09:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20230515090912euoutp01636215e77e84b4fc229e1b7f9ce56379~fRgBQ4LB31070310703euoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1684141752;
	bh=rggPCLxRkLbDt81t913xqS6ivsX2rO6bBG2+Kd5bXI8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Wty/KWRILaNKnwTA8UH5KKZ9lK/zOBx1nY+FkvfoTSEiZ/qfwIL9zm/nuCukDRA9g
	 7sUUfmX9diBwiXP/fRS3UZQD4aYQm7yU1kc9FWKS6dO7D+hpd0QMjeSkOLZHW1Qm8H
	 QoUQvODenhWKmKChYgXDYc5NDIDCzHVGe68HiAy4=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20230515090912eucas1p2fc59aec55a3fe9ab0c76ff81598a5bd0~fRgA88sS81683016830eucas1p2O;
	Mon, 15 May 2023 09:09:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 79.0E.42423.8B6F1646; Mon, 15
	May 2023 10:09:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7~fRgAm1JcZ2364823648eucas1p2c;
	Mon, 15 May 2023 09:09:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20230515090912eusmtrp1212bd7ee6c96ad264864f27bc5755e4b~fRgAmGZAC3052030520eusmtrp1x;
	Mon, 15 May 2023 09:09:12 +0000 (GMT)
X-AuditID: cbfec7f2-a51ff7000002a5b7-36-6461f6b859b6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id E9.11.14344.7B6F1646; Mon, 15
	May 2023 10:09:12 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20230515090911eusmtip2e31e7b454e813c3b4bf19f408c6a3dc4~fRgACtJjk2356723567eusmtip2r;
	Mon, 15 May 2023 09:09:11 +0000 (GMT)
Message-ID: <600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
Date: Mon, 15 May 2023 11:09:10 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
	Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc: kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
	moshe@nvidia.com
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20230510144621.932017-1-jiri@resnulli.us>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7djP87o7viWmGHzulLKYc76FxeLpsUfs
	FieOLWSxuHg13eLCtj5Wi+2z/7FYHFsgZvHt9BtGi289c9kcOD22rLzJ5LFgU6nH4j0vmTw2
	repk8+htfsfm8X7fVTaPqzerPT5vkgvgiOKySUnNySxLLdK3S+DKmHMksaDPouLvu3tMDYyb
	9boYOTkkBEwkOl+cZ+9i5OIQEljBKDFz3iIWCOcLo8SU/fvYIJzPjBINHR9YYVrm3frCBJFY
	DlQ1eRlUy0dGiSfvXoBV8QrYSTzd/p0dxGYRUJW4/2AfE0RcUOLkzCcsILaoQKrEqs0XmUFs
	YYEQiZlHf4PVMAuIS9x6Mh/MFhGwlPh67zczyAJmgcmMEof+X2cDSbAJGEp0ve0CszkFzCWO
	b21hhWiWl2jeOhusQULgB4fEp/vr2SHudpFo2nGABcIWlnh1fAtUXEbi9OQeFoiGdkaJBb/v
	M0E4E4C+fn6LEaLKWuLOuV9A6ziAVmhKrN+lD2JKCDhKTDmpBmHySdx4KwhxA5/EpG3TmSHC
	vBIdbUIQM9QkZh1fB7f14IVLzBMYlWYhBcssJO/PQvLNLIS1CxhZVjGKp5YW56anFhvmpZbr
	FSfmFpfmpesl5+duYgSmq9P/jn/awTj31Ue9Q4xMHIyHGCU4mJVEeNtnxqcI8aYkVlalFuXH
	F5XmpBYfYpTmYFES59W2PZksJJCeWJKanZpakFoEk2Xi4JRqYFrwWWTZftaN36Wqzs4W+xjj
	t+b73krlO9fKz3VtfxD1/KhKq94VbobZR2S/JnU1qUoYcv9WqFb6sMB7zUHXF6e2KR1evHLR
	Wp5jrE8mtAkmTl0woeUI+0erA3ZLrBRqGA879+06arN5/rerXYETklYdU8mY1udlNkmRJXH/
	s8nef6W+bPFXkv/Bdy249l3Tw6Xucxe9WPLrheEzS5dPKcKFiy2PONd2lL3nitC2WbJlkWSH
	+wKTqML1K3cvmyizMOR/AeuB+S7sq2Ovvu1nUUtTs/vu6epTqrhj7ZtH4vd+lOdJT49lWr8g
	u9DvntBl8VkKr60kHspWT/ttapf9l8nZdVnSQ61ZK2LNvtoEBfcrsRRnJBpqMRcVJwIAD9lT
	kMYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t/xe7o7viWmGLS9Y7SYc76FxeLpsUfs
	FieOLWSxuHg13eLCtj5Wi+2z/7FYHFsgZvHt9BtGi289c9kcOD22rLzJ5LFgU6nH4j0vmTw2
	repk8+htfsfm8X7fVTaPqzerPT5vkgvgiNKzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0
	No+1MjJV0rezSUnNySxLLdK3S9DLmHMksaDPouLvu3tMDYyb9boYOTkkBEwk5t36wtTFyMUh
	JLCUUeLW5nPsEAkZiZPTGlghbGGJP9e62CCK3jNK9J36zQaS4BWwk3i6/TtYA4uAqsT9B/uY
	IOKCEidnPmEBsUUFUiVOLr0BZgsLhEhsXTgLbCizgLjErSfzwepFBCwlvt77zQyygFlgMqNE
	/9kdYAkhATOJSaseM4LYbAKGEl1vu8AWcwqYSxzf2gI1yEyia2sXI4QtL9G8dTbzBEahWUju
	mIVk3ywkLbOQtCxgZFnFKJJaWpybnltspFecmFtcmpeul5yfu4kRGJ/bjv3csoNx5auPeocY
	mTgYDzFKcDArifC2z4xPEeJNSaysSi3Kjy8qzUktPsRoCgyMicxSosn5wASRVxJvaGZgamhi
	ZmlgamlmrCTO61nQkSgkkJ5YkpqdmlqQWgTTx8TBKdXANEWTU3Fm3Wx7n+QPcTfXFye+ant2
	6q/gHkZWvks/hf4Hijyt6A0582BX77zoTFFhJfNtLdHPlrX9qYiZwty8ZQ77uqbCuQLFky/L
	/GsqWvHZqNx2yro7ek8v5qSui+mt8nrrsY2rIzAv6M7UgHmF2Z97Wp7dnjzJ7syfdpUFyXnn
	N+zUu/Z0f7lFYtMC3ikyDxL7jV3Vf3pcbJ8fUlV574XL1GodZYu5d2Sv/49cFdtwI+LiPaXZ
	v6acVz/2L2eBt0L9BDv7L89viUxlV1KomxDv27+/fIXE6WnCXM7zOQ4qfXho4vtyyVcW5e+F
	TzW9t/05v/PJHKfZXzne8gVUZt+3F5A+XSkjwG9gP6WZQ4mlOCPRUIu5qDgRAFbe2mFYAwAA
X-CMS-MailID: 20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7
References: <20230510144621.932017-1-jiri@resnulli.us>
	<CGME20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7@eucas1p2.samsung.com>
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10.05.2023 16:46, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
>
> The commit 565b4824c39f ("devlink: change port event netdev notifier
> from per-net to global") changed original per-net notifier to be
> per-devlink instance. That fixed the issue of non-receiving events
> of netdev uninit if that moved to a different namespace.
> That worked fine in -net tree.
>
> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
> separate devlink instance for ethernet auxiliary device") and
> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
> case of PCI device suspend") were merged, a deadlock was introduced
> when removing a namespace with devlink instance with another nested
> instance.
>
> Here there is the bad flow example resulting in deadlock with mlx5:
> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
> devlink_pernet_pre_exit() -> devlink_reload() ->
> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
> mlx5e_destroy_devlink() -> devlink_free() ->
> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
>
> Steps to reproduce:
> $ modprobe mlx5_core
> $ ip netns add ns1
> $ devlink dev reload pci/0000:08:00.0 netns ns1
> $ ip netns del ns1
>
> Resolve this by converting the notifier from per-devlink instance to
> a static one registered during init phase and leaving it registered
> forever. Use this notifier for all devlink port instances created
> later on.
>
> Note what a tree needs this fix only in case all of the cited fixes
> commits are present.
>
> Reported-by: Moshe Shemesh <moshe@nvidia.com>
> Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
> Fixes: ee75f1fc44dd ("net/mlx5e: Create separate devlink instance for ethernet auxiliary device")
> Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

This patch landed recently in linux-next as commit e93c9378e33f 
("devlink: change per-devlink netdev notifier to static one"). 
Unfortunately it causes serious regression with kernel compiled from 
multi_v7_defconfig (ARM 32bit) on all my test boards. Here is a example 
of the boot failure observed on QEMU's virt ARM 32bit machine:

8<--- cut here ---
Unable to handle kernel execution of memory at virtual address e5150010 
when execute
[e5150010] *pgd=4267a811, *pte=04750653, *ppte=04750453
Internal error: Oops: 8000000f [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 779 Comm: ip Not tainted 6.4.0-rc2-next-20230515 #6688
Hardware name: Generic DT based system
PC is at 0xe5150010
LR is at notifier_call_chain+0x60/0x11c
pc : [<e5150010>]    lr : [<c0365f50>]    psr: 60000013
...
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 4397806a  DAC: 00000051
...
Process ip (pid: 779, stack limit = 0x82b757b5)
Stack: (0xe9201a00 to 0xe9202000)
...
  notifier_call_chain from raw_notifier_call_chain+0x18/0x20
  raw_notifier_call_chain from __dev_open+0x74/0x190
  __dev_open from __dev_change_flags+0x17c/0x1f4
  __dev_change_flags from dev_change_flags+0x18/0x54
  dev_change_flags from do_setlink+0x24c/0xefc
  do_setlink from rtnl_newlink+0x534/0x818
  rtnl_newlink from rtnetlink_rcv_msg+0x250/0x300
  rtnetlink_rcv_msg from netlink_rcv_skb+0xb8/0x110
  netlink_rcv_skb from netlink_unicast+0x1f8/0x2bc
  netlink_unicast from netlink_sendmsg+0x1cc/0x44c
  netlink_sendmsg from ____sys_sendmsg+0x9c/0x260
  ____sys_sendmsg from ___sys_sendmsg+0x68/0x94
  ___sys_sendmsg from sys_sendmsg+0x4c/0x88
  sys_sendmsg from ret_fast_syscall+0x0/0x54
Exception stack(0xe9201fa8 to 0xe9201ff0)
...
---[ end trace 0000000000000000 ]---
[....] Configuring network interfaces...Segmentation fault
ifup: failed to bring up lo


Reverting $subject patch on top of linux next-20230515 fixes this issue.


> ---
>   net/devlink/core.c          | 16 +++++++---------
>   net/devlink/devl_internal.h |  1 -
>   net/devlink/leftover.c      |  5 ++---
>   3 files changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/net/devlink/core.c b/net/devlink/core.c
> index 777b091ef74d..0e58eee44bdb 100644
> --- a/net/devlink/core.c
> +++ b/net/devlink/core.c
> @@ -204,11 +204,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>   	if (ret < 0)
>   		goto err_xa_alloc;
>   
> -	devlink->netdevice_nb.notifier_call = devlink_port_netdevice_event;
> -	ret = register_netdevice_notifier(&devlink->netdevice_nb);
> -	if (ret)
> -		goto err_register_netdevice_notifier;
> -
>   	devlink->dev = dev;
>   	devlink->ops = ops;
>   	xa_init_flags(&devlink->ports, XA_FLAGS_ALLOC);
> @@ -233,8 +228,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
>   
>   	return devlink;
>   
> -err_register_netdevice_notifier:
> -	xa_erase(&devlinks, devlink->index);
>   err_xa_alloc:
>   	kfree(devlink);
>   	return NULL;
> @@ -266,8 +259,6 @@ void devlink_free(struct devlink *devlink)
>   	xa_destroy(&devlink->params);
>   	xa_destroy(&devlink->ports);
>   
> -	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
> -
>   	xa_erase(&devlinks, devlink->index);
>   
>   	devlink_put(devlink);
> @@ -303,6 +294,10 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
>   	.pre_exit = devlink_pernet_pre_exit,
>   };
>   
> +static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
> +	.notifier_call = devlink_port_netdevice_event,
> +};
> +
>   static int __init devlink_init(void)
>   {
>   	int err;
> @@ -311,6 +306,9 @@ static int __init devlink_init(void)
>   	if (err)
>   		goto out;
>   	err = register_pernet_subsys(&devlink_pernet_ops);
> +	if (err)
> +		goto out;
> +	err = register_netdevice_notifier(&devlink_port_netdevice_nb);
>   
>   out:
>   	WARN_ON(err);
> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
> index e133f423294a..62921b2eb0d3 100644
> --- a/net/devlink/devl_internal.h
> +++ b/net/devlink/devl_internal.h
> @@ -50,7 +50,6 @@ struct devlink {
>   	u8 reload_failed:1;
>   	refcount_t refcount;
>   	struct rcu_work rwork;
> -	struct notifier_block netdevice_nb;
>   	char priv[] __aligned(NETDEV_ALIGN);
>   };
>   
> diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> index dffca2f9bfa7..cd0254968076 100644
> --- a/net/devlink/leftover.c
> +++ b/net/devlink/leftover.c
> @@ -7073,10 +7073,9 @@ int devlink_port_netdevice_event(struct notifier_block *nb,
>   	struct devlink_port *devlink_port = netdev->devlink_port;
>   	struct devlink *devlink;
>   
> -	devlink = container_of(nb, struct devlink, netdevice_nb);
> -
> -	if (!devlink_port || devlink_port->devlink != devlink)
> +	if (!devlink_port)
>   		return NOTIFY_OK;
> +	devlink = devlink_port->devlink;
>   
>   	switch (event) {
>   	case NETDEV_POST_INIT:

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


