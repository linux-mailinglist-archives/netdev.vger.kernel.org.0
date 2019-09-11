Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C0CB05D6
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 01:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbfIKXB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 19:01:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41388 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbfIKXB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 19:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DUSy2s9ri6Cxb5VfSJ4esteKWWeGBuBm8EkDUzQysXw=; b=0UZSBkm0hFxw2WL5HExyURJXBJ
        1ZToAV2yCkk6T+w6oCDznRAyI6twutL8gk82nrLXbkoDRYzPZVmqQPwbTGaFv1jqe1Kk9nifiHZfk
        ltH+n5nTipWXY37RGWqjMoYXUDGtYhfBaa3siQiHXPbxofL7FSk/rgmpJ6fYmikbI38M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i8Bca-0001iZ-CP; Thu, 12 Sep 2019 01:01:56 +0200
Date:   Thu, 12 Sep 2019 01:01:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Message-ID: <20190911230156.GC5710@lunn.ch>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <20190910131951.GM32337@t480s.localdomain>
 <3f265c5afcb2eea48410ec607d65e8f4e6a20373.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f265c5afcb2eea48410ec607d65e8f4e6a20373.camel@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Feature series targeting netdev must be prefixed "PATCH net-next". As
> 
> Thanks for the info. Out of curiosity, where should I have gleaned this
> info from? This is my first contribution to netdev, so I wasnt familiar
> with the etiquette.

It is also a good idea to 'lurk' in a mailing list for a while,
reading emails flying around, getting to know how things work. This
subject of "PATCH net-next" comes up maybe once a week. The idea off
offloads gets discussed once every couple of weeks etc.

	 Andrew
