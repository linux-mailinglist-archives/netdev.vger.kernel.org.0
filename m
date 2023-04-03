Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574566D4508
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjDCM6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbjDCM6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:58:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA9B12BFA
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZswOuRu8HEi2I8shYB1tTDRdFqp+cwdWE7EOP5W813k=; b=Rw4AWj+/1BFkE8QFTFf/U12vEa
        8cV3H1A2zeadSuPFGCbcSH+8XtIk23vP26WWQzca1j1k1pXSt429eflfZssHFt3mZaI4igFThBYEq
        ldV1C0zSuBPpJM+XhFrQz9T7XoqCSj85nthd2uatPV3okBL4QRy569Jzs1xJ57FwrYA8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pjJlY-009HYD-4R; Mon, 03 Apr 2023 14:58:32 +0200
Date:   Mon, 3 Apr 2023 14:58:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 3/6] net: txgbe: Add SFP module identify
Message-ID: <d6afd3b3-c31c-46c6-96f2-a34d1e92c107@lunn.ch>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
 <20230403064528.343866-4-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403064528.343866-4-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Identifying Adapter
> +===================
> +The driver is compatible with WangXun Sapphire Dual ports Ethernet Adapters.
> +
> +SFP+ Devices with Pluggable Optics
> +----------------------------------
> +The following is a list of 3rd party SFP+ modules that have been tested and verified.
> +
> ++----------+----------------------+----------------------+
> +| Supplier | Type                 | Part Numbers         |
> ++==========+======================+======================+
> +| ACCELINK | SFP+                 | RTXM228-551          |
> ++----------+----------------------+----------------------+
> +| Avago	   | SFP+                 | SFBR-7701SDZ         |
> ++----------+----------------------+----------------------+

Tab issue.

> +| BOYANG   | SFP+                 | OMXD30000            |
> ++----------+----------------------+----------------------+
> +| F-tone   | SFP+                 | FTCS-851X-02D        |
> ++----------+----------------------+----------------------+
> +| FS       | SFP+                 | SFP-10GSR-85         |
> ++----------+----------------------+----------------------+
> +| Finisar  | SFP+                 | FTLX8574D3BCL        |
> ++----------+----------------------+----------------------+
> +| Hisense  | SFP+                 | LTF8502-BC+          |
> ++----------+----------------------+----------------------+
> +| HGTECH   | SFP+                 | MTRS-01X11-G         |
> ++----------+----------------------+----------------------+
> +| HP       | SFP+                 | SR SFP+ 456096-001   |
> ++----------+----------------------+----------------------+
> +| Huawei   | SFP+                 | AFBR-709SMZ          |
> ++----------+----------------------+----------------------+
> +| Intel    | SFP+                 | FTLX8571D3BCV-IT     |
> ++----------+----------------------+----------------------+
> +| JDSU     | SFP+                 | PLRXPL-SC-S43        |
> ++----------+----------------------+----------------------+
> +| SONT     | SFP+                 | XP-8G10-01           |
> ++----------+----------------------+----------------------+
> +| Trixon   | SFP+                 | TPS-TGM3-85DCR       |
> ++----------+----------------------+----------------------+

This does not make much sense, now that the generic SFP driver is
being used. If you want to have a such a list, move it into the
generic SFP documentation.

I assume you have retested all these using the generic code?

Russell will be interested in the contents of the EEPROM for these. 

> +Laser turns off for SFP+ when ifconfig ethX down
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +"ifconfig ethX down" turns off the laser for SFP+ fiber adapters.
> +"ifconfig ethX up" turns on the laser.

This also not specific to your device, the generic SFP code will do
that.

> +static int txgbe_sfp_register(struct txgbe *txgbe)
> +{
> +	struct pci_dev *pdev = txgbe->wx->pdev;
> +	struct platform_device_info info;
> +	struct platform_device *sfp_dev;
> +
> +	memset(&info, 0, sizeof(info));

I _think_ the memset can be replace by

struct platform_device_info info = {};

       Andrew
