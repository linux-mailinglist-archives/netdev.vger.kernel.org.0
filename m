Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2C628E7A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiKOAgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiKOAgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:36:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A46E8B
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79F99B810DF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D86C433D6;
        Tue, 15 Nov 2022 00:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668472565;
        bh=gNVn3eU168f6tChIyBQfF/dimYFod/RGCOc8jDhLkRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mfs0GWJA2o2XZuqF6XkwtSo5Sfhekb5PpIUw6bprdwH48DM522S/eTCGZ2Tha/S87
         5f1sz0BKD/DJF5turNyN/39uMQge4uIqoknim0ICTomi3L4oGEEarsylHcXQlRZqCA
         xyD3+rRWEywTxyMP16rRQU/QsjAoUtQzRYPJhohe6kb0AFlEb3oCIlfaalho1xrJ3i
         SgRQvYw33Z6o33h3qbza+6L4S054FaXw6nj4IlJW7HecUCisHJzbXcs3M7wdXLjxP2
         XxF0t0nU9Bz0ofNq3XyF+RsYl65QR6RNkux1jvju81nFd7umhN4kaGnzuCvBgy5cNg
         /uxsUKLkAkhnQ==
Date:   Mon, 14 Nov 2022 16:36:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next v3] nfc: Allow to create multiple virtual nci
 devices
Message-ID: <20221114163604.1b310e51@kernel.org>
In-Reply-To: <20221114102729epcms2p75b469f77cdd41abab4148ffd438e8bd6@epcms2p7>
References: <20221104170422.979558-1-dvyukov@google.com>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p7>
        <20221114102729epcms2p75b469f77cdd41abab4148ffd438e8bd6@epcms2p7>
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

On Mon, 14 Nov 2022 19:27:29 +0900 Bongsu Jeon wrote:
> Reviewed-by: Bongsu Jeon

Dmitry if the patch is good after all - would you mind reposting with
the review tag added (and corrected)? Thanks!
