Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A359932FF9C
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 09:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhCGI06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 03:26:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49519 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhCGI05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 03:26:57 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B21CF5C006B;
        Sun,  7 Mar 2021 03:26:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Mar 2021 03:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jxwJJ9
        i6ZcX5oVq2qFQ4h2Wu0auDbV9Z1EGDLuAIfxU=; b=ICEkr3PjMHQ//0w76QPfYm
        IBFc7T2zSQtDhdpVudaMQChn1sA4qJhIVo1HfeS/AhtL1NVD9sZLnG6ubwpdXtFW
        zFdqFpegTBZ5BC26Etat+acfhAe5lYI2PXNPawN+bS/yIpbaKFnmrOYqvdQFUQud
        uQU8btFWqgK68kVw4NE/w9he4j4ayJpp7cBDj7Vm7IeTtohyIVvfusxvor6BzEuw
        gA+HBaP1f+oN4zysdmAdDD4lLiLqmOeCzQIdC+4QvykVWxNekSHs2ZkM+YY40hqY
        8wcA6SlnasBMxoHK0lnO4DeASo+SIcD2x/5AozAomvWP8AkPBT0DxNcbnTd4bQWw
        ==
X-ME-Sender: <xms:UI5EYBuQ-ftuPUgtzZp08N4fu8vkb3rfOVzQuXA6aBzocnFUICgv3A>
    <xme:UI5EYKe5lAu-hLjZramXFPywhYLic4ov4wnsCrovmcnMlbXmFwMwIAjDEhKcVZ-Pq
    00oQad4NNC9zJU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtledgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UI5EYExuc3xomR4WHK03SrqY4itvKcVF-yxpjClscZASkmxEzb8JmA>
    <xmx:UI5EYIOqMY0ACBAibShIPOT_kvFvH6RTsLM8KyPFBsqAASMtJ9I_Kg>
    <xmx:UI5EYB8QX8Ql18_uKJ1Ef5hYptBeNrUcgK9SipzkroqV867Q95VpmA>
    <xmx:UI5EYNZLWDQwbK2so159Y1FPqe_CjHpF3M1iTbKXnIFFJNkrYoXvOw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE5BF24005B;
        Sun,  7 Mar 2021 03:26:55 -0500 (EST)
Date:   Sun, 7 Mar 2021 10:26:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, jiri@nvidia.com,
        idosch@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mellanox: mlxsw: fix error return code of
 mlxsw_sp_router_nve_promote_decap()
Message-ID: <YESOTOZIgAw2uwcd@shredder.lan>
References: <20210306140705.18517-1-baijiaju1990@gmail.com>
 <b735ad44-be13-2449-4c14-ebf2304fa3e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b735ad44-be13-2449-4c14-ebf2304fa3e9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 06, 2021 at 03:32:39PM +0100, Heiner Kallweit wrote:
> On 06.03.2021 15:07, Jia-Ju Bai wrote:
> > When fib_entry is NULL, no error return code of
> > mlxsw_sp_router_nve_promote_decap() is assigned.
> > To fix this bug, err is assigned with -EINVAL in this case.
> > 
> Again, are you sure this is a bug? To me it looks like it is
> intentional to not return an error code if fib_entry is NULL.
> Please don't blindly trust the robot results, there may
> always be false positives.

Yes, it is OK not to return an error. There is even a comment above the
call to mlxsw_sp_router_ip2me_fib_entry_find():

/* It is valid to create a tunnel with a local IP and only later
 * assign this IP address to a local interface
 */

> 
> > Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> > index 9ce90841f92d..7b260e25df1b 100644
> > --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> > @@ -1981,8 +1981,10 @@ int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
> >  	fib_entry = mlxsw_sp_router_ip2me_fib_entry_find(mlxsw_sp, ul_tb_id,
> >  							 ul_proto, ul_sip,
> >  							 type);
> > -	if (!fib_entry)
> > +	if (!fib_entry) {
> > +		err = -EINVAL;
> >  		goto out;
> > +	}
> >  
> >  	fib_entry->decap.tunnel_index = tunnel_index;
> >  	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP;
> > 
> 
