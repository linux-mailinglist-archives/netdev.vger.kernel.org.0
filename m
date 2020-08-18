Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B25247E90
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 08:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgHRGmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 02:42:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41381 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgHRGmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 02:42:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D7EB15C0120;
        Tue, 18 Aug 2020 02:41:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 18 Aug 2020 02:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Bu5mfa
        9fz/9+wnEXOTTOBbXc50OOkn0cSbL0xVl4HO8=; b=CJuDl7hdJSzPdhyJhNhUs8
        pVsMtdEW2ax/KGl5qd6QiqaG/dymnjNpk/BppvpG/3gaf5EsbeSRIwH+zw4jx9mL
        8vSEtsLzshyCfte8p5Cb8m10E+QqQ1lDAP7EdZ0P875BxpyaqkeiaJWheuanHotE
        scdwrnW7+ML2neaiaa1YN3V4+5sfUU5xvyCroKs/ivBzhiPDHRard4hDvDMypCkG
        lN9QZzmxisiUH3ts2FsE3xG75grsMMdL2U5D/glCZlfb4MI8SCazrBq23TpYZocX
        iXCIvIEDfq5oH/jxmlBgdz3tnVW8dsBiJd1QlTv6pesnTdqgbYD7idL5QrlVK6Qg
        ==
X-ME-Sender: <xms:Nng7X8uu_Re6pll9zdIFCsVp2W5nRWeHKGoGfZ14f9CCZ40vWfsaSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddthedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeejledrudekvddrieefrdegvdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Nng7X5fqJ5fXBObh6hyKTsOLINLdRis86opROEWjnK8S5BW8FUNLRg>
    <xmx:Nng7X3zkVmWuvCcgnr71qD3ESnaV9_PC9MV6SV3gbuG-gSHX-m0CmQ>
    <xmx:Nng7X_MceqYSLU8i9uGVr2oGHGepIatL_n0RCW9yrJnqSk80rmfsxQ>
    <xmx:Nng7X7Yiq6xr6eJnTw61H5Sdo1DE8E5iFUd_LZN9fVH16qkS6DBV6w>
Received: from localhost (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88CC930600A3;
        Tue, 18 Aug 2020 02:41:57 -0400 (EDT)
Date:   Tue, 18 Aug 2020 09:41:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 03/11] mlxsw: spectrum_policer: Add policer core
Message-ID: <20200818064151.GA214959@shredder>
References: <20200715082733.429610-4-idosch@idosch.org>
 <20200817153824.GA1420904@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817153824.GA1420904@bjorn-Precision-5520>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 10:38:24AM -0500, Bjorn Helgaas wrote:
> You've likely seen this already, but Coverity found this problem:
> 
>   *** CID 1466147:  Control flow issues  (DEADCODE)
>   /drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c: 380 in mlxsw_sp_policers_init()
>   374     	}
>   375     
>   376     	return 0;
>   377     
>   378     err_family_register:
>   379     	for (i--; i >= 0; i--) {
>   >>>     CID 1466147:  Control flow issues  (DEADCODE)
>   >>>     Execution cannot reach this statement: "struct mlxsw_sp_policer_fam...".
>   380     		struct mlxsw_sp_policer_family *family;
>   381     
>   382     		family = mlxsw_sp->policer_core->family_arr[i];
>   383     		mlxsw_sp_policer_family_unregister(mlxsw_sp, family);
>   384     	}
>   385     err_init:
> 
> I think the problem is that MLXSW_SP_POLICER_TYPE_MAX is 0 because
> 
> > +enum mlxsw_sp_policer_type {
> > +	MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
> > +
> > +	__MLXSW_SP_POLICER_TYPE_MAX,
> > +	MLXSW_SP_POLICER_TYPE_MAX = __MLXSW_SP_POLICER_TYPE_MAX - 1,
> > +};
> 
> so we can only execute the family_register loop once, with i == 0,
> and if we get to err_family_register via the error exit:
> 
> > +	for (i = 0; i < MLXSW_SP_POLICER_TYPE_MAX + 1; i++) {
> > +		err = mlxsw_sp_policer_family_register(mlxsw_sp, mlxsw_sp_policer_family_arr[i]);
> > +		if (err)
> > +			goto err_family_register;
> 
> i will be 0, so i-- sets i to -1, so we don't enter the
> family_unregister loop body since -1 is not >= 0.

Thanks for the report, but isn't the code doing the right thing here? I
mean, it's dead code now, but as soon as we add another family it will
be executed. It seems error prone to remove it only to please Coverity
and then add it back when it's actually needed.

> 
> This code is now upstream as 8d3fbae70d8d ("mlxsw: spectrum_policer:
> Add policer core").
> 
> Bjorn
