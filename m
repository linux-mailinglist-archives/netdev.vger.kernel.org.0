Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1EC368AD8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240282AbhDWB6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbhDWB6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:58:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45F8C061574;
        Thu, 22 Apr 2021 18:58:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so357063pjj.3;
        Thu, 22 Apr 2021 18:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wWXKWjw/qIb/ru01DOT+nC/pxXhQH5QNjZ33c1z6zdE=;
        b=rFc6LgGOyfvlnGOQBN5TLWDWOqIPs0ks58HssAn2SrpIyD9dE1BItQXVzSYZ/tEhXF
         F0wpB+9GAONIWPLEBVYv3cVOzeJR/9UznQKfm6ze34LDogWtqeHPN3hn8aCez6tqUlPt
         YEctJViIjlfj0yyI35eRtIXSWez2gMsIm0VFHXo5AbJuQy0bjdMLgZbRxwMuPA6VNXsU
         3t5ewMAog64u7FZM+nvxM8paXnZG546mP4C9cfMU57F5BcqbJpcmvzVAZ6B7d/A7v3ye
         JBIeDrsn44Vb1apXq3MPpl6giIIXIukxjvNL1C3li1UzDs53gHFDwFBlFudTCDgoTwce
         7QNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wWXKWjw/qIb/ru01DOT+nC/pxXhQH5QNjZ33c1z6zdE=;
        b=WSb4otrNpI1rgCOgLTfL8kvLMMXoBJ/e7JT0ZMy86OTX46gTPFEsyMzHaNHOnYr8aj
         Myn9xOhFl8u5snBr9W+hA3Mit97msfVxlB5at+seDc0wy1PgM6dESCaIERhjbQaTkro9
         JDtySOGROG34NlkzCKY+NfJvxYrkPXnia/2MbPkt2TB/xqjP4RmpCVhfdn1JQsRwd/mC
         I499vI8LS2nPMP3Xqs7bR2kUcY+d8J1WkaZ1LSQuLyIo5yIK9zl7LK1Fo/Y8mCLFeyLL
         /KrwZBs1mHM/nVDN8J9if8jTxPQCQSLRPO3JGkRDvAvIfvzMIzLS1wb4QKjU0nrPu4Fj
         62iA==
X-Gm-Message-State: AOAM531KF7OwZg0egSk2MG6Fynoc2EAzE98n3YEyuvzdtde0c1u6SHyY
        GPImimZe/FgM/qZqlrbFvTICqFC7D90=
X-Google-Smtp-Source: ABdhPJzOXvdPSk+sslMgzy4Jqaem9nL8tOrEXvYdUpJZNtrzAje5kAxLPx58FiqENjhUFqG9kZaRfA==
X-Received: by 2002:a17:90a:c203:: with SMTP id e3mr1702759pjt.173.1619143092945;
        Thu, 22 Apr 2021 18:58:12 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 187sm2987078pff.139.2021.04.22.18.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:58:12 -0700 (PDT)
Subject: Re: [PATCH 02/14] drivers: net: dsa: qca8k: tweak internal delay to
 oem spec
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-3-ansuelsmth@gmail.com>
 <fdddeb1a-33c7-3087-86a1-f3b735a90eb1@gmail.com>
 <YIIpjBH8hZH/MaS7@Ansuel-xps.localdomain>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <79789d16-fced-b5b8-75da-31313e1486e6@gmail.com>
Date:   Thu, 22 Apr 2021 18:58:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIIpjBH8hZH/MaS7@Ansuel-xps.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:57 PM, Ansuel Smith wrote:
> On Thu, Apr 22, 2021 at 06:53:45PM -0700, Florian Fainelli wrote:
>>
>>
>> On 4/22/2021 6:47 PM, Ansuel Smith wrote:
>>> The original code had the internal dalay set to 1 for tx and 2 for rx.
>>> Apply the oem internal dalay to fix some switch communication error.
>>>
>>> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>>> ---
>>>  drivers/net/dsa/qca8k.c | 6 ++++--
>>>  drivers/net/dsa/qca8k.h | 9 ++++-----
>>>  2 files changed, 8 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
>>> index a6d35b825c0e..b8bfc7acf6f4 100644
>>> --- a/drivers/net/dsa/qca8k.c
>>> +++ b/drivers/net/dsa/qca8k.c
>>> @@ -849,8 +849,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>>>  		 */
>>>  		qca8k_write(priv, reg,
>>>  			    QCA8K_PORT_PAD_RGMII_EN |
>>> -			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
>>> -			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
>>> +			    QCA8K_PORT_PAD_RGMII_TX_DELAY(1) |
>>> +			    QCA8K_PORT_PAD_RGMII_RX_DELAY(2) |
>>> +			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
>>> +			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
>>
>> There are standard properties in order to configure a specific RX and TX
>> delay:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/ethernet-controller.yaml#n125
>>
>> can you use that mechanism and parse that property, or if nothing else,
>> allow an user to override delays via device tree using these standard
>> properties?
> 
> Since this is mac config, what would be the best way to parse these
> data? Parse them in the qca8k_setup and put them in the
> qca8k_priv?

Yes something like that would work.
-- 
Florian
