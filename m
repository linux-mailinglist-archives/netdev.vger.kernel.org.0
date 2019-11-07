Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306EBF3162
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389169AbfKGO2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:28:22 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:54561 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfKGO2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 09:28:21 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B295223E3F;
        Thu,  7 Nov 2019 15:28:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573136900;
        bh=23Xq+LOAvfScLvlQZfupvgtVKHAM1yIBxWL8E5aw5iw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oqo9ezXig/6bIxb/gHxs5396ziZeEqKTPv7wi2dBmm9sfXfeqwDSinSYlArfvBoO4
         T+M0QLqKNCKFfY3vCkzSsws7jkSp2jxmB08eFiAR22MV4ePFPEonQJooYEJ8MBEQxz
         KECUMS7+EAln/nESS67fXlqsZt7DfS5Obf5k2skc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Nov 2019 15:28:19 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 4/6] net: phy: at803x: mention AR8033 as same as AR8031
In-Reply-To: <20191107125547.GB22978@lunn.ch>
References: <20191106223617.1655-1-michael@walle.cc>
 <20191106223617.1655-5-michael@walle.cc> <20191107020436.GD8978@lunn.ch>
 <1DE4295A-1D25-4FAD-8DAB-45BD97E511C9@walle.cc>
 <20191107125547.GB22978@lunn.ch>
Message-ID: <89dcabd5a1b38e8106d70173922c391b@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,


Am 2019-11-07 13:55, schrieb Andrew Lunn:
>> I tried that actually.. There is a PTP enable bit. It's default is 1
>> (according to the AR8031 datasheet). Now guess what it's value is on
>> the AR8033.. its also 1. Not enough.. I also tried to enable the
>> realtime counter. well that worked too.
> 
>> And yes. I've double checked the package marking. It definitely was
>> an AR8033. So either I was just lucky, or maybe.. the AR8033 is just
>> a relabled AR8031 ;)
> 
> O.K, thanks for trying. We really only need to solve this mystery if
> anybody actually tries to make use of PTP.

That might be the next thing on my list; but depends if there is an 
usable interrupt for the PHY on my board..

-michael
