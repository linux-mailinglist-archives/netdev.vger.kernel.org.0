Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AB50CF1C
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 06:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiDXEVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 00:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235553AbiDXEVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 00:21:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2B21C241B;
        Sat, 23 Apr 2022 21:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14F28B800C1;
        Sun, 24 Apr 2022 04:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F95C385AB;
        Sun, 24 Apr 2022 04:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650773912;
        bh=hZeQ8l2GGPUcm2HtV6Tvb87TuH2XsCJO1iGyBKj/7cg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HHZvvWFbiHF2bu3CA1xXesfF+s+/D7MUTITGW8a89I+62eh4AHYo/De/j2kl4U6Q3
         Ovs4PeCTHk7240bdRX0Kj+4WKJFfWr27hlQGEYA95e/i5H546cN/y3AuH/JPI/kCan
         Yuay0G4Hbzo3mNz7RJf8jbRAiY67r5InWB/ZMhMx4F121AYV5ZLNOa99nMP/m2lMYA
         xro6DsI1RxHky2+5anZghYayM7alMo4s9xx3CM0m+3rqHXOqWMw7hpyDkXRO+eCTe/
         ftMzQhgetXaJ5iUp4yIS0Vl8AP2S5mlUUKSCSVkcqyjn7Xs8VKGUy7enoRlB1fizkG
         AhHf16EwsaeKA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hermes Zhang <chenhui.zhang@axis.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        Hermes Zhang <chenhuiz@axis.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] brcmfmac: of: introduce new property to allow disable PNO
References: <20220424022224.3609950-1-chenhui.zhang@axis.com>
Date:   Sun, 24 Apr 2022 07:18:28 +0300
In-Reply-To: <20220424022224.3609950-1-chenhui.zhang@axis.com> (Hermes Zhang's
        message of "Sun, 24 Apr 2022 10:22:24 +0800")
Message-ID: <87wnffp10r.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hermes Zhang <chenhui.zhang@axis.com> writes:

> From: Hermes Zhang <chenhuiz@axis.com>
>
> Some versions of the Broadcom firmware for this chip seem to hang
> if the PNO feature is enabled when connecting to a dummy or
> non-existent AP.
> Add a new property to allow the disabling of PNO for devices with
> this specific firmware.
>
> Signed-off-by: Hermes Zhang <chenhuiz@axis.com>
> ---
>
> Notes:
>     Comments update
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 4 ++++

This is still missing the bindings documentation and ack from the DT
maintainers. You also need to CC the devicetree list:

https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-patches.html

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
