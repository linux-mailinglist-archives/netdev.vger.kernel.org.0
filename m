Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B6B309643
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhA3Pc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 10:32:26 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43805 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232190AbhA3Oxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:53:38 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 0D650FCF;
        Sat, 30 Jan 2021 09:52:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 30 Jan 2021 09:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PThE7V
        bT0Enbf8p+yipFgj5/aS7fc//trleuhyaBLOg=; b=BNfEKH7RHf+PPxYIYnZETP
        KiCqqh5Fho2fexOa5Jatk0GnuMi6Zbo58rwPjz46WkbtThbs9Dr+DM4QV06IY7F1
        krW2j+FRlFfxcSCxvDiReuvX0f+obVs20OI8Kjmv7tkMaW3kUG7GW7qy/qiJKXO3
        xv7Sm/09e+rj5Ulg3AcbQszYUBvdDTIZWyCXuISwoAcwwO2h51bfvL0u6K7aApM6
        ayK+rC/hwQkELHx0TNNmSa9hxgPuIvDWW17JXWgLzV2A/95v8Y6ffCwmQtBQgf1L
        Sgu4cyJ0qO/bD19hyEvlNBkjUugedtsrhJK9mEfGKaFHkEC2zST3u61g9kkmpsBQ
        ==
X-ME-Sender: <xms:r3IVYJOHq3Vr_t3HpN5Q5rq9dWrtJRw4B8CPF4vvkvIdZaM11j7F0Q>
    <xme:r3IVYL_nUPMUvNgalV-A_g4cHIpwqjnm2tXWk319GgUpSB634RoQoEpA5GlwPEpiN
    EyUT2tRa8uKVlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:r3IVYISeHIcARXCd_e3s4GLhSKGUFKKTkltQeDcPoGmylljqjxE6lw>
    <xmx:r3IVYFuCLRyCgwVUW9sXDlc0d7nMAoF0Mg7da6tEbkC9MFUGAYo0Qg>
    <xmx:r3IVYBcHpjRyknEDWCU0W3wcUyWBgwoNywFNkJQlpaYI1_mM_yiMfA>
    <xmx:r3IVYCpA7PMb_bUOapEBs657e6sar_np17KxLRmuldpD2NtXMDvNpw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B96A81080057;
        Sat, 30 Jan 2021 09:52:30 -0500 (EST)
Date:   Sat, 30 Jan 2021 16:52:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        saeedm@nvidia.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210130145227.GB3329243@shredder.lan>
References: <20210130023319.32560-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210130023319.32560-1-cmi@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 10:33:19AM +0800, Chris Mi wrote:
> In order to send sampled packets to userspace, NIC driver calls
> psample api directly. But it creates a hard dependency on module
> psample. Introduce psample_ops to remove the hard dependency.
> It is initialized when psample module is loaded and set to NULL
> when the module is unloaded.
> 
> Reported-by: kernel test robot <lkp@intel.com>

This belongs in the changelog (that should be part of the commit
message). Something like "Fix xxx reported by kernel test robot".

> Signed-off-by: Chris Mi <cmi@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
> v1->v2:
>  - fix sparse errors
> v2->v3:
>  - remove inline
> v3->v4:
>  - add inline back
> v4->v5:
>  - address Jakub's comments
> 
>  include/net/psample.h    | 26 ++++++++++++++++++++++++++
>  net/psample/psample.c    | 14 +++++++++++++-
>  net/sched/Makefile       |  2 +-
>  net/sched/psample_stub.c |  5 +++++
>  4 files changed, 45 insertions(+), 2 deletions(-)
>  create mode 100644 net/sched/psample_stub.c
> 
> diff --git a/include/net/psample.h b/include/net/psample.h
> index 68ae16bb0a4a..d0f1cfc56f6f 100644
> --- a/include/net/psample.h
> +++ b/include/net/psample.h
> @@ -14,6 +14,15 @@ struct psample_group {
>  	struct rcu_head rcu;
>  };
>  
> +struct psample_ops {
> +	void (*sample_packet)(struct psample_group *group, struct sk_buff *skb,
> +			      u32 trunc_size, int in_ifindex, int out_ifindex,
> +			      u32 sample_rate);
> +
> +};
> +
> +extern const struct psample_ops __rcu *psample_ops __read_mostly;
> +
>  struct psample_group *psample_group_get(struct net *net, u32 group_num);
>  void psample_group_take(struct psample_group *group);
>  void psample_group_put(struct psample_group *group);
> @@ -35,4 +44,21 @@ static inline void psample_sample_packet(struct psample_group *group,
>  
>  #endif
>  
> +static inline void
> +psample_nic_sample_packet(struct psample_group *group,
> +			  struct sk_buff *skb, u32 trunc_size,
> +			  int in_ifindex, int out_ifindex,
> +			  u32 sample_rate)
> +{
> +	const struct psample_ops *ops;
> +
> +	rcu_read_lock();
> +	ops = rcu_dereference(psample_ops);
> +	if (ops)
> +		ops->sample_packet(group, skb, trunc_size,
> +				   in_ifindex, out_ifindex,
> +				   sample_rate);
> +	rcu_read_unlock();
> +}
> +
>  #endif /* __NET_PSAMPLE_H */
> diff --git a/net/psample/psample.c b/net/psample/psample.c
> index 33e238c965bd..983ca5b698fe 100644
> --- a/net/psample/psample.c
> +++ b/net/psample/psample.c
> @@ -8,6 +8,7 @@
>  #include <linux/kernel.h>
>  #include <linux/skbuff.h>
>  #include <linux/module.h>
> +#include <linux/rcupdate.h>
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
>  #include <net/netlink.h>
> @@ -35,6 +36,10 @@ static const struct genl_multicast_group psample_nl_mcgrps[] = {
>  
>  static struct genl_family psample_nl_family __ro_after_init;
>  
> +static const struct psample_ops psample_sample_ops = {
> +	.sample_packet	= psample_sample_packet,
> +};
> +
>  static int psample_group_nl_fill(struct sk_buff *msg,
>  				 struct psample_group *group,
>  				 enum psample_command cmd, u32 portid, u32 seq,
> @@ -456,11 +461,18 @@ EXPORT_SYMBOL_GPL(psample_sample_packet);
>  
>  static int __init psample_module_init(void)
>  {
> -	return genl_register_family(&psample_nl_family);
> +	int ret;
> +
> +	ret = genl_register_family(&psample_nl_family);
> +	if (!ret)
> +		RCU_INIT_POINTER(psample_ops, &psample_sample_ops);
> +	return ret;
>  }
>  
>  static void __exit psample_module_exit(void)
>  {
> +	rcu_assign_pointer(psample_ops, NULL);
> +	synchronize_rcu();
>  	genl_unregister_family(&psample_nl_family);
>  }
>  
> diff --git a/net/sched/Makefile b/net/sched/Makefile
> index dd14ef413fda..0d92bb98bb26 100644
> --- a/net/sched/Makefile
> +++ b/net/sched/Makefile
> @@ -3,7 +3,7 @@
>  # Makefile for the Linux Traffic Control Unit.
>  #
>  
> -obj-y	:= sch_generic.o sch_mq.o
> +obj-y	:= sch_generic.o sch_mq.o psample_stub.o

Why the stub is under net/sched/ when psample is at net/psample/?
psample is not the same as 'act_sample'.

>  
>  obj-$(CONFIG_INET)		+= sch_frag.o
>  obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o
> diff --git a/net/sched/psample_stub.c b/net/sched/psample_stub.c
> new file mode 100644
> index 000000000000..0541b8c5100d
> --- /dev/null
> +++ b/net/sched/psample_stub.c
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB

psample has "// SPDX-License-Identifier: GPL-2.0-only"

> +/* Copyright (c) 2021 Mellanox Technologies. */
> +
> +const struct psample_ops __rcu *psample_ops __read_mostly;
> +EXPORT_SYMBOL_GPL(psample_ops);
> -- 
> 2.26.2
> 
