Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5560C8EBCE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfHOMpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:45:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfHOMpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 08:45:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YYoqAA0uIaNmoYfsiwLP7TTtO68hYhG/0e1ZHTk7VVA=; b=eTmBLlxHB5ZP18pluk44nS+dTo
        3YG9kRLC3/k0lxCDEFGkmqfREwINBvmV6BK7gnJCM7Lc6Dc6YQyaLINzMqrYMic5GH07SwteOQnuM
        elqNhV0KZHdoJnBLFZWCSZScHgy9Wpwq2TRK17BpxQYPG2M5uwq0CkvQidYMN+p3JoG4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hyF86-0008Lz-1c; Thu, 15 Aug 2019 14:45:22 +0200
Date:   Thu, 15 Aug 2019 14:45:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Message-ID: <20190815124522.GC31172@lunn.ch>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-5-yangbo.lu@nxp.com>
 <20190813062525.5bgdzjc6kw5hqdxk@lx-anielsen.microsemi.net>
 <VI1PR0401MB2237E0F32D6CC719682E8C1AF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190814091645.dwo7c36xan2ttln2@lx-anielsen.microsemi.net>
 <VI1PR0401MB2237B2ABB288FE12072C64D1F8AC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR0401MB2237B2ABB288FE12072C64D1F8AC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [Y.b. Lu] Actually I couldn’t find reasons why make some ports PTP
> unaware, if there is software stack for PTP aware...

Maybe because i have not yet done

apt-get install linuxptp
$EDITOR /etc/defaults/ptp4l
systemctl restart ptp4l

Just because it exists does not mean it is installed.

     Andrew
