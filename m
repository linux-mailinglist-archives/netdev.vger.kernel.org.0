Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8351BE9E4
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgD2V3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:29:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbgD2V3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 17:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ehAF5VJKlo6UElUpdCPqKU/hhwZxb3s8IJbl7lMP8jU=; b=gXPH7oCruVVWWeaOWFGwA4pm/n
        QF4m36glwEcwVh2Bb98/eY9snKBd52heUHGFf8+aXqtVT3WG82JcyjGkWkh77WdwqoUpMgUd0/My9
        e+cpUxQc/kkL5FJhrsZsuafeuFua40IXiztBYAzYe8OvgYyTbPnfFnu7U+qSNEt7Q9C0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTuGr-000KLe-7W; Wed, 29 Apr 2020 23:29:33 +0200
Date:   Wed, 29 Apr 2020 23:29:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC v2 00/11] dwmac-meson8b Ethernet RX delay
 configuration
Message-ID: <20200429212933.GA76972@lunn.ch>
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Khadas VIM2 seems to have the RX delay built into the PCB trace
>   length. When I enable the RX delay on the PHY or MAC I can't get any
>   data through. I expect that we will have the same situation on all
>   GXBB, GXM, AXG, G12A, G12B and SM1 boards

Hi Martin

Can you actually see this on the PCB? The other possibility is that
the bootloader is configuring something, which is not getting
overridden when linux starts up.

	   Andrew
