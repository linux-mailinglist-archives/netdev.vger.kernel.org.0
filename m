Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B23A19E009
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 23:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgDCVC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 17:02:58 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52196 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCVC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 17:02:58 -0400
Received: by mail-wm1-f45.google.com with SMTP id z7so8516591wmk.1
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 14:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nEXVJYWITTJ5p6Nwz5MLlphsW4M43kjWWJy0LTCYHvA=;
        b=pKW79JxzprWcHP2lSVLzIDuBMsDFkcr0cwsNV9FKHJBZSwugOAOETtOWks72Ob4gOh
         EVp0Lk9k+Fu4iZbmQv1XQFAL1nQdUxx5KapUtKWwOEGd0UHv88nlg2tCDN4mdsFT89T2
         1c4o8D73M1z2xJbRgYDXVUxl6p31WtZKxhFmUJu716DQgbMIKsG3zy/Ld9oU+m0GUu3Y
         Qe7P4Sf3bKbL2HxTin7G0sHaq5XKVcEwxFXyQMAIEE018F6OvHA+hqav/+oaLxL3MANT
         SE7ZvAfOiABBMdbucnGtqk3c59avdfOo2DoKErtUL8akH83s5NNgi0LiT0jowzz7Gc5j
         MyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nEXVJYWITTJ5p6Nwz5MLlphsW4M43kjWWJy0LTCYHvA=;
        b=Z5ZXmvH5lydLAVWS3Igrk7WuPA4Vobo4nKPC7td6Gcb5auZzpuE0gdzkvPM5Vv90Tf
         RLrBYecaja/xtTdy8Vyl1TLThekbGF7AGTkctgxHDGSyhStKmExnAKg4pnqtaB/W6fu2
         BMAc6+d68FE6L2EfXY1jIEasJHRx6ij1Hw7ipfU2cLecry2qlICs8urhQxKP/hrQ14ja
         jyNcE//su6Q0S1JIjiC7RUkyJiU5CfcKEdQkYhQAuWP9fEpdLdAGp3ZW7JjfqbNGk+7M
         LCHL+Fv3mhadX7mnFtZLK5edWe0FU2ne97yNUObvzoUXFrJrDXLeuYnc+Tp8F1aWgVq/
         jy0g==
X-Gm-Message-State: AGi0PuarMBw8eeAkv0CTeFJh43KugVJYwGKIkzfqL6ylA5XHzxRRsYsn
        DGXxT5xDyQNPWIlwjsGCu/0=
X-Google-Smtp-Source: APiQypLJjitYlDMxR+3BnOWsql3C0Jqa+8wHwX3SAKDTGAHuEq1Tm3laqg+FIAbUxBOdqNPXkDi9CQ==
X-Received: by 2002:a1c:4d7:: with SMTP id 206mr10340157wme.5.1585947776157;
        Fri, 03 Apr 2020 14:02:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:5844:50ff:2f28:ec08? (p200300EA8F296000584450FF2F28EC08.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5844:50ff:2f28:ec08])
        by smtp.googlemail.com with ESMTPSA id a13sm13313421wrh.80.2020.04.03.14.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Apr 2020 14:02:55 -0700 (PDT)
Subject: Re: question about drivers/net/dsa/sja1105/sja1105_main.c
To:     Vladimir Oltean <olteanv@gmail.com>,
        Julia Lawall <julia.lawall@inria.fr>
Cc:     netdev <netdev@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <alpine.DEB.2.21.2004031542220.2694@hadrien>
 <CA+h21hrP-0Tdpqje-xbPHmh+v+zndsFyxaEfadMwdAHY+9QK+g@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7fc8f8d5-285a-9ec0-23c5-c867347c4feb@gmail.com>
Date:   Fri, 3 Apr 2020 23:02:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrP-0Tdpqje-xbPHmh+v+zndsFyxaEfadMwdAHY+9QK+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.04.2020 16:36, Vladimir Oltean wrote:
> Hi Julia,
> 
> On Fri, 3 Apr 2020 at 16:46, Julia Lawall <julia.lawall@inria.fr> wrote:
>>
>> Hello,
>>
>> The function sja1105_static_config_reload in sja1105_main.c contains the
>> code:
>>
>>                 if (!an_enabled) {
>>                         int speed = SPEED_UNKNOWN;
>>
>>                         if (bmcr & BMCR_SPEED1000)
>>                                 speed = SPEED_1000;
>>                         else if (bmcr & BMCR_SPEED100)
>>                                 speed = SPEED_100;
>>                         else if (bmcr & BMCR_SPEED10)
>>                                 speed = SPEED_10;
>>
>>                         sja1105_sgmii_pcs_force_speed(priv, speed);
>>                 }
>>
>> The last test bmcr & BMCR_SPEED10 does not look correct, because according
>> to include/uapi/linux/mii.h, BMCR_SPEED10 is 0.  What should be done
>> instead?
>>

It's right that this is not correct. You can check genphy_read_status_fixed()
for how it's done there.


>> thanks,
>> julia
> 
> Thanks for pointing out, you raise a good point.
> Correct usage would be:
> 
> include/uapi/linux/mii.h:
> #define BMCR_SPEED_MASK 0x2040
> 
> drivers/net/dsa/sja1105/sja1105_main.c:
>                          int speed = SPEED_UNKNOWN;
> 
>                          if (bmcr & BMCR_SPEED_MASK == BMCR_SPEED1000)
>                                  speed = SPEED_1000;
>                          else if (bmcr & BMCR_SPEED_MASK == BMCR_SPEED100)
>                                  speed = SPEED_100;
>                          else if (bmcr & BMCR_SPEED_MASK == BMCR_SPEED10)
>                                  speed = SPEED_10;
> 
> but the BMCR_SPEED_MASK doesn't exist, it looks like. I believe that
> is because drivers (or the PHY library) don't typically need to read
> the speed from the MII_BMCR register, they just need to write it. If
> the PHY library maintainers think there is any value in defining
> BMCR_SPEED_MASK as part of the UAPI, we can do that. Otherwise, the
> definition can be restricted to drivers/net/dsa/sja1105/sja1105.h.
> 
> Thanks,
> -Vladimir
> 

