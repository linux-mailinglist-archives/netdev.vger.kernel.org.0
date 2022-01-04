Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A06483E0B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiADIZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiADIZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:25:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806E5C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 00:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 116306124F
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EEDC36AEB;
        Tue,  4 Jan 2022 08:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641284757;
        bh=6YK4wOEGnHifsLOwKNkkxYh7YCsFLrn6bRWdzdwtux0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sobcsTrWNDQtnPMpytOsNmRXyoqGiHDTL0d4bKlROuwan0lTQd4sA6SyminFENKux
         bzDobHVy3wARZlsc6AsF+XOAEw2TGyO353w8htH2u8vyWaOHDbbZXfYEad4ghYD1vF
         LiSKu05Cjq2FGh3n3eye1hh08D7+KmvXb13v2cd1nyAilIz361vCoTpruO7TtW4f1e
         8Q6cc3Udgl8CVCxPt4U4vNz8pCRTZLCKeAnB2wlOYJaneXHIkSFBvi8GuJSLOXBq3U
         2G8ffLZNA3OmUEB4kmCvq/hcUL1rSBzI49bxVcQ8M3RLOUcSz4W+LqzIya/S2pHCFF
         +GBkW43gcVElQ==
Date:   Tue, 4 Jan 2022 00:25:55 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH net-next] net: vertexcom: default to disabled on kbuild
Message-ID: <20220104082555.s2ngia5hqvupplzi@sx1>
References: <20220102221126.354332-1-saeed@kernel.org>
 <20220103084321.48236cfa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220103084321.48236cfa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 08:43:21AM -0800, Jakub Kicinski wrote:
>On Sun,  2 Jan 2022 14:11:26 -0800 Saeed Mahameed wrote:
>> Sorry for being rude but new vendors/drivers are supposed to be disabled
>> by default, otherwise we will have to manually keep track of all vendors
>> we are not interested in building.
>
>Vendors default to y, drivers default to n. Vendors don't build
>anything, hence the somewhat unusual convention. Are you saying
>you want to change all the Kconfigs... including Mellanox?

I didn't know about the vendor vs drivers thing! What's the point ? :) 
Now as i think about it, Yes, why not change all vendors including Mellanox? 
I don't see any point to visit a sub-tree where nothing is going to build,
and waste a chunk of precious build time.

Anyhow, I can add the default 'n' to the driver and revert the
vendor back to 'y', Please let me know if you'd want that.


