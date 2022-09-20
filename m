Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8245BEE57
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiITURA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiITUQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:16:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761FA58DF7
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:16:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 061E062D41
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 20:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E52C433C1;
        Tue, 20 Sep 2022 20:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663705017;
        bh=FxwLiDv0FgHhJWmiTjQrwmjXVxiwed2wunW4KFAKaS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AxjInYNLs0HiznVXaTTXO5Gj4vgmc79sYNoOfU0dNM5UUpw9Ya6OWDyfFwZ8Y23RL
         FMvslKXADoqt6SutAqDFDMQZep9L53S2BuFdX9bFTk2qA+1djY0uabUpStTl6OCKT0
         aVLSlROztUVcf+7QlNsfY5OvU3pnosniwCTt5X7uzi/t45S9ERbPTM2davwBzvpI8p
         t19Q3B21SFZMeh1uNqJanNPNPda/UlbgRCDd4vi0L0gjFdBG9p5OXTiCVX6qDQcmeS
         EAT3H/i7geVGL9gck1q61a6lftVyoI7HuzAbfVZnX1azC67TRfEhOzovl4esu6b7k0
         32rR4aLsMcHGQ==
Date:   Tue, 20 Sep 2022 13:16:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <ecree.xilinx@gmail.com>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [RFCv8 PATCH net-next 00/55] net: extend the type of
 netdev_features_t to bitmap
Message-ID: <20220920131656.72ed8272@kernel.org>
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
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

On Sun, 18 Sep 2022 09:42:41 +0000 Jian Shen wrote:
> For the prototype of netdev_features_t is u64, and the number
> of netdevice feature bits is 64 now. So there is no space to
> introduce new feature bit.

For v9 could you filter out all the driver changes?

Focus on adding the helpers and converting core (excluding tunnel
drivers etc.) in a way that will not break the build. That way we 
can iterate on the revisions more quickly, hopefully, and convert
the drivers once we have the helpers ironed out?
