Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6286DB11E
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjDGRGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDGRGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:06:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E499EE5
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 10:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Fs9TQ7UXee2G304+Uh9JoedlMovd9lYkbYLeCwLQ3MY=; b=hLdeLG7FKzV2zy8aFC0XhtjIsh
        yZZrlwFQ6gDLpICe+KlHJlH8xq+g0CCG2HUAe/APB+PcOdZjsdPBvcFBiuDmpcCIFc1e0tPmnjEdY
        ZeGp8Ho7drjh6tSejq8MxtKciXHx6/xqqJ0fAJGHUCi4gCTxLiGHdMyh2kf5EDNuWqKU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pkpXj-009kIK-Fk; Fri, 07 Apr 2023 19:06:31 +0200
Date:   Fri, 7 Apr 2023 19:06:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <8ed09b68-91f2-4090-bee9-a70ec602e9da@lunn.ch>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230407165034.qvmx7algembpsona@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165034.qvmx7algembpsona@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If it's ignored, even better, one more reason to make it rev-mii and
> not mii, no compatibility concerns with the driver not understanding the
> difference...

O.K. i will respin the patch tomorrow.

     Andrew
