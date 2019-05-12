Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3299A1AA0B
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 04:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfELCvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 22:51:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41430 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfELCvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 22:51:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id g190so3964555qkf.8
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 19:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B/KAgWyfgqk5almlyR5+Jik5osa6GatCOgrDSi79Lus=;
        b=Q/jpB414XuZHZK744XLTofwjnRhTeM1D9lOotrJdwgPg21oZTwJ2xumrkowYRs6Y9A
         v/NBZQjAuebqarWPsldzvgeyTYKiTkiZ57BJpCTe5ohmFQrmGPVxpsYNMp3xIolNb9w5
         vQvFBTwye6NjdHp1glo1SfQ1wkBmaHYY9NQlfXbW2p/l7XWXaSWdvwYSOD9deN1Z2olk
         HBvp/WarFC6WNocrVddb8bxlwabJgGnS8mNK3RB21b+xnxFROq3guZ8IpSGbdXLc44GO
         EwIdZsor9wC+1UVh1fT4FJ91rG0QFx/yOpu3s2xws7W5yIIzZS7PBwBv3p+fUGWRHACn
         HzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B/KAgWyfgqk5almlyR5+Jik5osa6GatCOgrDSi79Lus=;
        b=HIPItSatGyrkSK89ano54oQBhBYSt9omV0OQxoxc5MEWExb1X4lAYS2RcUj8hyE4ld
         csk+xJA5IdK6Sl07vB3N7ErSb2wFgqsNbhdu5X5StUqnBOx5EsNOxSkDeUy1DTe+MTno
         CsdTxUBsIb8dbLH2FKZhcxmdAURU6BXxJgkn/nVFz8CFUjmDSNacvBWVUWeDscBlmwux
         bbMWxWm9D3E4VwBzAikYeoY/aQ5QV0yjZClnB2WvFBobWVABUIm5vCWNkjnzgGID/KzT
         Fq7D39TnwYWDOcprRm5AeLvd+TPp7Io4m8KnVI98H9qwE4nsZQwqdgGc2jrQUmfS+rMJ
         YOfQ==
X-Gm-Message-State: APjAAAU2k08YIoJ/qutiEtxHaeF2L2hZLRwQZs7ik+CERw6QAcrDBv7Y
        xECUZg3tz4y2Y1aHwMWwfQ8=
X-Google-Smtp-Source: APXvYqxqamy1x2lu+27bfTpt1oirSw3dVa/Z1yxHDq01KM0Zq9NaiL/fo8n9/yklzTfGMT3f2KLSIg==
X-Received: by 2002:a05:620a:1019:: with SMTP id z25mr9746175qkj.46.1557629459948;
        Sat, 11 May 2019 19:50:59 -0700 (PDT)
Received: from ?IPv6:2601:153:900:ebb:b5f3:c6ee:317b:8b7e? ([2601:153:900:ebb:b5f3:c6ee:317b:8b7e])
        by smtp.gmail.com with ESMTPSA id e131sm4851787qkb.80.2019.05.11.19.50.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 19:50:59 -0700 (PDT)
Subject: Re: [Regression] "net: phy: realtek: Add rtl8211e rx/tx delays
 config" breaks rk3328-roc-cc networking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>
References: <066a0d38-2c64-7a1e-d176-04341f0cb6d7@gmail.com>
 <20190512023754.GK4889@lunn.ch>
From:   Peter Geis <pgwipeout@gmail.com>
Message-ID: <ae62419b-53f1-395d-eb0e-66d138d294a8@gmail.com>
Date:   Sat, 11 May 2019 22:50:59 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190512023754.GK4889@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/2019 10:37 PM, Andrew Lunn wrote:
> On Sat, May 11, 2019 at 07:17:08PM -0400, Peter Geis wrote:
>> Good Evening,
>>
>> Commit f81dadbcf7fd067baf184b63c179fc392bdb226e "net: phy: realtek: Add
>> rtl8211e rx/tx delays config" breaks networking completely on the
>> rk3328-roc-cc.
>> Reverting the offending commit solves the problem.
> 
> Hi Peter
> 
> The fix should be in net, and will soon make its way upwards.
> 
>      Andrew
> 


Good Evening,

Thanks, is there a link to the patch so I may test it?

Peter
