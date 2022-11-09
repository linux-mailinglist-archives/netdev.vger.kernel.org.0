Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7E6232A9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiKISkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiKISky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:40:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFA9F036;
        Wed,  9 Nov 2022 10:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D699FB81F8F;
        Wed,  9 Nov 2022 18:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CBEC433C1;
        Wed,  9 Nov 2022 18:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019251;
        bh=GH5n2oypGf+iQT5/QXs2kiTP6Li7hit/03JaWon7A58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qyp8AmaVbgOsFY4Iqf+NKK/ZyV7lzF9TrfHTCqJz8Qm2LaJz5mpKTwR4AGr1py7xA
         dzRrH3aPCjvVxEU5xjUEI5Zg9WIA3fH+cIYTDEyLS/x1GwygvKA6S/XyYSkNNV3PQk
         w0Xv4rTmpClCeUjFm46o6lrqVluHAOBSm2TjRDYzR7bPdQB0XcmraOtnjNea+tX3H5
         CRoOmfk0LqfdPYSH6W6OzusxxG9shKLT4gvvbsX/AQ87eKOaAoZzp3fM1N33eAg2oR
         2BTeCwPmgaET7ZJRk+hZ5qmcJXCcnmKdNBT70LPkJeUeqKFIMh4Og9AiIS/rvNV6b8
         57M2cB2vwPQ+w==
Date:   Wed, 9 Nov 2022 10:40:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next RFC 0/5] Update r8152 to version two
Message-ID: <20221109104050.49dc17c8@kernel.org>
In-Reply-To: <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
        <20221108125028.35a765be@kernel.org>
        <9cdddf82-fb1a-45dd-57e9-b0f1c2728246@gmail.com>
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

On Wed, 9 Nov 2022 15:43:21 +1100 Albert Zhou wrote:
> The version-one r8152 module, for some reason, cannot maintain high
> data-transfer speeds. I personally experienced this problem myself, when
> I bought a new USB-C to ethernet adapter. The version-two module fixes
> this issue.

I see, perhaps it'd be possible to zero in on how the datapath of 
the driver is implemented? 
