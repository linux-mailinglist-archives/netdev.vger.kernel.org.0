Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6835A6AD40F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 02:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCGBdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 20:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjCGBdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 20:33:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F576C895;
        Mon,  6 Mar 2023 17:32:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8896B81283;
        Tue,  7 Mar 2023 01:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4280AC433EF;
        Tue,  7 Mar 2023 01:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678152745;
        bh=EJo/w9osdGXrw0fp0h5jJPIkK8rkzG76FPt137jlcJk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JpKrN/+QfBTMvJbMTYxCZCpTe+Nl5WEqFHNtuGe0UmoLNoxyofoaECgSqaEruV5nC
         k18MOaf4llXqmtAJI2MW3cNjt7T1llwq0i/2eSG2o4Wgt6JmCD4nY24TZbr7LCMAuN
         VPdnQ2dbV1rCQLveEuzrzRal2n2cXNGI9vT36fgHDrrznT38JvoqUDfy+RZ5P2AjHd
         5T8YwMzN6qfCrOsHY7Kyq2bXggUInVxUVeQgXYkRWVLWfw5kJEooyUG7gibA9Q70l6
         3Ruc7Z9D/WUlqiFr4r8v8g8fNuA0jRPfibtc0cG3dTm1ZTU0Ul55+/CMQxSvF6MJvl
         RWZr9ADti9ywQ==
Date:   Mon, 6 Mar 2023 17:32:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@rothwell.id.au>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20230306173224.52afebb0@kernel.org>
In-Reply-To: <20230307115252.2b23c4f5@oak.ozlabs.ibm.com>
References: <20230307083703.558634a9@canb.auug.org.au>
        <d5b3d530-e050-1891-e5c0-8c98e136b744@gmail.com>
        <20230307115252.2b23c4f5@oak.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Mar 2023 11:52:52 +1100 Stephen Rothwell wrote:
> > Seems to be ok, false positive?
> > 
> > net: phy: smsc: fix link up detection in forced irq mode
> > Currently link up can't be detected in forced mode if polling
> > isn't used. Only link up interrupt source we have is aneg
> > complete which isn't applicable in forced mode. Therefore we
> > have to use energy-on as link up indicator.
> > 
> > Fixes: 7365494550f6 ("net: phy: smsc: skip ENERGYON interrupt if disabled")
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>  
> 
> It was committed by Jakub Kicinski <kuba@kernel.org>
> 
> $ git show --pretty=raw 58aac3a2ef41
> commit 58aac3a2ef414fea6d7fdf823ea177744a087d13
> tree 26bf9b3b866bd43baa1b8055d42536ac7ce3b3cf
> parent 89b59a84cb166f1ab5b6de9830e61324937c661e
> author Heiner Kallweit <hkallweit1@gmail.com> 1677927164 +0100
> committer Jakub Kicinski <kuba@kernel.org> 1678137790 -0800

Yes, my bad, sorry.
