Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4D818E96C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCVOpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:45:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38871 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVOpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 10:45:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id s1so13392650wrv.5
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 07:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tM6qCexDu3ONZdQMufO4CkxaRE2mCrIcetMiE6CosGo=;
        b=fzSDacmUh7M8dLnF3M6IXUV5Kih4bPXrjHVcHmPheJ9enWB6tlJPOqZ092vChlPqf/
         9fypiB+czCZZ3qAvXf2SclLt7I2C7B9h3S/7tJFILKheE6YcDS03nes5l8uunGVM0rHL
         Ls2lKjFc3zkEoeF/Krbed499hgxZYJ/Y2VxURZLnAYY1AunmNvabdU0XDZ2p/NFyPzSD
         WaK10UP/vXcUDxZGaogj3fEIKnh9/rnNG4Lvt4jRDL5GXS9wS/IrBlujxI6KiCBjDOaq
         Busml7avyBd0YHmK2cRzMwcqKEheA3wGfu9VuqkcilobtuwVijqnThT/98lyG68vmHL6
         wLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tM6qCexDu3ONZdQMufO4CkxaRE2mCrIcetMiE6CosGo=;
        b=a8vFQLNiG5oiJC3JPWZrkU1C8DYYjq9D/+H+l45Oi5uUBKJEwV3wdB0R8n5huVaU1W
         dy6FZ+BKnrvLbxg5BNipm0I6Hbsss7T3BIE1/O6SNeldlqldUw+89fU+XcIZET9aE8hk
         wxxzSe2nFayDu1TentxvZxpmetovmuh/eF2O7XNjkAhF4G9EmbgcF0YjxBvUKJ/THV8W
         pzLgaC5OsIIlZzY9NocCGJzuhZcqQlhimxRwfhr+7MAQIQ0Q5BwLyz4MQrFGThlXob2F
         UqrCPhrSaKuC85EGO3chY4Wcbq84XPSCFYB3WilnR9FrVltDfgrcqjuF77Ypfozj4NjC
         61EA==
X-Gm-Message-State: ANhLgQ1OZ5pPssf7TRgbvnCPrPL3rjDLKi40m3RUrDFdsEtOufMzVBWA
        kH0BXV6p/QC7MOxl/ezoL4xCyxvq
X-Google-Smtp-Source: ADFU+vviSqTcvw3n1A95GihKJf5ZpYjfqoZ7GCaozcU4IL0psvMw6AEHzjEIyf1i2gKmhgqFvd2Y3w==
X-Received: by 2002:adf:f610:: with SMTP id t16mr1852287wrp.30.1584888330045;
        Sun, 22 Mar 2020 07:45:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:1055:511c:c4fb:f7af? (p200300EA8F2960001055511CC4FBF7AF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1055:511c:c4fb:f7af])
        by smtp.googlemail.com with ESMTPSA id e1sm19472302wrx.90.2020.03.22.07.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 07:45:29 -0700 (PDT)
Subject: Re: [PATCH net-next] ethtool: remove XCVR_DUMMY entries
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <44908ff8-22dd-254e-16f8-f45f64e8e98e@gmail.com>
 <20200322140837.GG11481@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <731810bd-7e8f-8e34-304a-52e0f1286ba0@gmail.com>
Date:   Sun, 22 Mar 2020 15:45:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200322140837.GG11481@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.03.2020 15:08, Andrew Lunn wrote:
> On Sun, Mar 22, 2020 at 02:14:20PM +0100, Heiner Kallweit wrote:
>> The transceiver dummy entries are not used any longer, so remove them.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  include/uapi/linux/ethtool.h | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index d586ee5e1..77721ea36 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -1673,9 +1673,6 @@ static inline int ethtool_validate_duplex(__u8 duplex)
>>  /* Which transceiver to use. */
>>  #define XCVR_INTERNAL		0x00 /* PHY and MAC are in the same package */
>>  #define XCVR_EXTERNAL		0x01 /* PHY and MAC are in different packages */
>> -#define XCVR_DUMMY1		0x02
>> -#define XCVR_DUMMY2		0x03
>> -#define XCVR_DUMMY3		0x04
> 
> Hi Heiner
> 
Hi Andrew

> We need to be careful here. This is a UAPI header. The kernel might
> not use them, but is there any user space code using them?
> 
Right. I checked ethtool and it doesn't use the dummy values.
Wherever I checked only the internal/external values are used.

In kernel last usage of the dummy values was removed 2yrs ago,
see e.g. here: https://lore.kernel.org/patchwork/patch/767218/

> A quick search found:
> 
> http://www.infradead.org/~tgr/libnl/doc/api/ethtool_8c_source.html
> 
I checked here http://git.infradead.org/users/tgr/libnl.git and there
hasn't been such an ethtool.c file for ages.

> 	Andrew
> 
Heiner


