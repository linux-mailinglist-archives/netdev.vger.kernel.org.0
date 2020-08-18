Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E73247EDB
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 08:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHRG7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 02:59:46 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49859 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbgHRG7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 02:59:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CE49B580435;
        Tue, 18 Aug 2020 02:59:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 18 Aug 2020 02:59:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AiAH19
        zGAvIHlv696Mcil8R6McrqCvbYruRwkV0o8Aw=; b=pdfPKWNM6Irnc+8ym8CFfs
        SP5w1EMSKoPAm2SfNbKhWrHgJS4xQfI6Uc+Ts/+dLulGe7j0LDOJl3iqe3leNxx+
        V4fAhJrjmnVr9z9O0umygynlSv0WN1Nuf3XFL17PjRTCAUeN+hEJIyBXcjc00VkZ
        63s/0sniQnV+fakyXi3UhItN6ZinurwEpuLFq5PkUGtHsBz+vFawBzuButYMzMWJ
        1JoZeLPC184Oquz/HkIOELSpu33FczB5iH+y9eebmDcMTaXwj95W/7fQjc4fwqiT
        BYbCa8gb21o1IgBvbWbqVNkUOHYdrTtZ8au0z/4X7aM9l31mIeUcCWLL9IRe5Fqg
        ==
X-ME-Sender: <xms:X3w7XwATfLw_5QAt6KNvhDd-P1OMTy7n_NWwNSBcVmEtl1xvc-o6XA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddthedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeejledrudekvddrieefrdegvdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:X3w7Xygz3IV3C1FMYvaP5Lv0uzsZQhEE3SAQX_-47-frxSt4eXFVkg>
    <xmx:X3w7XzkQ-KRzxf14hefuBd4-PFKBBXQTP36544FmMcRNCSbLOr9i7g>
    <xmx:X3w7X2yKocNZ5KOu05ArrJned8N2ux5TeVQ-Kgu4MJU60vrUdSo-9A>
    <xmx:X3w7X7AnHayRxK3Tr21MXSQd16Qpxd_TyJbuvhdHC1RzMWYG8MtQTA>
Received: from localhost (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D1043280065;
        Tue, 18 Aug 2020 02:59:42 -0400 (EDT)
Date:   Tue, 18 Aug 2020 09:59:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, amcohen@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, roopa@nvidia.com, dsahern@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 6/6] mlxsw: spectrum_nve: Expose VXLAN
 counters via devlink-metric
Message-ID: <20200818065937.GA216252@shredder>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200817125059.193242-7-idosch@idosch.org>
 <20200817142952.GC2291654@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817142952.GC2291654@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 04:29:52PM +0200, Andrew Lunn wrote:
> > +static int mlxsw_sp1_nve_vxlan_metrics_init(struct mlxsw_sp *mlxsw_sp)
> > +{
> > +	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
> > +	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
> > +	int err;
> > +
> > +	err = mlxsw_sp1_nve_vxlan_counters_clear(mlxsw_sp);
> > +	if (err)
> > +		return err;
> > +
> > +	metrics->counter_encap =
> > +		devlink_metric_counter_create(devlink, "nve_vxlan_encap",
> > +					      &mlxsw_sp1_nve_vxlan_encap_ops,
> > +					      mlxsw_sp);
> > +	if (IS_ERR(metrics->counter_encap))
> > +		return PTR_ERR(metrics->counter_encap);
> > +
> > +	metrics->counter_decap =
> > +		devlink_metric_counter_create(devlink, "nve_vxlan_decap",
> > +					      &mlxsw_sp1_nve_vxlan_decap_ops,
> > +					      mlxsw_sp);
> > +	if (IS_ERR(metrics->counter_decap)) {
> > +		err = PTR_ERR(metrics->counter_decap);
> > +		goto err_counter_decap;
> > +	}
> > +
> > +	metrics->counter_decap_errors =
> > +		devlink_metric_counter_create(devlink, "nve_vxlan_decap_errors",
> > +					      &mlxsw_sp1_nve_vxlan_decap_errors_ops,
> > +					      mlxsw_sp);
> > +	if (IS_ERR(metrics->counter_decap_errors)) {
> > +		err = PTR_ERR(metrics->counter_decap_errors);
> > +		goto err_counter_decap_errors;
> > +	}
> > +
> > +	metrics->counter_decap_discards =
> > +		devlink_metric_counter_create(devlink, "nve_vxlan_decap_discards",
> > +					      &mlxsw_sp1_nve_vxlan_decap_discards_ops,
> > +					      mlxsw_sp);
> > +	if (IS_ERR(metrics->counter_decap_discards)) {
> > +		err = PTR_ERR(metrics->counter_decap_discards);
> > +		goto err_counter_decap_discards;
> > +	}
> > +
> > +	return 0;
> 
> Looking at this, i wonder about the scalability of this API. With just
> 4 counters it looks pretty ugly. What about 50 counters?
> 
> Maybe move the name into the ops structure. Then add a call
> devlink_metric_counters_create() where you can pass an array and array
> size of op structures? There are plenty of other examples in the
> kernel, e.g. sysfs groups, hwmon, etc. where you register a large
> bunch of things with the core with a single call.

Yes, good suggestion. Will add the ability to register multiple metrics
at once.

> 
> > +static void mlxsw_sp1_nve_vxlan_metrics_fini(struct mlxsw_sp *mlxsw_sp)
> > +{
> > +	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
> > +	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
> > +
> > +	devlink_metric_destroy(devlink, metrics->counter_decap_discards);
> > +	devlink_metric_destroy(devlink, metrics->counter_decap_errors);
> > +	devlink_metric_destroy(devlink, metrics->counter_decap);
> > +	devlink_metric_destroy(devlink, metrics->counter_encap);
> > +}
> 
> I guess the most frequent use case is to remove all counters,
> e.g. driver unload, or when probe fails. So maybe provide a
> devlink_metric_destroy_all(devlink) ?

If we are going to add something like devlink_metric_counters_create(),
then we can also add devlink_metrics_destroy() which will remove all
provided metrics in one call. I prefer it over _all() because then it's
symmetric with _create() operation.

Thanks!
