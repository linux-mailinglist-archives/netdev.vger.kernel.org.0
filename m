Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354BB8834A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfHITbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:31:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40783 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfHITbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:31:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so6542690wmj.5
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 12:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SgsfOBYMqbrMMTCe2EIeFSMj9jEr08Ruc24ofB6If8M=;
        b=Qp3d9ZZqe2AvhfFvZLyJaL3rSbePSn/VpgOvWl4Zm+XlqXi2RXKK8wZAeQydfBPpp2
         4qZxO5f+pmgp27eG5afwzGuSvtfTAJL3Lt7yioTugColnS6QgEMX7nxVUftxsmET5n6d
         ssqsRzaCkcxl1N83qMyL9bbqe2muzmsxzZDP5mZjxu6FZhpkbSgLDckcm/1GXnHSdK8w
         XfZ3dQEghrJtz9huhPiRYVAEGNxoIHMCMolMfarVLgI5NOQUEo5GW/LTd6jQTCVlzTsy
         6mhUfqNTsE3ifgZh+oHW2yy5GUzu0bn39tauqKC7OARdyLAPDNYL12aUqgI8sp4XfpUV
         6znQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SgsfOBYMqbrMMTCe2EIeFSMj9jEr08Ruc24ofB6If8M=;
        b=lLPzZo9NWzjtdv+tT3jjuLuFrwM6bxKbNQ3wsBG22NrpaK83S0HjmGqdXihMoE8LoE
         MsfGFDUkuRvlmdM5OQAZ3pLfO4Y8Y4xtoEmjCKkZngiIWB9xkTjQ9Q6P7yOl0CPEKfR5
         iHtViPmDE+RyvCOOWECdN0hCvmE+OxinxZgyWd4ORBwnMSJ8MrlexyP72of54FH32eS0
         nNkD3cTeUaZ8dJlUAfFZrh60Et1CeAAi4d6oJhwxPgDWpKsuYLYf4H5sQjcBfXj5gSSm
         iaEViPjFE72HnhBqOuMQCiAmCdhebgoMur0ONFmnWR2RYi4468ijK4tjUfnOA2yhxRPo
         P6SQ==
X-Gm-Message-State: APjAAAWYTnTvUxXUp7/EgrqqFXXQ2KqczjW0FeNvod2aeaNhmyy9dOm/
        9N3Sbmh2eTaIuHDwMys6yLeZvrgo
X-Google-Smtp-Source: APXvYqxCLW/g2sriNSs5XuRm3Zg5XrgKfCDNVjWuhGoZNqFzKZRnlCqYoW32NnSzBzPM1b6FEcvoMA==
X-Received: by 2002:a1c:2015:: with SMTP id g21mr12341697wmg.33.1565379101084;
        Fri, 09 Aug 2019 12:31:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id e10sm18152407wrn.33.2019.08.09.12.31.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 12:31:40 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
 <49454e5b-465d-540e-cc01-07717a773e33@gmail.com>
 <20190809191822.GZ27917@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c8e2b3e7-1d0b-eba3-6a36-8808641f3031@gmail.com>
Date:   Fri, 9 Aug 2019 21:31:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809191822.GZ27917@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.08.2019 21:18, Andrew Lunn wrote:
>> +	}, {
>> +		PHY_ID_MATCH_EXACT(0x001cca50),
> 
> Hi Heiner
> 
Hi Andrew,

> With the Marvell driver, i looked at the range of IDs the PHYs where
> using. The switch, being MDIO based, also has ID values. The PHY range
> and the switch range are well separated, and it seems unlikely Marvell
> would reuse a switch ID in a PHY which was not compatible with the
> PHY.
> 
> Could you explain why you picked this value for the PHY? What makes
> you think it is not in use by another Realtek PHY? 
> 
0x001cc800 being the Realtek OUI, I've seen only PHY's with ID
0x001cc8XX and 0x001cc9XX so far. Realtek doesn't seem to have such
a clear separation between PHY and switch PHY ID's.

Example:
0x001cc961 (RTL8366, switch)
0x001cc916 (RTL8211F, PHY)

Last digit of the model is used as model number.
I did the same and used 5 as model number (from RTL8125).
Revision number is set to 0 because RTL8125 is brand-new.

I chose a PHY ID in 0x001ccaXX range because it isn't used by
Realtek AFAIK.

> Thanks
>     Andrew
> 
Heiner
