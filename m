Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4D450D584
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 00:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbiDXWIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 18:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbiDXWII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 18:08:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD78B66;
        Sun, 24 Apr 2022 15:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BpAGnTX3cRjgnnULh2igVvCZe9Ph4m0kRJX8wZHboPs=; b=OjepdWkxMDhQkjCYvK5WcLdOD7
        plwpZj68/QrAIacyZeRmOYPusW3y90m2LobTaSBsKZHuM3NUZQZQza+tYV7A+PhKr49OdDFOTXCph
        0oMxEtWZ+B9HnVXGzKwcnlOdHl166Oy3eyr5tztbOEasY4wqHA8VTuR7X12xFFg3JLgE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nikLg-00HJQn-Sw; Mon, 25 Apr 2022 00:04:56 +0200
Date:   Mon, 25 Apr 2022 00:04:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hermes Zhang <chenhui.zhang@axis.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@axis.com,
        Hermes Zhang <chenhuiz@axis.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] brcmfmac: of: introduce new property to allow disable
 PNO
Message-ID: <YmXJiCamPQSRqiCq@lunn.ch>
References: <20220424022224.3609950-1-chenhui.zhang@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220424022224.3609950-1-chenhui.zhang@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 24, 2022 at 10:22:24AM +0800, Hermes Zhang wrote:
> From: Hermes Zhang <chenhuiz@axis.com>
> 
> Some versions of the Broadcom firmware for this chip seem to hang
> if the PNO feature is enabled when connecting to a dummy or
> non-existent AP.
> Add a new property to allow the disabling of PNO for devices with
> this specific firmware.

If you know the specific version of the firmware which is broken, why
do you need a DT property? Why not just check the firmware version and
disable it automatically?

It does not seem like you are describing hardware here, which is what
DT is for.

	Andrew
