Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F034F60842D
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJVEKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiJVEKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:10:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524C153D16;
        Fri, 21 Oct 2022 21:10:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFC8E60EAA;
        Sat, 22 Oct 2022 04:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82600C43470;
        Sat, 22 Oct 2022 04:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666411808;
        bh=Pt3RmxMP1J8VX/N8ZW4rQfZLUHkvjBeGZ6atiNrbHPo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iIvT2PSR02rHyFk8ucy0JIUTq69sgCa6kJYR3l+B+7EqHdPszqRMh9nMpTeAol2Cy
         uec4WC+3J4adlOeQat9J38VT51jPC/2jrfLlz0+OACFqZQbzMPq/sKHpqVR8WkPaoc
         6dra2tHCZqN10w/nWx13jc4zKGaixZKfPYE3jsQ0nvtLaMdqkB4jB5S2tTz9/71RJf
         YccK8PeUK5pA0Z+QWpt7qCeWj81hjEFdRkY1c4EtbCgH9mYBpFAh2oseRlwqFgpNKy
         nZIB6LWiYYz0dYKv9VsOtkNxcm7RR9h8z2Tpyg+kzmAmPenGtDFxtu1MHjBHtmZcFJ
         fug9RVZedAJlA==
Date:   Fri, 21 Oct 2022 21:10:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi@redhat.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh@kernel.org, daniel@makrotopia.org
Subject: Re: [PATCH net-next 0/6] introduce WED RX support to MT7986 SoC
Message-ID: <20221021211006.3c9b7f29@kernel.org>
In-Reply-To: <cover.1666368566.git.lorenzo@kernel.org>
References: <cover.1666368566.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 18:18:30 +0200 Lorenzo Bianconi wrote:
> Similar to TX counterpart available on MT7622 and MT7986, introduce
> RX Wireless Ethernet Dispatch available on MT7986 SoC in order to
> offload traffic received by wlan nic to the wired interfaces (lan/wan).

Run sparse over these, please. There's warnings in them thar patches.
