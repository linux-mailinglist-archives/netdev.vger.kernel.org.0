Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD644F447C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377824AbiDEUEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346010AbiDEPLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:11:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F03E10610F
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 06:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GMTFemwBkT81roEqY5EW/cRE6P00Wf5M8QX9OYOwMoA=; b=Ufk4Wd3cNhTFeXGKmWtuB30YTS
        su3xAJN+XbLcT73Xd3oZ7ULznBLmvaNP/MSxOJf0fCYT84I1UVl5s1EuEzFdenDJKR7o6Re0KUYm/
        Khq7pw0+bJak6NUI0GCU82e7UQPDMPi/6C6SqXJTJRCOORGBqPWPtVQ3Xg8C/xWpmhp0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbjBJ-00EFhM-AR; Tue, 05 Apr 2022 15:25:13 +0200
Date:   Tue, 5 Apr 2022 15:25:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <YkxDOWfULPFo7xFi@lunn.ch>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 01:05:12PM +0000, Conor.Dooley@microchip.com wrote:
> [ 2.818894] macb 20112000.ethernet eth0: PHY [20112000.ethernet-ffffffff:09] driver [Generic PHY] (irq=POLL)

Hi Conor

In general, it is better to use the specific PHY driver for the PHY
then rely on the generic PHY driver. I think the Icicle Kit has a
VSC8662? So i would suggest you enable the Vitesse PHYs.

  Andrew
