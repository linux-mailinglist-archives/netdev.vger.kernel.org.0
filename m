Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441DB34F59
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfFDRyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:54:31 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52870 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfFDRyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:54:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so993702wms.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 10:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=snlWljHbyiYc5NMUY405FHmvRsv+YWjQScPjwf39fSw=;
        b=p1oWI0UMbKVEleRIa75VxpeOERVb02mb2YuXNGWEDXvd0aeudmINqM1hBtHsVXVC5k
         6o8iGLe/SgO0WoiF9yXSsx1HQOUb2QcML2Bz9U32XwOyf/l2JGajapPQRg435NeT1smq
         RED10vY1TQe0XX9QcOKC9DSARbR6NYCBy1gGgf/0lAekWM3/4bxNQsIkt89UixPw5Zz5
         ldDgiYP+4rE4nqLR3/3WPKbj5SS89Opk9S9NTBQFriM2bcLdVNrw7FFaSv7ZcOqDO+5B
         BnXMrC/rdAb+68al/zcGw6Bw9z8mC7dqaw6pNA61Zd7I51MhSYcZS+gdfOIRHIwnf8bV
         xTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=snlWljHbyiYc5NMUY405FHmvRsv+YWjQScPjwf39fSw=;
        b=kB0Yknus3mPnwUH4HvRAP6H5KNh92oSJU7Ncg3KCoIVyMPUb1QxbvTCC8l+ptbRY48
         YFcu05jU3j4OQnBKuA2KbVvtcC26X4WmR5G0QHqZ9BNc53GNCMEWriDRTqjKqHUYTVw3
         5y0gOkSESIJ5gPttFUnHFGe1U18MnPyooYokkqZszXwUU1U2k1eY+YFfSe7OtCeAlgOz
         MejDcnuWlUUOkw1SrFf5O8lNfau4fT0Kp5exj6qs4S5kYw1ZIa4eHHFKq+RL1MlQV5gW
         qXf9N992uj735+/tEBdFwonGpdPlA35AFkwnwa/wEe78nbM/g16y30iv4qJ2Uk/mVpzp
         UpyQ==
X-Gm-Message-State: APjAAAUwh0luVrdk0FpPHVrfND94yhgUcz8phwPzwjmK9IuYhHAVewtT
        UKhKJ/1VEnIarrCH2XDplAc=
X-Google-Smtp-Source: APXvYqyWqIkrpIk4plbcbS/U1oVvyUMykIAhibwi13iImIYoiC3AGB33cUqua4gPTSoiatUbKJ+uiw==
X-Received: by 2002:a1c:a942:: with SMTP id s63mr19120079wme.76.1559670869021;
        Tue, 04 Jun 2019 10:54:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2? (p200300EA8BF3BD00CD0DE1C0529B04E2.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2])
        by smtp.googlemail.com with ESMTPSA id c18sm18340867wrm.7.2019.06.04.10.54.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:54:28 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: phy: xilinx: add Xilinx PHY driver
To:     Andrew Lunn <andrew@lunn.ch>,
        Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
References: <1559603524-18288-1-git-send-email-hancock@sedsystems.ca>
 <d8c22bc3-0a20-2c24-88bb-b1f5f8cc907a@gmail.com>
 <7684776f-2bec-e9e2-1a79-dbc3e9844f7e@sedsystems.ca>
 <20190604165452.GU19627@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2a547fef-880e-fe59-ecff-4e616212a0f7@gmail.com>
Date:   Tue, 4 Jun 2019 19:54:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190604165452.GU19627@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2019 18:54, Andrew Lunn wrote:
>> So it seems like what is missing is the ability of genphy_config_init to
>> detect the bits in the extended status register for 1000Base-X and add
>> the corresponding mode flags. It appears bit 15 for 1000Base-X full
>> duplex is standardized in 802.3 Clause 22, so I would expect Linux
>> should be able to detect that and add it as a supported mode for the
>> PHY. genphy_config_init is dealing with the "legacy" 32-bit mode masks
>> that have no bit for 1000BaseX though.. how is that intended to work?
> 
> Hi Robert
> 
> I think you are looking at an old genphy_config_init(). The u32 has
> been replaced. Adding:
> 
> #define ESTATUS_1000_XFULL      0x8000  /* Can do 1000BX Full          */
> #define ESTATUS_1000_XHALF      0x4000  /* Can do 1000BT Half          */
> 
At least so far phylib knows 1000Base-X/Full only. Not sure whether optical
half duplex modes are used in reality.

Detecting 1000Base-X capability is one thing, how about 1000Base-X
advertisement and link partner capability detection?
If I remember the Marvell specs correctly, there was some bit to switch the
complete register set to fibre mode.

Robert, how is this done for the Xilinx PHY?


> and
> 
>                 if (val & ESTATUS_1000_XFULL)
>                         linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
>                                          features);
> 
> should not be a problem.
> 
>        Andrew
>   
> 

