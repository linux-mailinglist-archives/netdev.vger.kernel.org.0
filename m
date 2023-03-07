Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1F06AF883
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbjCGWW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjCGWWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:22:33 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F95E055;
        Tue,  7 Mar 2023 14:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678227710; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=fq0l0Mn7rsWg13JF8UdJghSJygqsax/QuFmSrOL/n+DWNTTjRvDDL1U45oFmsrDwaXrBv2v2rRsCksZzoxCk7R5fURAH5fGz9MAP/UXADhTdasn6I6JTttXVhRiTdEu5VjWXIRj3a1f2NXFzDr+5podH8Tv0LRDIFaMLPv0WhCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678227710; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Q2HQP8/MVcj9MIcX18cZhupsRTYZeOIN4vKHN4gd43c=; 
        b=Y+fNQgSIvUPawBbWZan0TUZU+CWGzTR/YLGuO/GGr1+UU0bLpnce2AJtbQlpHgLn3/hwpFEMZNzywrp6PqFCmIaRS9PIHeBXK9DeNnzq6vENRKRGJUqgzBZKA4d7lT7vFz+lqJO0S5zRpOrqU1v7IyaJR0V/wtpZz4uX2RMC9hc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678227710;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=Q2HQP8/MVcj9MIcX18cZhupsRTYZeOIN4vKHN4gd43c=;
        b=RuCorPSbfab6nI/nGTr1ej4VR9NuoUZ3KSHaLUJqnblRe6dh3+dp1LWda9MafYIH
        FRMy/mbaQUpw61z4l0zX69ATefukyRMk5LzMirMZkb1Ux9P0ou5YJF/fBUCSUVbDGaD
        /MAjvoLlpbNSZojhpcqbwWarAHtY1WQhG+u0zFjM=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678227708891317.4113515802934; Tue, 7 Mar 2023 14:21:48 -0800 (PST)
Message-ID: <8cdd7a4e-4281-f75c-120a-7c4f7e50896d@arinc9.com>
Date:   Wed, 8 Mar 2023 01:21:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 1/2] net: dsa: mt7530: remove now incorrect comment
 regarding port 5
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230307220328.11186-1-arinc.unal@arinc9.com>
 <20230307220652.feb33nkb74x6y4ip@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230307220652.feb33nkb74x6y4ip@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8.03.2023 01:06, Vladimir Oltean wrote:
> On Wed, Mar 08, 2023 at 01:03:27AM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
>> be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
>> port 5") under mt7530_setup_port5().
>>
>> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   drivers/net/dsa/mt7530.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
>> index a508402c4ecb..b1a79460df0e 100644
>> --- a/drivers/net/dsa/mt7530.c
>> +++ b/drivers/net/dsa/mt7530.c
>> @@ -2201,7 +2201,7 @@ mt7530_setup(struct dsa_switch *ds)
>>   
>>   	mt7530_pll_setup(priv);
>>   
>> -	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
>> +	/* Enable port 6 */
>>   	val = mt7530_read(priv, MT7530_MHWTRAP);
>>   	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
>>   	val |= MHWTRAP_MANUAL;
>> -- 
>> 2.37.2
>>
> 
> It's best not to abuse the net.git tree with non-bugfix patches.

Fixing incorrect comments sounds bug fixing to me. Let's hear Jakub and 
David's thoughts.

Arınç
