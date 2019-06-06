Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E436C0A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 08:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfFFGFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 02:05:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38240 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfFFGFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 02:05:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id t5so1048087wmh.3
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 23:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vxrK8jiKSv8pqhDDvbbITa8aPCtnQMNqCsxmQIQUkFo=;
        b=JW0tz/dH6nSomBGh6yhBKuEbWfWFCOrccF+zQJhkmvxiwqNEBzgbfodpx9HeV+m+ch
         uTlkF1Kl3oh5rqEG8CKidT1Vuuu3n7RRSAeBdXCJ5s1asmo8SNMDlZQZB7Goez94492q
         UATTouY82XtOet5BS+pBg+NMbmU+0EYadgGGvBNOKBbiqbE40OeXBeCRGDSVo15FbJ5J
         2Iiq+fWudr1Nr152wV35Txdpz2iZ5Xb1xYDbWaRg0Gh39ke2kAZNqSYObO1uKiSnxLpe
         xu2MewByhdjK/GCyxNla1bfz9RACNSUTpPR0Xdh8oXDJKe67FaJ9uJ7HeQAxquxFsETU
         8ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vxrK8jiKSv8pqhDDvbbITa8aPCtnQMNqCsxmQIQUkFo=;
        b=Qq+QWMNA3Vo3FN9uIseJQ01gzl7eY4jE4VEOaodzUZzTMtmnU1BFmNj8P1ofBNY15D
         OgtGyf1aT7Exs5HwJgjvua3ElTvrVjFsmZQlTYTYc7fI8Rh8DBgQsG2tx2SozZNQguk3
         tXbK6xYrNFXT8eMLdalZjggKiwd7bGRUUGukemfOka2cflXUtdk1hqY8sfDJwXkovV+p
         me+iLrCdOZf3w42Zd3/lqoJU23SHohLvVB37kSkWcl0attgxOZKw5wdLcJ2JwXmZFyK4
         F5swvW9i1qNUbHaFBIgu4ezdfUbUkRPwkgUsWjiIi/KP2Agw56OVVHW1Vry8GCEvO3Mb
         1JTA==
X-Gm-Message-State: APjAAAWfYOLtEPCUUCz2sKmDNCSqPiGlGOin+ka8F+I8kp6FqpoB5+g5
        7U3ebQWR5ONTcim+AnMCFc8=
X-Google-Smtp-Source: APXvYqzRdBaqncNKnZmuCs5Ursxzr7Lspj//iQifJhP07kL+/H1B0uiLIP+fm/WWB5gxJUzRL4KILg==
X-Received: by 2002:a1c:c8:: with SMTP id 191mr13147067wma.6.1559801136392;
        Wed, 05 Jun 2019 23:05:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:4dec:a307:3343:e701? (p200300EA8BF3BD004DECA3073343E701.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:4dec:a307:3343:e701])
        by smtp.googlemail.com with ESMTPSA id w185sm686405wma.39.2019.06.05.23.05.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 23:05:35 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: Add detection of 1000BaseX link mode
 support
To:     David Miller <davem@davemloft.net>, hancock@sedsystems.ca
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com
References: <1559686501-25739-1-git-send-email-hancock@sedsystems.ca>
 <20190605.184254.1047432851767426057.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <20b0f19b-131d-2db0-dfa6-dac7e5b8d422@gmail.com>
Date:   Thu, 6 Jun 2019 08:05:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605.184254.1047432851767426057.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.2019 03:42, David Miller wrote:
> From: Robert Hancock <hancock@sedsystems.ca>
> Date: Tue,  4 Jun 2019 16:15:01 -0600
> 
>> Add 1000BaseX to the link modes which are detected based on the
>> MII_ESTATUS register as per 802.3 Clause 22. This allows PHYs which
>> support 1000BaseX to work properly with drivers using phylink.
>>
>> Previously 1000BaseX support was not detected, and if that was the only
>> mode the PHY indicated support for, phylink would refuse to attach it
>> due to the list of supported modes being empty.
>>
>> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> 
> Andrew/Florian/Heiner, is there a reason we left out the handling of these
> ESTATUS bits?
> 
> 
I can only guess here:
In the beginning phylib took care of BaseT modes only. Once drivers for
BaseX modes were added the authors dealt with it in the drivers directly
instead of extending the core.
