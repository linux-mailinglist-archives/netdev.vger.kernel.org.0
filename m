Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697D3200A47
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbgFSNfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:35:52 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:44625 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730512AbgFSNfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:35:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C389C580354;
        Fri, 19 Jun 2020 09:35:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 19 Jun 2020 09:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hTzkPo
        0nZf0l+04cu3f+Mx3KZiJZC5kWgKL24g9v/eI=; b=fa7Zb3NJdbg4NCX/WqSpp+
        ZPgutFM5uMuJ04X16YAPBKyE07NaIltfkjsg1wx3eAYb978P5x65hLr+SKTZpPw9
        +9zAzM9jSTLZF81g/T1PyXx/XT5y9i2hF4qQbdFDimQcrkowzHVKchpnm3DwpzEx
        kh5Hwce5u0z/CTNBzmonjEKLgfylf65jxhQa/F67OXouk3rntAWGffksGjDkXcZ/
        R9zj4mbytd0sr92gu3/hwYK/YqQy57NWAtUkprFCLsU3Vnr390kF+UrXHykk7yjS
        qrBibf6PS6GwnNyY+vk+46ve2CpNqNQEHFzwQWpVpT0X/gNMCQdy8X4ZkvN1/cNw
        ==
X-ME-Sender: <xms:Nr_sXpcVPh7JplU7YH19Dfkl12FnUHjOHEZ64Kc-OEhoTcjWTvNQxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppedutdelrdeijedrkedruddvleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Nr_sXnP3_sgkYo3f7QCe571rNZO6XYYiGx3QQEeSd6MUuqwax-r56g>
    <xmx:Nr_sXigGRXbTtUHmpSyn2V5rcx5oj0GHryQETKQgDGS_GJ006HrD5g>
    <xmx:Nr_sXi_7rgArlPfV3kF5Ha5XCmNC7a7GM-9v6UJGU9xMOE69aShcIA>
    <xmx:Nr_sXm9EMTn40dLUvj3V-2-RZEEWIVUEe_hPyqLi-huyQg1Y_ZDA4Q>
Received: from localhost (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF2663061856;
        Fri, 19 Jun 2020 09:35:49 -0400 (EDT)
Date:   Fri, 19 Jun 2020 16:35:48 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     dsatish <satish.d@oneconvergence.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: Re: [PATCH net-next 3/3] cls_flower: Allow flow offloading though
 masked key exist.
Message-ID: <20200619133548.GB400561@splinter>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
 <20200619094156.31184-4-satish.d@oneconvergence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619094156.31184-4-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 03:11:56PM +0530, dsatish wrote:
> A packet reaches OVS user space, only if, either there is no rule in
> datapath/hardware or there is race condition that the flow is added
> to hardware but before it is processed another packet arrives.
> 
> It is possible hardware as part of its limitations/optimizations
> remove certain flows.

Which driver is doing this? I don't believe it's valid to remove filters
from hardware and not tell anyone about it.

> To handle such cases where the hardware lost
> the flows, tc can offload to hardware if it receives a flow for which
> there exists an entry in its flow table. To handle such cases TC when
> it returns EEXIST error, also programs the flow in hardware, if
> hardware offload is enabled.
> 
> Signed-off-by: Chandra Kesava <kesavac@gmail.com>
> Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
> Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
> ---
>  net/sched/cls_flower.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index f1a5352cbb04..d718233cd5b9 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -431,7 +431,8 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
>  
>  static int fl_hw_replace_filter(struct tcf_proto *tp,
>  				struct cls_fl_filter *f, bool rtnl_held,
> -				struct netlink_ext_ack *extack)
> +				struct netlink_ext_ack *extack,
> +				unsigned long cookie)
>  {
>  	struct tcf_block *block = tp->chain->block;
>  	struct flow_cls_offload cls_flower = {};
> @@ -444,7 +445,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
>  
>  	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
>  	cls_flower.command = FLOW_CLS_REPLACE;
> -	cls_flower.cookie = (unsigned long) f;
> +	cls_flower.cookie = cookie;
>  	cls_flower.rule->match.dissector = &f->mask->dissector;
>  	cls_flower.rule->match.mask = &f->mask->key;
>  	cls_flower.rule->match.key = &f->mkey;
> @@ -2024,11 +2025,25 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>  	fl_init_unmasked_key_dissector(&fnew->unmasked_key_dissector);
>  
>  	err = fl_ht_insert_unique(fnew, fold, &in_ht);
> -	if (err)
> +	if (err) {
> +		/* It is possible Hardware lost the flow even though TC has it,
> +		 * and flow miss in hardware causes controller to offload flow again.
> +		 */
> +		if (err == -EEXIST && !tc_skip_hw(fnew->flags)) {
> +			struct cls_fl_filter *f =
> +				__fl_lookup(fnew->mask, &fnew->mkey);
> +
> +			if (f)
> +				fl_hw_replace_filter(tp, fnew, rtnl_held,
> +						     extack,
> +						     (unsigned long)(f));
> +		}
>  		goto errout_mask;
> +	}
>  
>  	if (!tc_skip_hw(fnew->flags)) {
> -		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
> +		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack,
> +					   (unsigned long)fnew);
>  		if (err)
>  			goto errout_ht;
>  	}
> -- 
> 2.17.1
> 
