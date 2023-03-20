Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB26C1390
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCTNhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjCTNhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:37:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762E524CB9;
        Mon, 20 Mar 2023 06:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BD46B80E8E;
        Mon, 20 Mar 2023 13:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DA0C4339B;
        Mon, 20 Mar 2023 13:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679319427;
        bh=ES5ffLVFjdHr94CCt9GJZbyU9jQQeLU3KV2xoFt+Yvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JNKB7JDNsM0RndtWdD/S3g+Fz2d7Byjno3GbARzOeYGh4jI+wRVsMSApHcimAFQyq
         j1zhUv3vTDlS6yhIWSDl34cNHo6H8wDrO899JzGp4rqxSDx5A1Q5JuosvbDHRHWja+
         iUc/sBqOmOzhWB7PVA+SPwwVFQBCWnjH5ejxs49yHEa4H59HE9/KMrPBos6xcoI6ek
         k+Bmy820+2YLkKtDxb20iX5gyKHxjC7ulf3EURVWvhePrSX+epesWm7QQ1V1WOqTIL
         u02Gd1Tnh5V/GjXBShGpZzDPczgZALrc3gopU7ADf2N258zMOasBAAx9InRa2c7KF7
         OE35HKbrOiaSA==
Date:   Mon, 20 Mar 2023 15:37:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tom Rix <trix@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>, rajur@chelsio.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] net: cxgb3: remove unused fl_to_qset function
Message-ID: <20230320133702.GL36557@unreal>
References: <20230319172433.1708161-1-trix@redhat.com>
 <20230319174525.kwhlxme7gh45b3un@soft-dev3-1>
 <21aad6c8-8abe-79e0-eb47-d03e964419a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21aad6c8-8abe-79e0-eb47-d03e964419a2@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 05:29:51AM -0700, Tom Rix wrote:
> 
> On 3/19/23 10:45 AM, Horatiu Vultur wrote:
> > The 03/19/2023 13:24, Tom Rix wrote:
> > 
> > Hi Tom,
> > 
> > > clang with W=1 reports
> > > drivers/net/ethernet/chelsio/cxgb3/sge.c:169:32: error: unused function
> > >    'fl_to_qset' [-Werror,-Wunused-function]
> > > static inline struct sge_qset *fl_to_qset(const struct sge_fl *q, int qidx)
> > >                                 ^
> > > This function is not used, so remove it.
> > Don't forget to mention in the subject which tree is targeting this
> > patch.
> 
> This and all my similar fixes/cleanup are against -next.
> 
> What prefix would you like to see ?

net-next

Thanks

> 
> Tom
> 
> > Other than that looks OK.
> > 
> > Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > 
> > > Signed-off-by: Tom Rix <trix@redhat.com>
> > > ---
> > >   drivers/net/ethernet/chelsio/cxgb3/sge.c | 5 -----
> > >   1 file changed, 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> > > index 62dfbdd33365..efa7f401529e 100644
> > > --- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
> > > +++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> > > @@ -166,11 +166,6 @@ static u8 flit_desc_map[] = {
> > >   #endif
> > >   };
> > > 
> > > -static inline struct sge_qset *fl_to_qset(const struct sge_fl *q, int qidx)
> > > -{
> > > -       return container_of(q, struct sge_qset, fl[qidx]);
> > > -}
> > > -
> > >   static inline struct sge_qset *rspq_to_qset(const struct sge_rspq *q)
> > >   {
> > >          return container_of(q, struct sge_qset, rspq);
> > > --
> > > 2.27.0
> > > 
> 
