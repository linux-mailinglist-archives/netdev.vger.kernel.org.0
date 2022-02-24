Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39AE4C2176
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiBXCBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 21:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiBXCBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 21:01:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889FF6006E;
        Wed, 23 Feb 2022 18:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FD88B82195;
        Thu, 24 Feb 2022 02:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EA2C340EF;
        Thu, 24 Feb 2022 02:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645668029;
        bh=bHfD1tT0ZlUND9FKfmd0S/BTbFuRax0UksZLHpXWCj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gxxfq/7kL4TuQqN34oOaaLfw2TSmwRF1/ak3CFbPLhqb0LTIFF4V/WMXk7GKXWSy9
         HAsJ2q+qMS31MpLy+h2LJOwRxXAHnD92NhfnkJR4Bv6o06oZ5Wh2ni774fc6PribBL
         CQZj67r5npCLMg7SHyR3xyeLJth60iiJ+Q/kpP+ueUBRz3DPs3hqJwI9eXpomN6OKD
         Okx4ex6KK0o0mb72D4sVXXzUCBJ0FGJSbyW+m19tPvO5BxTuljUFCi3yyofXhbhQ7w
         /D1zT/XpaXL/xetfnKKrMYrfWsNKOTe8JKWr6+40MgJeZTvEtTXvfUzJkdADO46oTD
         UW60koaJUrW7g==
Date:   Wed, 23 Feb 2022 18:00:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [mlx5-next 13/17] net/mlx5: Use mlx5_cmd_do() in core
 create_{cq,dct}
Message-ID: <20220223180028.47f14132@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223235702.ytu6fqi4shbk3rnk@sx1>
References: <20220223050932.244668-1-saeed@kernel.org>
        <20220223050932.244668-14-saeed@kernel.org>
        <20220223152031.283993fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220223235702.ytu6fqi4shbk3rnk@sx1>
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

On Wed, 23 Feb 2022 15:57:02 -0800 Saeed Mahameed wrote:
> On 23 Feb 15:20, Jakub Kicinski wrote:
> >On Tue, 22 Feb 2022 21:09:28 -0800 Saeed Mahameed wrote:  
> >> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>  
> >
> >nit: double-signed  
> 
> different emails, the patch was authored back then when i had the mellanox
> email, If I want to keep the original author email, then i must sign with both
> emails, once as author and once as submitter.
> 
> The other option is to override the author email with the new email, but
> I don't like to mess around with history ;).. 

Ack, just an FYI, don't think the bots will actually catch this case.
