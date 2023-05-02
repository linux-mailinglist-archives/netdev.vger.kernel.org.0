Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27136F3EB8
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjEBIDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjEBIDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:03:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA43D44B0;
        Tue,  2 May 2023 01:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PvpjRPhnK8nvzZQ6lrmMZD/nxdd63g2YCF5iNnbiTyE=; b=bNXlKQOh0aIxzB4XxO0oFE2dBP
        CPI3KhKaWpJRpBZ4Gm0xkCRtd2W3Rb3BQ/L7gn4a5SrYoeHakn6Nk0rQKkAl6Fyg0+6pc9WxxRoiP
        Iad+vz5yPsCNK6j3nmotArDTxE838d3aG/vS1ymXH/heNnDTz/VAqg6znD+/RSa8K3jfkev0XQTJL
        qgzR99+1FVINxPX45cVds7ZzYH+sjT0ipcvuZK48SQAVU617/qdck5+3iJIlkq1zzDoI7Luy6pTy9
        ALE0rI/qDgJTTrrkZXHprXNNwJwHPwqpp/anEPPI6WszZh36+DdEbJoh8O8Y3L8HSNCBSSJGq8NiR
        8QfsfNhw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34144)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ptkyj-0001vW-Q6; Tue, 02 May 2023 09:03:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ptkyi-0000WR-0o; Tue, 02 May 2023 09:03:16 +0100
Date:   Tue, 2 May 2023 09:03:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
        andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
        jsd@semihalf.com, ose.Abreu@synopsys.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [RFC PATCH net-next v5 7/9] net: pcs: Add 10GBASE-R mode for
 Synopsys Designware XPCS
Message-ID: <ZFDDw1tFkEuTldQs@shell.armlinux.org.uk>
References: <20230426071434.452717-1-jiawenwu@trustnetic.com>
 <20230426071434.452717-8-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426071434.452717-8-jiawenwu@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 03:14:32PM +0800, Jiawen Wu wrote:
> Add basic support for XPCS using 10GBASE-R interface. This mode will
> be extended to use interrupt, so set pcs.poll false. And avoid soft
> reset so that the device using this mode is in the default configuration.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

See my comments on v4.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
