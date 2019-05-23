Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A53027482
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfEWCjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:39:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40058 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWCjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:39:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so2355127pfn.7;
        Wed, 22 May 2019 19:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=okkKWbqyaWlfW8yrczmJVf2RVVOHp7n/bP3cU4zZ1vY=;
        b=Pkk4MLe3ihlt/Fk7ne3smny1sUWGcCh3srPmm6tpYqHcKn03ph3YRCvM5YqF76fBYA
         Y5HuA3X2G4YnzdXupxBkpIZNroDxveZD8VRHGN0h8PAfFbc95nwuMHaAirIdrVZbi0lw
         vd//oAl4wpJYAgaU2lEgI2iZ3W42ORbX51CCxhlBbmnorEzM60zYPP9UVgCK4Dk1rr8+
         6oBZdfPH4EwUd52jaIjptulaDjDb8kLWWnY2peKOzdwdyXpMyWaKJ5DhTzKi7oD75fZ5
         B0zCQhvu+4HxQNKZ0veR5vw1Np36ZSIfUB3TeoaWcx+a/T3Z3TuvGO5MtCDPOBiMxHp3
         kV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okkKWbqyaWlfW8yrczmJVf2RVVOHp7n/bP3cU4zZ1vY=;
        b=W1OxMrngWsIxvcVh8jlARdWPrrvnCH0QkYuXzH2e6UrFgMhanmpiITF2/7+xvtme9h
         51FmwFXs5Zm0D5aPUn6m+bKoBrDNeg+iIdpd5Pqqw7FSoPHfoKq5sBzv8VqkwPJ3VBNn
         2NDAuxwyYvJMIdIecC+VDbGZxmVUVAJhu+l9OCmGVcS0mhkh568Kf7oTIwGJFQfJ4IYj
         hiOBGwmJ2TPNXcvEu2nHqVibMXMzFEBscodLmBFTnNEbfGU84ERvzzW8czxILRHQXoiA
         ECUKaDyFuxRnWj+qH+qyJQWYcsFMxy9jyVboAyh73AYBLNQBIqC0hHgWHbdijU/4njvd
         oY1w==
X-Gm-Message-State: APjAAAU61DXRfbpsdp7rF5ERAv8zDd71va52FwnB2QTopPC+mwhCbQkM
        1Zsar4L5iSPwF/pe27V5DJbn0RhY
X-Google-Smtp-Source: APXvYqz73eaN/IZf6n4DdhsH81Z24caoLUZ4knIMqrzuY5Jb8lgBEE+PgydSpMxTolltNlJFKgrvjQ==
X-Received: by 2002:a62:7793:: with SMTP id s141mr34249567pfc.21.1558579144946;
        Wed, 22 May 2019 19:39:04 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 8sm6972629pfj.93.2019.05.22.19.39.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:39:04 -0700 (PDT)
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20190517235123.32261-1-marex@denx.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <2c30c9c9-1223-ad91-2837-038e0ee5ae23@gmail.com>
Date:   Wed, 22 May 2019 19:38:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517235123.32261-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Vladimir,

On 5/17/2019 4:51 PM, Marek Vasut wrote:
> Add driver for the NXP TJA1100 and TJA1101 PHYs. These PHYs are special
> BroadRReach 100BaseT1 PHYs used in automotive.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: linux-hwmon@vger.kernel.org

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
