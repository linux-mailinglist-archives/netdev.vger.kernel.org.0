Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C5AAD7A5
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 13:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403897AbfIILHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 07:07:16 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:59134 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730331AbfIILHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 07:07:15 -0400
Received: from mxback13o.mail.yandex.net (mxback13o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::64])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id 976B64D4103F;
        Mon,  9 Sep 2019 14:07:13 +0300 (MSK)
Received: from smtp4j.mail.yandex.net (smtp4j.mail.yandex.net [2a02:6b8:0:1619::15:6])
        by mxback13o.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 7bbqNSvQrj-7DLWNqV8;
        Mon, 09 Sep 2019 14:07:13 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cloudbear.ru; s=mail; t=1568027233;
        bh=Bhh2RjEZ7vaelF+cLm6ZtAFJrGNJSujL1i77s1bA/vY=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=V2MIDIoggpP6R0zQOmlk2uenbDwFAc5k4/jQySWtNfueWIL6W85/PoAPSnoK+JRb8
         UBQMMSjsAut8CeY6frhhvcC3U++ewdGUZIm4LniZ1eSmDV0Yx7wDmF5qebcCX3hui7
         0Jab65ogsRb3642Im56Hf+juZ5yBINIdpsEp0Lxg=
Authentication-Results: mxback13o.mail.yandex.net; dkim=pass header.i=@cloudbear.ru
Received: by smtp4j.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id 3sAB8oDl98-7CXuP6gq;
        Mon, 09 Sep 2019 14:07:12 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: Re: [PATCH 1/2] net: phy: dp83867: Add documentation for SGMII mode
 type
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>
References: <20190907153919.GC21922@lunn.ch>
 <1567700761-14195-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <2894361567896439@iva5-be053096037b.qloud-c.yandex.net>
 <20190908085417.GA28580@lunn.ch>
From:   Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
Message-ID: <e7b52007-c35e-c00f-81f1-b836e68b77bd@cloudbear.ru>
Date:   Mon, 9 Sep 2019 14:07:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190908085417.GA28580@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've done required changes. Sorry for HTML in previous mail I sent it 
from mobile app which has not disabling HTML.

Vitaly.
