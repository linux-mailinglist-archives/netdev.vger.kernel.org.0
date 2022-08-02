Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEE258827B
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiHBT0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHBT0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:26:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2C532DA5;
        Tue,  2 Aug 2022 12:26:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BBCFB8207B;
        Tue,  2 Aug 2022 19:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78961C433D6;
        Tue,  2 Aug 2022 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659468393;
        bh=OTP+UqMjQvaX9bsXHjO0NOyXFSmy3H0svrIJTkI7VkU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ao+WfzEBx0p01NcQbtdPXkBwGcg2U77XYdME04rkfzsVRd5YVswGeAe0t93fHXZBM
         +LvKCveCKy4q7O1W2DrBnlzIjwdaKPcNRj7tED1bCIqcgMACH0niskxNqzvkZSe620
         14fJ9syz+pz7sQDYu/0Yd9jsx6u2ieVd3+Fz169fiyULF/HSDafchuLcyh+Enz4HWu
         oxc5MxwI3aWueiguWSfUs9WBhRkuSyk6AHc4mrr8GZ2CpvZr99jreY1/u6cZ2Lt0Fj
         usacTtYUlRek2RfNjTQasCt6qBiT4cM9fL5htY492L5wpqFpYycqZuUuS3dd80tYPR
         c/v3sRzsFzOTQ==
Date:   Tue, 2 Aug 2022 12:26:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.2] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet
Message-ID: <20220802122632.24ddb0f6@kernel.org>
In-Reply-To: <20220802104531.1320-1-Frank.Sae@motor-comm.com>
References: <20220802104531.1320-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Aug 2022 18:45:31 +0800 Frank wrote:
>  Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
>  the driver on StarFive VisionFive development board, which is developed by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
>  wol(magic package).
> 
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>

# Form letter - net-next is closed

The merge window for Linux 6.0 has started and therefore 
net-next is closed for new drivers, features, code refactoring 
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
