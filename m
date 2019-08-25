Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36FA9C347
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 14:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfHYMsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 08:48:15 -0400
Received: from mx.0dd.nl ([5.2.79.48]:38008 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbfHYMsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Aug 2019 08:48:15 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1F14F5FA49;
        Sun, 25 Aug 2019 14:48:14 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="OHv9jHhP";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id C4F541D8D553;
        Sun, 25 Aug 2019 14:48:13 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com C4F541D8D553
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566737293;
        bh=cFgSbsEwKunNxae3/0ASSKcD5GEjChBMA8MDxulxKDs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OHv9jHhPHxlSwSHVhAgNHnwaLAItJR6/N/N2AwZ3/jAQcMzuf5X3PzK44cqowvzj0
         KY0b6ADhII7iY+dWhtdo4u8lTl2/ZNu0+zXmdlthrLgHa5h/MnUhOaElJoqH+Kisf+
         PqvB6kJ0d8kF6t1eii4J0upW9gNjxhz+YPopixgH6YCMonZtfL0LKQGfa0RwlS2Ix+
         p3lerDHTG7iXDfsIenW5g3L4Si5RdLXIQp3u4uMnvCbQ3erkBMEavUmjCWTZPGhy+8
         Tr9J1UhNM1duzq0LtxLgVhMD2kEWZ6FjvYY9kh9nxmmnAv+/bBRlY4mDNQPno4VDRb
         ccM++vdGi4ETQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sun, 25 Aug 2019 12:48:13 +0000
Date:   Sun, 25 Aug 2019 12:48:13 +0000
Message-ID: <20190825124813.Horde.ipTYml4Y_iJUAXHsR1A0--K@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     David Miller <davem@davemloft.net>
Cc:     sean.wang@mediatek.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, john@phrozen.org,
        linux-mips@vger.kernel.org, frank-w@public-files.de
Subject: Re: [PATCH net-next v2 3/3] net: dsa: mt7530: Add support for port
 5
References: <20190821144547.15113-1-opensource@vdorst.com>
 <20190821144547.15113-4-opensource@vdorst.com>
 <20190824.161912.1377369658338940538.davem@davemloft.net>
In-Reply-To: <20190824.161912.1377369658338940538.davem@davemloft.net>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Quoting David Miller <davem@davemloft.net>:

> From: René van Dorst <opensource@vdorst.com>
> Date: Wed, 21 Aug 2019 16:45:47 +0200
>
>> +	dev_info(ds->dev, "Setup P5, HWTRAP=0x%x, intf_sel=%s, phy-mode=%s\n",
>> +		 val, p5_intf_modes(priv->p5_intf_sel), phy_modes(interface));
>
> This is debugging, at best.  Please make this a debugging message or
> remove it entirely.

I change it to a debug message.

If there is nothing else I send a new version with this change also
add the tags ack-by Russell King and tested-by Frank Wunderlich.

Greats,

René


