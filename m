Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C411682897
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjAaJUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjAaJUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D0A269B;
        Tue, 31 Jan 2023 01:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C867B81A56;
        Tue, 31 Jan 2023 09:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5480DC433EF;
        Tue, 31 Jan 2023 09:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675156818;
        bh=YIpkb9oU+WXKr/Wvb4VBfYhVPXlTNuFv/QZLLcV7TvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=esJraJO6BpNLf49WHhYguEurnHI3UlWezjO4fs5mpD+i0cPTYMLaYjtJcC8Bh8KDW
         jpt56KxzhOj/jcSl+xorkwS/4WshRKS+H8W3AgjrhDgVyuYLXyQwUpc6ibtbFTFPdW
         NQ2sGHvrGB5R3rr+O+xrLsqhe+pATZxsRpxtiIou721+PpayZ8QyX4oQq8I2zt71GA
         1ELhbrZMAkgcLV7aW6561HiJSJvWbtqvODxngHg3WY+T7XFB+zwIUUX31zqN58mMhC
         lpUhaC6TQZOCrBT56bG9BfnfPNvTgtu75Wccp7YDfvvoRq9B2+x2/tIKcRqADAECLr
         VP0i4BrJ9ECQg==
Date:   Tue, 31 Jan 2023 11:20:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH] octeontx2-af: Removed unnecessary
 debug messages.
Message-ID: <Y9jdTjV1MwOQrBkC@unreal>
References: <20230130035556.694814-1-rkannoth@marvell.com>
 <Y9eUIfUkwf69ntJm@unreal>
 <MWHPR1801MB1918AEE92F5D6FEC4D19F923D3D09@MWHPR1801MB1918.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR1801MB1918AEE92F5D6FEC4D19F923D3D09@MWHPR1801MB1918.namprd18.prod.outlook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 07:11:10AM +0000, Ratheesh Kannoth wrote:
> ----------------------------------------------------------------------
> On Mon, Jan 30, 2023 at 09:25:56AM +0530, Ratheesh Kannoth wrote:
> > From: Sunil Goutham <sgoutham@marvell.com>
> > 
> > NPC exact match feature is supported only on one silicon variant, 
> > removed debug messages which print that this feature is not available 
> > on all other silicon variants.
> > 
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> > ---
> >  .../net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 12 
> > ++----------
> >  1 file changed, 2 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c 
> > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > index f69102d20c90..ad1374a12a40 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
> > @@ -200,10 +200,8 @@ void npc_config_secret_key(struct rvu *rvu, int blkaddr)
> >  	struct rvu_hwinfo *hw = rvu->hw;
> >  	u8 intf;
> >  
> > -	if (!hwcap->npc_hash_extract) {
> > -		dev_info(rvu->dev, "HW does not support secret key configuration\n");
> > +	if (!hwcap->npc_hash_extract)
> >  		return;
> > -	}
> >  
> >  	for (intf = 0; intf < hw->npc_intfs; intf++) {
> >  		rvu_write64(rvu, blkaddr, NPC_AF_INTFX_SECRET_KEY0(intf), @@ 
> > -221,10 +219,8 @@ void npc_program_mkex_hash(struct rvu *rvu, int blkaddr)
> >  	struct rvu_hwinfo *hw = rvu->hw;
> >  	u8 intf;
> >  
> > -	if (!hwcap->npc_hash_extract) {
> > -		dev_dbg(rvu->dev, "Field hash extract feature is not supported\n");
> > +	if (!hwcap->npc_hash_extract)
> >  		return;
> > -	}
> >  
> >  	for (intf = 0; intf < hw->npc_intfs; intf++) {
> >  		npc_program_mkex_hash_rx(rvu, blkaddr, intf); @@ -1854,16 +1850,12 
> > @@ int rvu_npc_exact_init(struct rvu *rvu)
> >  	/* Check exact match feature is supported */
> >  	npc_const3 = rvu_read64(rvu, blkaddr, NPC_AF_CONST3);
> >  	if (!(npc_const3 & BIT_ULL(62))) {
> > -		dev_info(rvu->dev, "%s: No support for exact match support\n",
> > -			 __func__);
> >  		return 0;
> >  	}
> 
> >You should remove () brackets here too.
> Ratheesh ->  Sorry , I did not get you. We have more than one statement in this "if" loop. How can we remove brackets ?

Please configure your email client to respect reply format.

Probably my typo mislead you, you need to remove {} brackets.

Before your change

     if (!(npc_const3 & BIT_ULL(62))) {
            dev_info(rvu->dev, "%s: No support for exact match support\n",
                     __func__);
            return 0;
     }

After your change:

    if (!(npc_const3 & BIT_ULL(62))) {
            return 0;
    }

Thanks
