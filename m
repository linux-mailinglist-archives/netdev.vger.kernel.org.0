Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF459C5F4
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbiHVSUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbiHVSUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EAF46DB1;
        Mon, 22 Aug 2022 11:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AAE2B81683;
        Mon, 22 Aug 2022 18:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F99C433D6;
        Mon, 22 Aug 2022 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661192437;
        bh=LlBxykWoZQwodmX5FxMR+FUrDuvQCckhPJY4+3QYhbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sAb+OzxXQcn1N7HBW4vlo7sl4yq+5o8hhTjKafODJFEJ4GNh0vTwRGu+ZbUb4NUUK
         0s5ZIEHD/5SBvXzni51NNyFB6MHOO4RKaZmLX3IGLqT4I9NbmGnzXCkI0VkRz4vxsX
         Z9ESOinZzo4F/VQbBkoPsqgBmV9kyHdx9vhonBg2fTQBP0YD437XwnxreZElWB+xMD
         zLbQ09+fP7frpezDWKSIK/GnkqCUqSb/EmuyfkFYWN0TzQu0G/5hjBXwWp9tC0/t0T
         iin53wxgMkipI9CKR7e/Hk24ndf5ExSAn3iXWWGcd510DemeyTzRshZnHW3gsKYPQQ
         U21op77T0SvaA==
Date:   Mon, 22 Aug 2022 11:20:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-kernel@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v1 19/19] net/mlx4: Fix error check for dma_map_sg
Message-ID: <20220822112036.2fc55c21@kernel.org>
In-Reply-To: <20220819060801.10443-20-jinpu.wang@ionos.com>
References: <20220819060801.10443-1-jinpu.wang@ionos.com>
        <20220819060801.10443-20-jinpu.wang@ionos.com>
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

On Fri, 19 Aug 2022 08:08:01 +0200 Jack Wang wrote:
> dma_map_sg return 0 on error.

You need to resend it as an individual patch, not part of a series if
you want it to be applied to the networking tree. Please keep Leon's
review tag.
