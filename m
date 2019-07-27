Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2522677B29
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbfG0SnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:43:08 -0400
Received: from mx.0dd.nl ([5.2.79.48]:34258 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387880AbfG0SnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 14:43:08 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id D39795FCC5;
        Sat, 27 Jul 2019 20:43:05 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="HW/M9LbC";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 833111D2CA97;
        Sat, 27 Jul 2019 20:43:05 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 833111D2CA97
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564252985;
        bh=M4uxwYyb5FmmRAX/V16eef77IJ7AQ2sKjRtYnUKv06I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HW/M9LbCYz0GumbzhG25ZGpzeP2ttrAHRVBHU9pAyFfeoRsobIDNRrUCjQeybZA5J
         pmYE4lgqj7uyHnkMoyM50lJ1iKZFweDrpy5zFjylk7q44ZZl6hbyLtgKpqkGVLZFlK
         CJf4T+iKpNBk6Q+mnRIfM1u/nJ8yqo855kLgs6NUandlnrMMhsaH6Bhl0qVIIqLW8n
         1955B/lpIXrfSX+KUkPyMJqxdE7xm6PLNICSJndhxs4/iNpTi2kBlASW2BF+RdNMNB
         f1mbehtUESrB2J6x4wu9G+oRO4hTg62xwRT9pyqgjz8QZI6TmD9UcUeURQ8iVOUTty
         f0SDIfCfmXVOQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 27 Jul 2019 18:43:05 +0000
Date:   Sat, 27 Jul 2019 18:43:05 +0000
Message-ID: <20190727184305.Horde.vkqh7I-8IM_ifnVhhIU9l2c@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, matthias.bgg@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mt7530: Add support for port 5
References: <20190724192549.24615-1-opensource@vdorst.com>
 <20190724192549.24615-4-opensource@vdorst.com>
 <20190726.140420.688330328284393964.davem@davemloft.net>
In-Reply-To: <20190726.140420.688330328284393964.davem@davemloft.net>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting David Miller <davem@davemloft.net>:

> From: René van Dorst <opensource@vdorst.com>
> Date: Wed, 24 Jul 2019 21:25:49 +0200
>
>> @@ -1167,6 +1236,10 @@ mt7530_setup(struct dsa_switch *ds)
>>  	u32 id, val;
>>  	struct device_node *dn;
>>  	struct mt7530_dummy_poll p;
>> +	phy_interface_t interface;
>> +	struct device_node *mac_np;
>> +	struct device_node *phy_node;
>> +	const __be32 *_id;
>

Hi David,

> Reverse christmas tree here please.
>
> Thank you.

OK, I shall change that.
I spin a new version.

Greats,

René




