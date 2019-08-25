Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32089C368
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 15:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfHYNPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 09:15:37 -0400
Received: from mx.0dd.nl ([5.2.79.48]:38082 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbfHYNPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 09:15:37 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 5D2775FA49;
        Sun, 25 Aug 2019 15:15:35 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="l6zXc3Uh";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 14C181D8D757;
        Sun, 25 Aug 2019 15:15:35 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 14C181D8D757
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566738935;
        bh=Q2200DqKa9H2DR//WuPuWgb3ZFkA4JFcKxLzXdWogKo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l6zXc3Uhfmp995W4liIDrB+xS8TcepNujW2QUk752OhMN3s8fQo15EcAGgRxZ1Rir
         xPv2lfGuGTMJcK5VZtdHRirzGAYXtixaost4EY+kykfJNcrs/H1yU4TlimlmcViFT2
         X56fiLdSUMqlhfzMQmJlAPfGOk+0ZdObwFU18ph7hOv2O1P7fye/uRyHsI6cqZVwmi
         +tF0llPm2TmrWgZmpJDxD+xJg/v5v5lLESDRFEpYVyI+qYl7jcmIhGGEBs8AZX9pBW
         48INIYeFNBV8vHm3UaantLC4P90BMtlfhvoVHImi/McazGE5IFDtTflza4p0LpByTI
         aL3IfVl43kbLA==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sun, 25 Aug 2019 13:15:35 +0000
Date:   Sun, 25 Aug 2019 13:15:35 +0000
Message-ID: <20190825131535.Horde.K3HRnOFcIiu-aVdXmqwndlD@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 0/3] net: dsa: mt7530: Convert to PHYLINK
 and add support for port 5
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190824222935.GG13294@shell.armlinux.org.uk>
In-Reply-To: <20190824222935.GG13294@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> On Wed, Aug 21, 2019 at 04:45:44PM +0200, René van Dorst wrote:
>> 1. net: dsa: mt7530: Convert to PHYLINK API
>>    This patch converts mt7530 to PHYLINK API.
>> 2. dt-bindings: net: dsa: mt7530: Add support for port 5
>> 3. net: dsa: mt7530: Add support for port 5
>>    These 2 patches adding support for port 5 of the switch.
>>
>> v1->v2:
>>  * Mostly phylink improvements after review.
>> rfc -> v1:
>>  * Mostly phylink improvements after review.
>>  * Drop phy isolation patches. Adds no value for now.
>> René van Dorst (3):
>>   net: dsa: mt7530: Convert to PHYLINK API
>>   dt-bindings: net: dsa: mt7530: Add support for port 5
>>   net: dsa: mt7530: Add support for port 5
>>
>>  .../devicetree/bindings/net/dsa/mt7530.txt    | 218 ++++++++++
>>  drivers/net/dsa/mt7530.c                      | 371 +++++++++++++++---
>>  drivers/net/dsa/mt7530.h                      |  61 ++-
>>  3 files changed, 577 insertions(+), 73 deletions(-)
>
> Having looked through this set of patches, I don't see anything
> from the phylink point of view that concerns me.  So, for the
> series from the phylink perspective:
>
> Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks and thanks for reviewing.

Greats,

René

>
> Thanks.
>
> I did notice a dev_info() in patch 3 that you may like to consider
> whether they should be printed at info level or debug level.  You
> may keep my ack on the patch when fixing that.
>
> I haven't considered whether the patch passes davem's style
> requirements for networking code; what I spotted did look like
> the declarations were upside-down christmas tree.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



