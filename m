Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319B33ABDD
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfFIUpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:45:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39592 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfFIUpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 16:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ja8yjXW/Nihycq7JSqkIhvcVwYqGe/pmO57BMxjFYPk=; b=EYbbZBLSizui0oPFI5qV/M5viF
        GOKssAIC+f0FZh61uB6bXNkCpDBl4FX1XHr2INo24UPEpmeEQPHsWyieVq/VXLli27kYIRbo4nNKZ
        SVBwWyk8eT8+a46B46DO6XYLjpmfdCU4iL7uJ3feMXleePBM7e+n3vgaESbkBGt5XEJ0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ha4gg-0002Un-Lv; Sun, 09 Jun 2019 22:45:10 +0200
Date:   Sun, 9 Jun 2019 22:45:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        devicetree@vger.kernel.org, narmstrong@baylibre.com,
        khilman@baylibre.com, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC next v1 0/5] stmmac: honor the GPIO flags for the PHY reset
 GPIO
Message-ID: <20190609204510.GB8247@lunn.ch>
References: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609180621.7607-1-martin.blumenstingl@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Patch #1 and #4 are minor cleanups which follow the boyscout rule:
> "Always leave the campground cleaner than you found it."

> I
> am also looking for suggestions how to handle these cross-tree changes
> (patch #2 belongs to the linux-gpio tree, patches #1, 3 and #4 should
> go through the net-next tree. I will re-send patch #5 separately as
> this should go through Kevin's linux-amlogic tree).

Hi Martin

Patches 1 and 4 don't seem to have and dependencies. So i would
suggest splitting them out and submitting them to netdev for merging
independent of the rest.

Linus can probably create a stable branch with the GPIO changes, which
David can pull into net-next, and then apply the stmmac changes on
top.

	Andrew
