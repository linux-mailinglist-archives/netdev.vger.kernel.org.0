Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E7C67A8AE
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjAYCVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:21:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:21:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF5149960
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 18:21:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F491B81733
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0128FC433D2;
        Wed, 25 Jan 2023 02:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674613259;
        bh=yTNctOc5uA5aBIDPsSPeiAqnfxAS0EYekEzvZeCLoeM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3Eo4zAvMphnszbU9zBE/hGr3odpovG64ARo429Lr2FcNqxV1l8A4x29QhUGM//pw
         McYwXWvsH5oqsTS4a36bBwm5h3WNh21xHcAJeARx1BcNMy0NiKWNIECZA9QgToRTfu
         P5bTsSW0on+2bs3LU56bJ0wD0HTYZfrl8xdEf4aDDqQJCSEseRgWz91z49AD36PV3y
         WPl4lk9xbpylh41/R+nEbtMWVEjgBzd2SXwUd4oKufPoH1tZOUvhDZANpUAbrAQXP9
         lvxtK9eP4a+F+yIRAEL7MLjo+zfWYYiKFmZjPX0XZKei1+jPMAbIL/0BtV+YQQIVAU
         RzZWEPgxkGzHg==
Date:   Tue, 24 Jan 2023 18:20:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geoff Levand <geoff@infradead.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] ps3_gelic_net: DMA related fixes
Message-ID: <20230124182058.4f41a298@kernel.org>
In-Reply-To: <cover.1674436603.git.geoff@infradead.org>
References: <cover.1674436603.git.geoff@infradead.org>
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

On Mon, 23 Jan 2023 01:24:25 +0000 Geoff Levand wrote:
> The following changes since commit 71ab9c3e2253619136c31c89dbb2c69305cc89b1:
> 
>   net: fix UaF in netns ops registration error path (2023-01-20 18:51:18 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-linux.git for-merge-net-v2
> 
> for you to fetch changes up to dca415c1429e4ca57d525b3595513a323cca303e:
> 
>   net/ps3_gelic_net: Use dma_mapping_error (2023-01-22 17:08:58 -0800)

Any particular reason you sent a PR?
We generally apply patches from the list, it's simpler.
