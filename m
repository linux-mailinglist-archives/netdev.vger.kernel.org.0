Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB906F2E9A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 13:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388674AbfKGMzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 07:55:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388369AbfKGMzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 07:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6crDeBV71tB57uG0XSgtv/iBquw2Z6TwVlRm1/HaHSY=; b=i7quXKN40BxHA/oeJKUeiIKost
        pMt1n+9n1KV6VJri4A6Xw4jo4oKf4IM0gRKDzQgfLNnkkGZVdO90GSPC5GILLzjf46SoiwABy1MYV
        1syUbYuMVkpqClQ+xm/6bprK9vvy3fPMUlTtcJO0OkD5epuIsgqkrPK5UcW6t9TPSEF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iShKF-00063A-4s; Thu, 07 Nov 2019 13:55:47 +0100
Date:   Thu, 7 Nov 2019 13:55:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 4/6] net: phy: at803x: mention AR8033 as same as AR8031
Message-ID: <20191107125547.GB22978@lunn.ch>
References: <20191106223617.1655-1-michael@walle.cc>
 <20191106223617.1655-5-michael@walle.cc>
 <20191107020436.GD8978@lunn.ch>
 <1DE4295A-1D25-4FAD-8DAB-45BD97E511C9@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DE4295A-1D25-4FAD-8DAB-45BD97E511C9@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael

> I tried that actually.. There is a PTP enable bit. It's default is 1
> (according to the AR8031 datasheet). Now guess what it's value is on
> the AR8033.. its also 1. Not enough.. I also tried to enable the
> realtime counter. well that worked too.

> And yes. I've double checked the package marking. It definitely was
> an AR8033. So either I was just lucky, or maybe.. the AR8033 is just
> a relabled AR8031 ;)

O.K, thanks for trying. We really only need to solve this mystery if
anybody actually tries to make use of PTP.

	Andrew
