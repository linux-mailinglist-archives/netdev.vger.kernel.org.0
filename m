Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA81F621E08
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiKHUud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKHUuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E178F17A87;
        Tue,  8 Nov 2022 12:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F5E0B81B37;
        Tue,  8 Nov 2022 20:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129FEC433C1;
        Tue,  8 Nov 2022 20:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667940629;
        bh=NiWLCrqi8SEYd4gMYpSXF/lQeJWzCw371dvWXcPCWhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tjLFIxhKQ1AZ6Li8p8u7p41HcFCFIOpqY70BFqUlYo9ryNGuo0C27PciJpETvO/xk
         8L/szZvxqDcTqqWfqFLLsBMItrZi75YA72cZ4cfENt+QmOEYeG9TDuejFsQMGC+rwc
         mfep0sxt1paQr9DiEamaL3vjAFOaxjQsWuxqt4165CNFUetfYLOsWHNwmEP/OQz1WR
         eJEE8tYv3nxK5tm0znLvdnLNXhIQA5NWHrq0pPTHYJCOgtkXrYvVyMPRDT8xNMDWFG
         eXbngyexZ5owpdNrr1RAgKQeQDjKwnrEs6R5VRe/LXewFTmMlFaJ6cDz4U3wRmX0A4
         JZPI16qeykexw==
Date:   Tue, 8 Nov 2022 12:50:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Message-ID: <20221108125028.35a765be@kernel.org>
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
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

On Wed,  9 Nov 2022 02:33:37 +1100 Albert Zhou wrote:
> This patch integrates the version-two r8152 drivers from Realtek into
> the kernel. I am new to kernel development, so apologies if I make
> newbie mistakes.
> 
> I have tested the updated module in v6.1 on my machine, without any
> issues.

What are you trying to achieve? Copy pasting 18k LoC into the kernel 
in a single patch is definitely not the way we do development. If there
are features missing in the upstream driver, or you see discrepancies
in the operation - please prepare targeted patches.
