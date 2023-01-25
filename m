Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5A367A912
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 04:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbjAYDGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 22:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYDGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 22:06:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321534ABD8;
        Tue, 24 Jan 2023 19:06:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C26D96137C;
        Wed, 25 Jan 2023 03:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D678BC433EF;
        Wed, 25 Jan 2023 03:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674615963;
        bh=lkioCqTqPS50saVSx5Ve7VfR137kJlO8Hf3JBx0IP7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vOU+XM7vPqfPUO0RYZWaZOmUDnWq6I/4GNCePFVYRwCSr1NOgL+tAJl9+UUYCsN5G
         Lc7S0VMgtwpZJ1p2eMKt13ginD+Km80FBM3HNsEICyVAS7HighyLuxT1V3sIjZg8pq
         teWlRwtGBWkTRgsJL9YAjw4U+lq7HLYFw6ciWaMowvb9vyvfHI2ze1DtPIZ+PBRb4t
         L1XhVO4KfARwaz5BZBmHBBBPKi7bcFJShjblFBoCvA28N4/XCPxYvOFHM97Hta32t4
         UBIfOj50kSk2weOEOuRNNRwij4AXUmx5WBqGgAMBb2JU3n+Wj8CaNr/S+KjxLoa5wQ
         de2vz/0g63M5w==
Date:   Tue, 24 Jan 2023 19:06:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <lnimi@hotmail.com>
Cc:     richardcochran@gmail.com, lee@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH net RFC 1/1] mfd/ptp: clockmatrix: support 32-bit
 address space
Message-ID: <20230124190601.6150f86d@kernel.org>
In-Reply-To: <MW5PR03MB69325F46D3E3B6473A228D1FA0C99@MW5PR03MB6932.namprd03.prod.outlook.com>
References: <MW5PR03MB69325F46D3E3B6473A228D1FA0C99@MW5PR03MB6932.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 10:41:09 -0500 Min Li wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> We used to assume 0x2010xxxx address. Now that we
> need to access 0x2011xxxx address, we need to
> support read/write the whole 32-bit address space.

Fist of all - you need to say a bit more about what you're doing.
You based this on net which would indicate it's a fix but it's enormous.
