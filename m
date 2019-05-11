Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E69631A823
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfEKOqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 10:46:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42066 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfEKOqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 10:46:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so10682881wrb.9;
        Sat, 11 May 2019 07:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:in-reply-to
         :references:user-agent:content-transfer-encoding;
        bh=VIuUNR7wCJcqoGqSy/xt5oOP5q6nBpghSO+lnkhhWsQ=;
        b=DQRi45YY6oRQsy8ZdNDoBw7ossZ87WmFKahL/iiowA97O0nP0Zl7Cv1t4pLMDeBHQl
         X/+lqy7JAuJXhuRsmSxx2nIUgwhgf8Y9Fe3fCFqvcNUpXgSb+Q0Dz8MNnLdg+GMX3IwL
         uGUnDvAhrkiZi0083IWTvQfOQKrurcRp1F9AKLCpaWSyLt/0lshseHPNQYstok7vtC4D
         pt9XVS5TyeaDs8eVAfZWVKyYpHNFZ5nIaeD+CWYXopRvwa07U2svHEMzgK5u7xEgkt7M
         BiEchfmEPkFL+7gLKxq/bLN/tp8VUyXFiGFdBXhvOI8oEDnej4A0MOeOW12HF3E7Yjt1
         LDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :in-reply-to:references:user-agent:content-transfer-encoding;
        bh=VIuUNR7wCJcqoGqSy/xt5oOP5q6nBpghSO+lnkhhWsQ=;
        b=ThKza+CaUpXZRYRVOA2KnOllaso+B6xyj0KEagBa1BQMXQdMsaLcAsLeu0zdqd3umA
         5l5/mK/Rcu+xgQP79SUwo6vm7B6gdoIm21jklVt4RqxWVJcZA0HhCoJoZnrWC1LY+U3e
         XlJOmghcxqzIcRiSN0e121G7E5A6ZYYHYw5WkuEedr9DBxEOFK5XQd6+Y7aRAqiseT28
         i/LXfG2LofzasH0X1TpfR+qyAYVvaHHJ3vNSuPI9p7Hx3Gm+DtSidV9uSbM/Za5sNvE+
         HmrqNAW8GXCvGu8OfoPOMAM/mRs7ADcshgXHJE/8U8UJX8wAR/MpbPnmv3RDA954hgQe
         lQIg==
X-Gm-Message-State: APjAAAUfhBM5Iv+nhPaU41UFfsN7GkYJAc1USw6W7XNd+SRz6GMS6LNR
        75xLgthU3oJABlQaYLejMrA=
X-Google-Smtp-Source: APXvYqy+THvtUdLSbZoMctGP/fJeh4rdnhq5Xh4MHlSBCpuHV+PFy/MDWPpDj9c7U0zETLLE4V87Vg==
X-Received: by 2002:a5d:49c1:: with SMTP id t1mr11275306wrs.247.1557586003143;
        Sat, 11 May 2019 07:46:43 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id l14sm4460987wrt.57.2019.05.11.07.46.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 11 May 2019 07:46:42 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Date:   Sat, 11 May 2019 16:46:40 +0200
MIME-Version: 1.0
Message-ID: <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
In-Reply-To: <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
> On 10.05.2019 17:05, Vicente Bergas wrote:
>> Hello,
>> there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
>> pointer dereference.
>> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
>>  net: phy: realtek: Add rtl8211e rx/tx delays config ...
> The page operation callbacks are missing in the RTL8211E driver.
> I just submitted a fix adding these callbacks to few Realtek PHY drivers
> including RTl8211E. This should fix the issue.

Hello Heiner,
just tried your patch and indeed the NPE is gone. But still no network...
The MAC <-> PHY link was working before, so, maybe the rgmii delays are not
correctly configured.
With this change it is back to working:
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -300,7 +300,6 @@
 =09}, {
 =09=09PHY_ID_MATCH_EXACT(0x001cc915),
 =09=09.name=09=09=3D "RTL8211E Gigabit Ethernet",
-=09=09.config_init=09=3D &rtl8211e_config_init,
 =09=09.ack_interrupt=09=3D &rtl821x_ack_interrupt,
 =09=09.config_intr=09=3D &rtl8211e_config_intr,
 =09=09.suspend=09=3D genphy_suspend,
That is basically reverting the patch.

Regards,
  Vicen=C3=A7.

> Nevertheless your proposed patch looks good to me, just one small change
> would be needed and it should be splitted.
>
> The change to phy-core I would consider a fix and it should be fine to
> submit it to net (net-next is closed currently).
>
> Adding the warning to the Realtek driver is fine, but this would be
> something for net-next once it's open again.
>
>> Regards,
>>  Vicen=C3=A7.
>>=20
> Heiner
>
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -648,11 +648,17 @@
>>=20
>> static int __phy_read_page(struct phy_device *phydev)
>> { ...
>
> Here phydev_warn() should be used.
>
>> +        return 0;
>> +    }
>>=20
>>     ret =3D phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
>>     if (ret)

