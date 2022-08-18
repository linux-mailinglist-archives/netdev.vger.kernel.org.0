Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F44598433
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245134AbiHRN3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244585AbiHRN2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:28:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C3995B7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:28:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EAF4B81FC7
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 13:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C389FC433C1;
        Thu, 18 Aug 2022 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660829296;
        bh=L5fkpYofC6Khhao34O043Z6l2V4w4qVJSwajClbaQLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vFdyAEGi8vvQ4lkY4T70aFH7wU3j9vosnIr8Gu2wkVL7X8tC4oj5bfpzyJy/k1QtO
         BZYAkKgEjX2tr7VA7pk9qSKFPEJuDA9TYYc2UuhWxcTvlilXULdNo8ANTk0eVuuVl0
         AlG0C8rjvC9gvOYiqq8oWDrvmCw24h0CQ3HBzkIPQ5Ivrj8MDlrOLS2zPbEUJnrTBT
         xbMGONpuPArMBLzUwStO75NJeD0BSBx7nr8JhGbArgBXOSpuXxPYgQ6eW7oTnh5oZl
         sefCAeCb5GoI0eR5nYVym6Pnz8uWFUU/tsZPXopGWRCoclKq5QoBWpGt1Xarubu1Zm
         kbywiap5oeClw==
Date:   Thu, 18 Aug 2022 16:28:12 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 2/6] xfrm: allow state full offload mode
Message-ID: <Yv4+bFE3Ck96TFP3@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <de9490892eefc33723c1ae803adf881ad8ea621a.1660639789.git.leonro@nvidia.com>
 <20220818101220.GD566407@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818101220.GD566407@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:12:20PM +0200, Steffen Klassert wrote:
> On Tue, Aug 16, 2022 at 11:59:23AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Allow users to configure xfrm states with full offload mode.
> > The full mode must be requested both for policy and state, and
> > such requires us to do not implement fallback.
> > 
> > We explicitly return an error if requested full mode can't
> > be configured.
> > 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> This one needs to be ACKed by the driver maintainers.

Why? Only crypto is supported in upstream kernel.

Thanks
