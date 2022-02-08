Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905804AD9B1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241866AbiBHNWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377079AbiBHNWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:22:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A63C03FEF9
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 05:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QxQtGd2udDb/2FYD951mfJS+oRdhZ7+i7Hft8ehCFss=; b=ztUU1gUF2ScnOW5gfAL6TGhMHg
        XUKj/0FwQPCrDPRfa3kbw4Uc0xW3bcQ1ZD/Sn5Y+mDXArjpq2ZMD9J1HwpG/0ONuRDu0huhHETgdv
        4WYt+ssfbMIc7k71ZmG1dI678jG0GBITg7UbgLGpum0Wq/ziwCTZwmrZP99UcewMkP80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHQNR-004rVW-2I; Tue, 08 Feb 2022 14:17:49 +0100
Date:   Tue, 8 Feb 2022 14:17:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Message-ID: <YgJtfdopgTBxmhpr@lunn.ch>
References: <20220208051552.13368-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208051552.13368-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 02:15:52AM -0300, Luiz Angelo Daros de Luca wrote:
> RTL8367RB-VB was not mentioned in the compatible table, nor in the
> Kconfig help text.
> 
> The driver still detects the variant by itself and ignores which
> compatible string was used to select it. So, any compatible string will
> work for any compatible model.

Please also update the binding documentation:
Documentation/devicetree/bindings/net/dsa/realtek-smi.txt

Thanks
	Andrew
