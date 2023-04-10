Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6336DC816
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjDJOyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDJOyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:54:12 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63FC49FE;
        Mon, 10 Apr 2023 07:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681138399; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=J6MCuVdGQQF5zdoIjrIsl7e2AYlUHKFWDp2E4Sb1caHAB1zyBJ6tNdP3dGdy4WhiTUUaL9zsx/KCBSjL+JPnOzp1YVzzlms+rog3UCXd2TmZhC2GCg7iJcx44addsfr0A+g/cvuCytsmP5eh+vxkYxx82G3VZidkqbB8360bMrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681138399; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dY6OdK8Qxe58n3zh/amuYn/epx3ZaA+g2MhS9h/rQa4=; 
        b=BaZGo00Jl/FMcG5hX1YAwpHmaKqP9yGO7rIe4zX9eA3j9GpdVtBbfMguPccU8hrAyqoFHPEGEp+TWJGgcsJ75hnZg/k9fMjLWpU+4mS9vBqLQBq+hWyzRDeqWlVmCzCFPIcR8CJ1RyaU1tmyBhppJhcDmAUsyudnYA60k8M/adw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681138399;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=dY6OdK8Qxe58n3zh/amuYn/epx3ZaA+g2MhS9h/rQa4=;
        b=TDBx20RAzQVPDVTsC+bpcD+SzC3jUdWHnb9GPLkBhDqsmcUjNYq82asLIJpK5Nor
        GPKL/KUBHanYRA1Ydq5Qp6tIrJxdEB8l3gmXk7Ss4lSHZqmpxKAQxpB/S57SUNOPQ6K
        Yrjvhg8LbU9kyx1egHzBQ8PRTBZ+ZfZw6HEitz48=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681138397321372.7074583053213; Mon, 10 Apr 2023 07:53:17 -0700 (PDT)
Message-ID: <2dfa9c4c-fb7a-142b-b2e7-6a1564ab4f80@arinc9.com>
Date:   Mon, 10 Apr 2023 17:53:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH v2 net-next 01/14] net: dsa: mt7530: fix comments
 regarding port 5 and 6 for both switches
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
 <20230407134626.47928-2-arinc.unal@arinc9.com>
 <ZDQdmih4aHdrUvqr@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZDQdmih4aHdrUvqr@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.04.2023 17:30, Daniel Golle wrote:
> On Fri, Apr 07, 2023 at 04:46:13PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> There's no logic to numerically order the CPU ports. State the port number
>> and its being a CPU port instead.
> 
> Port 5 is often used as a user port as well, eg. on the BPi-R3 where
> it serves to provide SerDes for the 2nd SFP cage.
> On other boards (e.g. Netgear WAX-206) it is used to connect a 2.5G
> PHY used as WAN port.
> 
> Hence just stating that port 5 "a CPU port" could be a bit misleading
> as it is not always used as a CPU port.

Makes sense. I was not using the DSA term, so the "a CPU port" here 
rather meant that the port connects to the CPU. I'll change it to "which 
can be used as a CPU port" on both ports, that should explain that it 
can be used as other than a CPU port, and it does not necessarily 
connect to a CPU MAC.

Thanks.
Arınç
