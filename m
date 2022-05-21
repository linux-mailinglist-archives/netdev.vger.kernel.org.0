Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4718C52F755
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 03:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348476AbiEUBZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 21:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbiEUBZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 21:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AB823152;
        Fri, 20 May 2022 18:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3F1D61EA2;
        Sat, 21 May 2022 01:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D933DC385A9;
        Sat, 21 May 2022 01:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653096346;
        bh=yMocOcmC33NsOkfqFgLCpjgPvld2Y6qIGt0yG2xZxT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ld2JXAiNS2E9dtYRfU0l1Jf9/Ef0Kp18tzj0enX1dCPEJhIbYGbAedQ758PqZsmP7
         WuCtRsaoo6c3iAMf+27A7DmVq86QfZ3WPFS8dzssv4e6OIryYZOsSxJBBb+M3f/4Eo
         SZJPmFsVdPTSksz/sSNVb641Kq6tCy0Hkz87rgdp3iE+rBWiSoBmiJ2LSXWFIv7Mor
         YrBHLQZIw99Xx/jcl17pcqLFMb4zyr9S3734AZwvKHrzM5nRvYD+Cn5CFEUSBLGrgd
         DJPAMaPVNYuBHmjZoAAynhaY+03mr+SomSslpxKRSR0fUF47y7LynTpcHac7Vn+QHs
         K4wZ3KhQfBpsQ==
Date:   Fri, 20 May 2022 18:25:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v3 net-next 00/16] introduce mt7986 ethernet support
Message-ID: <20220520182544.1af8f5bf@kernel.org>
In-Reply-To: <cover.1653069056.git.lorenzo@kernel.org>
References: <cover.1653069056.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 20:11:23 +0200 Lorenzo Bianconi wrote:
> Add support for mt7986-eth driver available on mt7986 soc.
>=20
> Changes since v2:
> - rely on GFP_KERNEL whenever possible
> - define mtk_reg_map struct to introduce soc register map and avoid macros
> - improve comments
>=20
> Changes since v1:
> - drop SRAM option
> - convert ring->dma to void
> - convert scratch_ring to void
> - enable port4
> - fix irq dts bindings
> - drop gmac1 support from mt7986a-rfb dts for the moment

=F0=9F=91=8D

Acked-by: Jakub Kicinski <kuba@kernel.org>
