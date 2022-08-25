Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84225A17FA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbiHYRaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 13:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242777AbiHYRac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 13:30:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897997E818
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 10:30:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2ACAB82834
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 17:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75399C433B5;
        Thu, 25 Aug 2022 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661448628;
        bh=epO9j1uf9D/p+TbychYlE/iXaxfaNWoya1HjBilkCZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yp2qTntNBgd7UAKSuOKkjIbYJ60dtR9oans7hqXuFfBuuzmIyZw7Q8mdJMg+nKuG+
         wE9PK3lRvrY6DJLBTMJAW32dzS4KlPjAlNPVu1KWyJ0/v8G+/kz4ST+KZillb4IieE
         I5dUT6Y2e9lzwuLZ4od/ZqzvYeI5H/7hnu/GcixkpZQpxr2EJNpwQgDrjHTO2Ja+RR
         QgyVO8ZfhlGZ7iiezn9UAA5MWTsw1p4shR9PeywQ3Libpm0GP1tBsTaBKuiT7IVPAT
         2UJhC5PA6AmyIaXYypcHSih071TcWFqqB60jeEf6qqhEETK/wZ/YU9nxwNFUy0J5mC
         zCVp1DVodSYtg==
Date:   Thu, 25 Aug 2022 10:30:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Message-ID: <20220825103027.53fed750@kernel.org>
In-Reply-To: <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
        <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
        <20220825092957.26171986@kernel.org>
        <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 16:57:50 +0000 Keller, Jacob E wrote:
> > Sorry, I misinterpreted your previous reply, somehow I thought you
> > quoted option (3), because my fallible reading of mlx5 was that it
> > accepts multiple flags.
> > 
> > (First) option 2 is fine.
> 
> Even though existing behavior doesn't do that for ice right now and
> wouldn't be able to do that properly with old firmware?

Update your FW seems like a reasonable thing to ask customers to do.
Are there cables already qualified for the old FW which would switch
to No FEC under new rules?

Can you share how your FW picks the mode exactly?

There must be _some_ standardization here, because we're talking about
<5m cables, so we can safely assume it's linking to a ToR switch.
