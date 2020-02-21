Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC29A167913
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgBUJLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:11:25 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38504 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgBUJLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:11:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id w1so1420949ljh.5
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uqicr7ulyEE9/gCYqhldowylixyG+Rd8vjIvUGAs1P4=;
        b=BmTDL3RekvaXOYAJDjTNkXaspABD4rLjp/vylzgr08wmZGbtPkjSZZOhig7lplMHdN
         aiTWfsb/MfXUAPs5th3XRJbvCQ3uPkdQitX1k5X3seS5fuWe/h2l37VO0qsBC6RBG9Bz
         KLxM9eqDar+oTmcVgGWIuU2IPIQtDL+/eYWhp/T76s9a06IddFTzsbViop1pGdsbxOEP
         fampIgqahFqPakdDfbz+poZjLctSibOI0aBt24cN61tbfM8izVb/J2gsKbIyX0OcOqIW
         iFZS2P5phTVKnNyqVIJDRJGNkQquZ8qZO7nn26q7ZKz7abXZsoVdNZ1rdjEyZYHBBc5C
         hQgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uqicr7ulyEE9/gCYqhldowylixyG+Rd8vjIvUGAs1P4=;
        b=c5dEq+zXIiR8ystOHgEyRhw1BkmpDbYFekZ5VlCjKJrOXxRISUJ093Tljnc5vyWiRR
         3u1m9bIHSIySa6f+CSr+SfeBK3/xHC8eErYZaIhDeiZZYueLmGxJeHPhQXH2C4dQOG/m
         Y0lv36IWs5LlshW+ygdfaorc5uELUlx1/VG1y5h9UIliy/rtbdHP+lS45TpLkVkpnbih
         2vGTiBNMdcFYI6CZELCjP1cFw1mCo/llsU2Ybt/wzlSHj22sgVG+i02sSxRjYDmdzgqs
         7IHliO9ms+2dzWg02ujj9WXP/3ceupP3Gf7ORZVsu7HgpKXOdULzojCm2Pv3zVpLHsyL
         5kqQ==
X-Gm-Message-State: APjAAAVHk98zM89J8AxlCAY9iOMj0CbbaXWDo+xV2TuHUr5lSb42BeNy
        oxe9Rez+t9DJu7LWWJDDnTt0xH4nGkqmKQ==
X-Google-Smtp-Source: APXvYqxW6kEJpj8QfIyj2W2rvrA+nlToEPd0fjv7t7/hmOKR3K53AbVVp1UAPMQG1udtoSqkV/sK8Q==
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr21093120ljc.185.1582276281829;
        Fri, 21 Feb 2020 01:11:21 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:63b:9c7c:6181:b4e1:207b:4da4? ([2a00:1fa0:63b:9c7c:6181:b4e1:207b:4da4])
        by smtp.gmail.com with ESMTPSA id 19sm1485196lft.81.2020.02.21.01.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 01:11:21 -0800 (PST)
Subject: Re: [PATCH net-next 02/16] net/dummy: Ditch driver and module
 versions
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20200220145855.255704-1-leon@kernel.org>
 <20200220145855.255704-3-leon@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <cde72970-e4f9-1747-0fee-75639190b127@cogentembedded.com>
Date:   Fri, 21 Feb 2020 12:11:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200220145855.255704-3-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 20.02.2020 17:58, Leon Romanovsky wrote:

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Delete constant driver and module versions in favor standard
                                                      ^ of?

> global version which is unique to whole kernel.
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
[...]

MBR, Sergei
