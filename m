Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BD12BD16
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 04:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfE1CAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 22:00:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37999 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfE1CAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 22:00:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id b76so10438039pfb.5
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 19:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ifc1bKAJpfYurItnA5BxuHGo5mRSiyEDIrUor4MSMBE=;
        b=Hm18nU3q0zhyBQZfJGa5ftSxei2xnghI2xir+idG9TVjuXCABszmKZaI3Ep9aitgas
         B+P6s2p+J/prdV8KUOuBz57scos8KV8ok64L3Iv5rdHUb5GFfClqhVSppkPBn4adjwkR
         dtSSj0fqTKwusw+XpecCG1eXtSIUKpOW1v2vRbuRrogJ+C6SQs/az6P5P3pcGIwswn3G
         /t+WwlAWbohSUc2DZbW+Xl06kwsaR4h9gJrPl+qKMftLrF9HRhg7DNGC3UOwZ7rSMx0R
         mG0tuJRbNHe568uooBGhaxj7Va46iGJbns3cu1P18/FlSd3Q3nB4V+1Mzo0amzRmkXLL
         aGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ifc1bKAJpfYurItnA5BxuHGo5mRSiyEDIrUor4MSMBE=;
        b=McjfIvE5IgIggQslCb7+xzVoaweB4yiUdw/nu21HxIOBqKVT0v8cN74bnDGe+HKBFQ
         CZlujXjdpcSXCmD1pbEGl1SnKWP5Efts2GrWdUT4C7u2dlJVW8vJFQCSvJSpI4qmgq30
         st6m8tUH+9o7H7CKaebBYke5Crufe8IuGjBaR2LAu28lf1bjHN2IRcYd1JaTeqr7I6i4
         sTPpB10kCr49NZpnVWW1bQZnIkDFKc4S64qUHZxpMZi2CY4RKRJHvZ1d7olFhrAl8lkF
         NredbZ30+SJ8QfkdfE4f1cj891W38CaW5NXJou49BWigaNuz9MJ378Uwk+uSiw8jcALv
         F2lg==
X-Gm-Message-State: APjAAAXRzPqkl3DRjfENiM8KZ1/+FJPIRb14YXrdXpGoSFaKKNW/7RvG
        sQnENgKer9fqVZXzj9Q4WC6H3tDZ
X-Google-Smtp-Source: APXvYqxXWF02YUZCSP4ZJm9fZiYz91ndX67Gmu6MdIVNDyVIEiae843Xe7fvBvrDxc8MtEf4ZG2lkg==
X-Received: by 2002:a17:90a:3442:: with SMTP id o60mr2196989pjb.5.1559008801768;
        Mon, 27 May 2019 19:00:01 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id u20sm13294484pfm.145.2019.05.27.19.00.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 19:00:01 -0700 (PDT)
Subject: Re: [PATCH 04/11] net: phy: Add phy_standalone sysfs entry
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org
References: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
 <1558992127-26008-5-git-send-email-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <1efa9cc1-b41d-94f7-7e48-ed92230a9ba6@gmail.com>
Date:   Mon, 27 May 2019 19:00:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1558992127-26008-5-git-send-email-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 2:22 PM, Ioana Ciornei wrote:
> Export a phy_standalone device attribute that is meant to give the
> indication that this PHY lacks an attached_dev and its corresponding
> sysfs link. The attribute will be created only when the
> phy_attach_direct() function will be called with a NULL net_device.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

If you update Documentation/ABI/testing/sysfs-class-net-phydev, this is:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

I will take care of removing sysfs-bus-mdio which duplicates that
information.
-- 
Florian
