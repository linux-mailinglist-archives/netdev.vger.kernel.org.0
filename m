Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC5D6EF032
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 10:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbjDZIZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 04:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbjDZIYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 04:24:34 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0170A5253;
        Wed, 26 Apr 2023 01:24:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682497373; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QsalfbtmyXdTRKWmIqSJrHutOkrEm5PNdAvf5pAyCv2tfxvK+vGsXGmMdPAsCsXw/5wTlh8ippCXkAqSz/Wz2PDQA5S3oKqTpuYwy8ksYthBasGEHDrx9Ox28caRBQlsKVOYwnlfHT7u0EGrGyJWF7qiqQh7gx+TOkTNI7H9Hfo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682497373; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=2X1REwQCCwFMihGCGVH5kfEg/ebeje+8z4vEKJ17BBI=; 
        b=mLpT4MBvg9136utdDd6vWSlWaHSiwkDJP0xntKU9KgXSN3ooAOWAWDYTp6axo3ozCGtZ6iwHBVE1AC4WGEMXikWO1QqD/jkXzlcfvJWgMF8+OVd3pIvtfq9z/gHaZJ8MWiEEPR0hU5AWC0GGGxDCXSt7uqw63CfgJpo+6vJpZF8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682497373;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=2X1REwQCCwFMihGCGVH5kfEg/ebeje+8z4vEKJ17BBI=;
        b=dMH6pKBH/AR+ywpNXtkCeS1fzqvzz5NWSDlkRYQYrxfWRWSnrndOUqBhWsbtQma+
        D4GlsXiQziPgUns2b7hG04d178DmE/KcPOA5RAe+wAnLt0HlJuFd1QHidU48cPUpy4Q
        QRvLkV5yv1oEa9usMzo5qdW1eF+jpM81inrFLtGo=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682497371872497.30592440788405; Wed, 26 Apr 2023 01:22:51 -0700 (PDT)
Message-ID: <0e42a392-f497-125f-d07c-734ecb474771@arinc9.com>
Date:   Wed, 26 Apr 2023 11:22:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 10/24] net: dsa: mt7530: empty default case on
 mt7530_setup_port5()
Content-Language: en-US
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
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
 <20230425082933.84654-11-arinc.unal@arinc9.com>
 <ZEfuIHET4Nva0hj4@makrotopia.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZEfuIHET4Nva0hj4@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.04.2023 18:13, Daniel Golle wrote:
> On Tue, Apr 25, 2023 at 11:29:19AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> There're two code paths for setting up port 5:
>>
>> mt7530_setup()
>> -> mt7530_setup_port5()
>>
>> mt753x_phylink_mac_config()
>> -> mt753x_mac_config()
>>     -> mt7530_mac_config()
>>        -> mt7530_setup_port5()
>>
>> On the first code path, priv->p5_intf_sel is either set to
>> P5_INTF_SEL_PHY_P0 or P5_INTF_SEL_PHY_P4 when mt7530_setup_port5() is run.
>>
>> On the second code path, priv->p5_intf_sel is set to P5_INTF_SEL_GMAC5 when
>> mt7530_setup_port5() is run.
>>
>> Empty the default case which will never run but is needed nonetheless to
>> handle all the remaining enumeration values.
> 
> If the default: case is really just unreachable code because of the
> sound reasoning you presented above, then you should just remove it.

The compiler prints warnings if all enumeration values are not handled.

   CC      drivers/net/dsa/mt7530.o
   CC      drivers/net/dsa/mt7530-mdio.o
   CC      drivers/net/dsa/mt7530-mmio.o
drivers/net/dsa/mt7530.c: In function ‘mt7530_setup_port5’:
drivers/net/dsa/mt7530.c:919:9: warning: enumeration value ‘P5_DISABLED’ 
not handled in switch [-Wswitch]
   919 |         switch (priv->p5_intf_sel) {
       |         ^~~~~~

> 
>>
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index aab9ebb54d7d..b3db68d6939a 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -933,9 +933,7 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
>>   		val &= ~MHWTRAP_P5_DIS;
>>   		break;
>>   	default:
>> -		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
>> -			priv->p5_intf_sel);
>> -		goto unlock_exit;
>> +		break;
> 
> I suppose you can also rather just remove the default: case alltogether
> instead of keeping it and making it a no-op.

I make use of the default case with ("net: dsa: mt7530: rename 
p5_intf_sel and use only for MT7530 switch") so I'd rather keep this.

Arınç
