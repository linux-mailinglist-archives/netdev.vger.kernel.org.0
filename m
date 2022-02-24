Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307604C22BB
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 04:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiBXD5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 22:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiBXD5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 22:57:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1BE637F
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 19:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C46B616D9
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E504C340E9;
        Thu, 24 Feb 2022 03:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645674990;
        bh=00ztu1J2DytCCOmxNAuD70BRohTdo4I3+TkpBbty9QM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k0XMwTvYTBmwtakd8R1Tjq1ajAhfyQCUgsE3aO3k19/Bb2GURKN4OmPJxOq0Z5HYB
         ybOq3UyWbY/GMaDcuSHxuYRih12e6p3GeitVWjHcrA7NwaGzH9S2CCM8Ps0pmzZ4Jw
         WeF6D/zQwNbIYBj6mupIqtiLwyJ2zbGCKfi7ldeDnTjCkMDSLyS53q4zrqeqHOkJg9
         4CzfyEsC65TMnz6pePJ7LeFLpKPwgkw37fwAWP5+i5GBCZWsvwxDmavqapP3oQgTAn
         2sdnEktmwSOjvrb2nTAh+SXuTwpxC++rNj12mVCYpHC+IGl0bDhFDbZ21k6p1HAnMC
         6yDBmstOm270g==
Date:   Wed, 23 Feb 2022 19:56:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 12/12] drivers: vxlan: vnifilter: add
 support for stats dumping
Message-ID: <20220223195628.21b279ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222025230.2119189-13-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-13-roopa@nvidia.com>
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

On Tue, 22 Feb 2022 02:52:30 +0000 Roopa Prabhu wrote:
> +	dump_stats = !!(tmsg->flags & TUNNEL_MSG_FLAG_STATS);

Are unknown flags rejected somewhere?
