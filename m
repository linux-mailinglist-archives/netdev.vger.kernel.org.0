Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06DA108013
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 19:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKWSu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 13:50:28 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40827 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfKWSu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 13:50:28 -0500
Received: by mail-pg1-f194.google.com with SMTP id e17so5052393pgd.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 10:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=PuJsZuj1KUOMVGQQRhz0AFKXCZlP3B+1wIYCZL517JE=;
        b=yldlGdHzSGgEn8hFgVHQzCBFpBYwgG6TO9V4BHOUcKClhVoq8QsEfe6a8tzcKg9oBI
         4FVGUZMwg5oev4TvAnT7kBTkSze//44R9XGLt40xm1CDQFlfgBiNplg0b5v/hWW3DT+E
         ArPSrXvH+QQ+3pIB56PZp4rDKXC82TqoSOgk/bxQI0CyOrdJeP47BfRLT3/r6N8P8mGQ
         svFKNMCOaDhAsXAXnyCHzRGThyg80YNjFY3FTjBUGiww3XD/gPcAJUNW02YXLrZDJTLq
         H5QcUI2xUQQc00y+FAjQTgyvFF+w6INfQU9QvADfV1shuWZH8m2zFSdi5Ffl/bIJFd3G
         ajUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PuJsZuj1KUOMVGQQRhz0AFKXCZlP3B+1wIYCZL517JE=;
        b=BzWFUo9g4w9RuRTrA+fB7zDRlzSI27J/+Zndvo304Dcc11Fwn3Aw7pUaj6ARga0qaR
         liBKkE4XtfTPIrM5XlrS+6yIwwrm1Jd46i0MlcPL5loNqguAYvfg9aXnAW1SE1ZjAlHN
         GTnYvjZ2xCO9yJGZQP2HrbXyQZ0aZbYQtZuY5FJO4knO0Dc8agNqeYcYzj5viT4Vng43
         9IjHY7QOxj7yvExg406SAIHc0e/zKJYZtJypOSA9ve+cFXsVZlcJxdjpZEtJokWZ/BoB
         vVN1VUympxnDZ11PSHDs+QXTP7i7c1ZcqvNbB8yh0wFFycnq4rysNGjnz+pQYo+EuyXl
         5DTw==
X-Gm-Message-State: APjAAAXi2e6ZhydpPQ3PyPHhQKPjE+iLvKkjTxXSeJEPOImykMtErsTt
        2FlDNd667XOsjBjnoZHvdb1vaA==
X-Google-Smtp-Source: APXvYqzAW6Q0++cUvoybZHEwV9r2VSNbCDa16Za0w8q4ikzgY+C4BOvsm3+QLu65fyNn/kNZWY9e+w==
X-Received: by 2002:a05:6a00:10:: with SMTP id h16mr26090193pfk.27.1574535026248;
        Sat, 23 Nov 2019 10:50:26 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id z10sm2447882pfr.139.2019.11.23.10.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 10:50:26 -0800 (PST)
Date:   Sat, 23 Nov 2019 10:50:21 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: remove phy_ethtool_sset()
Message-ID: <20191123105021.2a7b1fb9@cakuba.netronome.com>
In-Reply-To: <E1iY8BQ-00066m-TG@rmk-PC.armlinux.org.uk>
References: <E1iY8BQ-00066m-TG@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 12:37:08 +0000, Russell King wrote:
> There are no users of phy_ethtool_sset() in the kernel anymore, and
> as of 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
> supported from u32 to link mode"), the implementation is slightly
> buggy - it doesn't correctly check the masked advertising mask as it
> used to.
> 
> Remove it, and update the phy documentation to refer to its replacement
> function.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you!
