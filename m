Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0401E62DAF6
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbiKQMdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbiKQMdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:33:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C5A72991
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:33:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF673615DC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19AAC433D7;
        Thu, 17 Nov 2022 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668688383;
        bh=Zy7kpAJxemp3zwd5ILu2lcVjy5qK2CS9uc8MvwGHNjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NKkNPZTQV5D+G9mCTGQ6Z12vmHSXvcn+p29T7Pt71RyB88r0kVOPzU10Ge3ZEsj2J
         L/CiAj1hPDOtFnR1zY0sx56zPV4wPPN4r9ffmDnjCA/yUrAoORlxQYa9AMLKlRvxWH
         pP9urBSu1MZ8Lt6/ia0mjZm/3+kTN9UVb+M5ip9gzrE/ixRlPElyd5ZxIepvAgw9ki
         NyyufKIFoU7kP6TWxFIkOroaw3IAnmdtiN5hs6SDFjMTyjC3LwETTndtKXIn/wai2b
         VpG+CFSFSu93VqA1DzmrNOJiUl5qAeCgX8KyRiyN6M6H/9QL+HrpGOrjmTMvKZRJy8
         lbiENs81gksQw==
Date:   Thu, 17 Nov 2022 14:32:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 7/8] xfrm: add support to HW update soft and
 hard limits
Message-ID: <Y3Yp+lgJ/rECQCCh@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <04470fb030f9690331fe44c217c29eed95af1dc6.1667997522.git.leonro@nvidia.com>
 <20221117121357.GK704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117121357.GK704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:13:57PM +0100, Steffen Klassert wrote:
> On Wed, Nov 09, 2022 at 02:54:35PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> > index ce9e360a96e2..819c7cd87d6b 100644
> > --- a/net/xfrm/xfrm_output.c
> > +++ b/net/xfrm/xfrm_output.c
> > @@ -560,7 +560,6 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
> >  			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATEPROTOERROR);
> >  			goto error_nolock;
> >  		}
> > -
> 
> Nit: No need to remove that empty line.
>

Sure, will fix in v8.
