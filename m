Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C098359904
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhDIJVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:21:17 -0400
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:52160 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231127AbhDIJVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 05:21:16 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2021 05:21:16 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 101561803E01B
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 09:11:35 +0000 (UTC)
Received: from omf07.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 4584F1E08;
        Fri,  9 Apr 2021 09:11:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id DABA3315D78;
        Fri,  9 Apr 2021 09:11:30 +0000 (UTC)
Message-ID: <92af36981fa72db5944d28c6a8d6974ec7aff3f2.camel@perches.com>
Subject: Re: [PATCH][next] mlxsw: spectrum_router: remove redundant
 initialization of variable force
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 09 Apr 2021 02:11:29 -0700
In-Reply-To: <20210329060441.GI1717@kadam>
References: <20210327223334.24655-1-colin.king@canonical.com>
         <20210329060441.GI1717@kadam>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DABA3315D78
X-Spam-Status: No, score=0.10
X-Stat-Signature: epsbekqwcfuww9tkg9yy6qf5xhxy1zq6
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+qOqSKZ/cujGok3IbgmEO4rhbVz7nVTK4=
X-HE-Tag: 1617959490-278192
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-29 at 09:04 +0300, Dan Carpenter wrote:
> On Sat, Mar 27, 2021 at 10:33:34PM +0000, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The variable force is being initialized with a value that is
> > never read and it is being updated later with a new value. The
> > initialization is redundant and can be removed.
> > 
> > Addresses-Coverity: ("Unused value")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> > index 6ccaa194733b..ff240e3c29f7 100644
> > --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> > @@ -5059,7 +5059,7 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
> >  {
> >  	u16 bucket_index = info->nh_res_bucket->bucket_index;
> >  	struct netlink_ext_ack *extack = info->extack;
> > -	bool force = info->nh_res_bucket->force;
> > +	bool force;
> >  	char ratr_pl_new[MLXSW_REG_RATR_LEN];
> >  	char ratr_pl[MLXSW_REG_RATR_LEN];
> >  	u32 adj_index;
> 
> Reverse Christmas tree.

Is still terrible style.

