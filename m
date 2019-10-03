Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEBCCAEA3
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 20:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfJCSzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 14:55:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42428 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbfJCSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 14:55:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id q12so2310406pff.9;
        Thu, 03 Oct 2019 11:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=niJFTX5w2oyERI0e/I8dOvgdEptoO2AeWbZ2JEqdtoE=;
        b=gMPHmcPdow2EB9Ztm02uBEs9P4ariTp2YGaHkuAYvATWve0u6Pe9sLCZaxPN0lVYHL
         IlW7fCJBPkOyOywVmma2L2I84PUSQTQH5l7WQoI5gWWseLYSuIxJQZ8PIvQscjrav3RF
         5tksLEs9kTVHD+CSFvQJ3yTkZCH9/reh94N8zIgN9z8XBvwNiO1KMrddI2VXs+Ku0Nwd
         vNgl05rW9MnOUIyeBFLmTEWWd2Os7ndfbBG12KCEpbu3qNWyjcxosbzRxJjlMqKbnqsL
         R9GJmvs4hvuTk72ePPucl08Svh0mvb99kzVjHaiZHEC76PtLZ65Ri+cvF/G4JvoKBHdV
         AFbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=niJFTX5w2oyERI0e/I8dOvgdEptoO2AeWbZ2JEqdtoE=;
        b=CfDReCJdIWgMa4PCTYnPY/3J47UslLuioyKgZuJ1PMXOFnRTFakcY/0ghA8TEMZYXN
         SrzE69zLe096zG3eU6A6JL1w+Yv6RlVqCH1tpr828IIe3/4lINc8eeuykT3PkGMRJzTa
         eFOVta+EGvHMoOQJ2CalmlGMEV4z7pf3gLiwuMGcxCiJDIOoqJpt6Cr8Y87Q4Q0qSxdE
         ATV474lqBbYyVdZsqUbss89Pzpuk+rt8yHarxi+JZhcch1wOsTotPaYU8U+4oDyCkmA8
         mBruqx0VUgFodfkKk8DL7mrd8PBuyuIFFveVLakiYEJx2gvegy0ZmM2VvTluozRViOxF
         tYig==
X-Gm-Message-State: APjAAAU6nao8NLpBxUxv85LbiRhVZW+7o6sBQFBHHqGJsfcrCL+j583K
        BSjDzu8yccBUorJpYSgl65RJqqEZ
X-Google-Smtp-Source: APXvYqxgiw8Xkpz7DYQnl7SvAL4EgHJmIuWlDihtI5PZ8JpsgKMpbio04M2iofeiYJbCfWy8988R/w==
X-Received: by 2002:a17:90a:36ae:: with SMTP id t43mr12198694pjb.7.1570128944519;
        Thu, 03 Oct 2019 11:55:44 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u31sm3959750pgn.93.2019.10.03.11.55.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:55:42 -0700 (PDT)
Subject: Re: [PATCH 0/2] net: phy: broadcom: RGMII delays fixes
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com,
        manasa.mudireddy@broadcom.com, ray.jui@broadcom.com,
        olteanv@gmail.com, rafal@milecki.pl
References: <20191003184352.24356-1-f.fainelli@gmail.com>
 <20191003185116.GA21875@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <0d5e4195-c407-2915-de96-3c4b3713ada0@gmail.com>
Date:   Thu, 3 Oct 2019 11:55:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003185116.GA21875@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 10/3/19 11:51 AM, Andrew Lunn wrote:
> On Thu, Oct 03, 2019 at 11:43:50AM -0700, Florian Fainelli wrote:
>> Hi all,
>>
>> This patch series fixes the BCM54210E RGMII delay configuration which
>> could only have worked in a PHY_INTERFACE_MODE_RGMII configuration.
> 
> Hi Florian
> 
> So any DT blob which incorrectly uses one of the other RGMII modes is
> now going to break, where as before it was ignored.

Potentially yes. There is a precedent with the at803x PHY driver, and
both changes here aim for correcting that mistake. The PHY driver not
looking at phy_interface_t is a bug though. I will have a separate
conversation about solving those problems in a more generic way with you
and Heiner.

Rafal, do you have the platform DTS for which you added BCM54210E
support available somewhere so we can see whether this is going to break?

> 
> Maybe we should let this sit in net-next for a while, before back
> porting, so we get an idea of how many platforms we might be about to
> break?

Fine with me. It solves Ray's and Manasa's customer problem immediately
and they already back ported the first change in the their tree AFAICT.
-- 
Florian
