Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C585D1EDA2E
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbgFDAyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 20:54:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729824AbgFDAyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 20:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0q10zSuoQaxTAqA3I65SXA9p5wlCD7lf2HM0PSVMptw=; b=o1f1zw6cGu0FU2Pey8evJKQbs1
        GLs4GN8xw0No3yQ6WO8ZIgAVuTlwy9vuUkGMyR6TnDKoeL1+V2L9jspT6sqfIJE9UpeG0ZiQ0QGUN
        V/dFV9khDwQhtRKnQTMF3BWKrG6x0iOoIomOkFO+BeLYt6VaI/wmHyqHQgIl4hBJNemE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jge91-0046Ja-30; Thu, 04 Jun 2020 02:54:07 +0200
Date:   Thu, 4 Jun 2020 02:54:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, DENG Qingfang <dqfext@gmail.com>
Subject: Re: [net-next PATCH 1/5] net: dsa: tag_rtl4_a: Implement Realtek 4
 byte A tag
Message-ID: <20200604005407.GA977471@lunn.ch>
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
 <20200603135244.GA869823@lunn.ch>
 <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbu4O_6SvgTU3A5mYVrAn-VWpr9=0LD+M+LduuqVnjsnA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Where is spanning tree performed? In the switch, or by the
> > host?
> 
> In the switch I think.
> There is a register in the ASIC to set the spanning tree status
> to disabled, blocking, learning or forwarding.

Hi Linus

Spanning tree needs two parts. You need to be able to change the ports
between disabled, blocking, learning, forwarding. And you need to be
able to send/receive frames.

If spanning tree is performed in the ASIC, i don't see why there would
be registers to control the port status. It would do it all itself,
and not export these controls.

So i would not give up on spanning tree as a way to reverse engineer
this.

    Andrew
