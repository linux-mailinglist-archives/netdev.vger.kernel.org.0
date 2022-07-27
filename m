Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E84C5826FE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiG0MtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiG0MtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:49:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022E722523;
        Wed, 27 Jul 2022 05:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 859416144F;
        Wed, 27 Jul 2022 12:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC2BC433D6;
        Wed, 27 Jul 2022 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658926139;
        bh=rRwq95p5NFEwwy9B6oKFG7spuA1xe3/JjVyHxPXd6T0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=q1h4T+pCh2z2wsPe1ppMTEDkjPgvH5Cy+IMFnBObfh0366XO/f+voZBug/z4BREfE
         /kSeIUIVUS0NOiRhyq1ZkeLYv5C+iBgNF/wzZ8zc44HNgZ6BUYXqEMZoaMgneEOYnE
         FG0t/C+1jpH04xRzfhio3/Q37USFRp8ZUuQ/+KdMzV9LYPCRvHSLS6R+3RwBBnF4w9
         YW1k9FqV4gY/423WL73HpX/uNT1F3Q4ClAL0J447woySM3Rwwij+4zIQkF0d6uisim
         B5+ZKqYa437DI39kl1ImseEhaRwBv4NJyGpICn4c3oAGpBjX3fsbuEQadMTX81qW8f
         tk/oRU/ZV1UkA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: libertas: Fix possible refcount leak in if_usb_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220620092350.39960-1-hbh25y@gmail.com>
References: <20220620092350.39960-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wanghai38@huawei.com, dsd@laptop.org,
        linville@tuxdriver.com, dcbw@redhat.com,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165892613405.11639.5815229141954841153.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 12:48:55 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangyu Hua <hbh25y@gmail.com> wrote:

> usb_get_dev will be called before lbs_get_firmware_async which means that
> usb_put_dev need to be called when lbs_get_firmware_async fails.
> 
> Fixes: ce84bb69f50e ("libertas USB: convert to asynchronous firmware loading")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Patch applied to wireless-next.git, thanks.

2cfb08d6c5c9 wifi: libertas: Fix possible refcount leak in if_usb_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220620092350.39960-1-hbh25y@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

