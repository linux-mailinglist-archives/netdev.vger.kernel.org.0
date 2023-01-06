Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9BD66073B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 20:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbjAFTfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 14:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjAFTfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 14:35:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A662DFE;
        Fri,  6 Jan 2023 11:35:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5197B81E5A;
        Fri,  6 Jan 2023 19:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D202C433F0;
        Fri,  6 Jan 2023 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673033739;
        bh=RZdhLY6yrPmpc5zUgoL4wYHvPBDC7USUI4m+anNKtyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SmAUfThysM+P8TNEcALYkzNEElYPr5YJMCWtXfpdKbGA24914V55kj6jmbyhnmgim
         K/g0g3lm2dzNfgamspL2jjUYZY919tDd3u6nJTox/BNFyaaTk1UYAugc58EV1+AfNV
         e+buAdDLzDpS7lvQAol6fr1p4eJaSpq4M0c1JO9v23vP42GClXhaEbGJu+3tXqIHaa
         IQTcbULZr4wYShyKjGeOERdbCq2wJQ+c7VcqhPzOxkM+tuwYdQr42BiH/W0R3OsHFa
         9O1ucuN1+bWpI9Cb9Urpsu8oWnK+O4WHpQd15AB2pOmMim384dDXNdcAn7ctVhSx0a
         /UOXPag8dr/0g==
Date:   Fri, 6 Jan 2023 11:35:38 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <Y7h4Cl/69g2yQzKh@x130>
References: <20230105041756.677120-1-saeed@kernel.org>
 <20230105103846.6dc776a3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230105103846.6dc776a3@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jan 10:38, Jakub Kicinski wrote:
>On Wed,  4 Jan 2023 20:17:48 -0800 Saeed Mahameed wrote:
>>   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
>>   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic
>
>How is the TC forwarding coming along?

Not aware of such effort, can you please elaborate ? 

