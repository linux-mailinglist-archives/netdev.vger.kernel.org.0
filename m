Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B42F1A837
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 17:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfEKPQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 11:16:39 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34625 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfEKPQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 11:16:39 -0400
Received: by mail-wm1-f65.google.com with SMTP id m20so8313923wmg.1;
        Sat, 11 May 2019 08:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:in-reply-to
         :references:user-agent:content-transfer-encoding;
        bh=wFMYEzPERJaRGESj5LsebNjbMIR+LYDP6TQY/7qUt1k=;
        b=QH3xpGS/FC3Glwdy4PxwvrlNE/OOrtbTRsqDZPOVLjOf2XYWTkA9L1m/t7/phRjC10
         WIAFCHwyVEBhutkyqvdKn9O/7uBZyVmNqYg8VhK+ouBvK4t8XLJTIaGIgSEv4O+aeDGx
         2tyn5fx4LXH+WVVuz3b3+Zy00odPFS8/Uik3K4W4s5fJxhc6bUs94NQ5674ls/JcwuWs
         Vb2KYhNLAUzs7HPHjkRU5MvMYqiIrXCa03cG0PCJiI10R4/8hcbqK5uzvPhFEyh8/o7d
         UHbetSOUvvzwQfwvjYZb6WFtMk2wBCuaa1G1hKaUu4N8x4s8naFrNff7Mhyajyj06SpJ
         s3IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :in-reply-to:references:user-agent:content-transfer-encoding;
        bh=wFMYEzPERJaRGESj5LsebNjbMIR+LYDP6TQY/7qUt1k=;
        b=LwUn51yAU7jXLK7v3xo4d21YOrtuBUxGPpyL20u0x0z0QgfJ9rkny8TvKsFdb8Nxe0
         w0PV0LH+IvKSOByJQ4R6l81CBq2mzwaiSgKLhkgWx4Xw4UpV6OWPLjhvJFv4OmzrPbz/
         TFEFw+9Bww+fMawWP5O77yndD8XqMtsWwzJcQhChsjIbgOQwI8xrNYP3B7txk7k3TNtp
         eODJM7tWlzGp1GXMuc2IyW6H1TuQNiXWOtkuszIQM9aqHA8l96zFdQ03rHTvxtyiSh7D
         oLPvAPtpIJ85MkLr0JbaJyyjNjpKs8C7aH7ugTK/fibHcuccF9E66KMsUqm64rW1G6Vu
         7+Ug==
X-Gm-Message-State: APjAAAXxBDYeXVsOshvvTqYvK7Cf+VS/QyvTfls5NHuKGG4a0ThX9TpA
        NufTYyYplmeKftOQq/ufwdQ=
X-Google-Smtp-Source: APXvYqyaVLyDithQcEFQDF+WRr3Bm+Yp8VjpS2kmPamb/QYWvgzPlfEWQVWp1YarmsFyIIqEC6zh+A==
X-Received: by 2002:a05:600c:506:: with SMTP id i6mr10804418wmc.3.1557587796941;
        Sat, 11 May 2019 08:16:36 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id c130sm16622135wmf.47.2019.05.11.08.16.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 11 May 2019 08:16:36 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Date:   Sat, 11 May 2019 17:16:35 +0200
MIME-Version: 1.0
Message-ID: <fce7258a-b033-4d39-8ad1-4e56917166c5@gmail.com>
In-Reply-To: <20190511150819.GF4889@lunn.ch>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <20190511150819.GF4889@lunn.ch>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, May 11, 2019 5:08:19 PM CEST, Andrew Lunn wrote:
> On Sat, May 11, 2019 at 04:46:40PM +0200, Vicente Bergas wrote:
>> On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
>>> On 10.05.2019 17:05, Vicente Bergas wrote:
>>>> Hello,
>>>> there is a regression on linux v5.1-9573-gb970afcfcabd with=20
>>>> a kernel null
>>>> pointer dereference.
>>>> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
>>>> net: phy: realtek: Add rtl8211e rx/tx delays config ...
>>> The page operation callbacks are missing in the RTL8211E driver.
>>> I just submitted a fix adding these callbacks to few Realtek PHY drivers
>>> including RTl8211E. This should fix the issue.
>>=20
>> Hello Heiner,
>> just tried your patch and indeed the NPE is gone. But still no network...
>> The MAC <-> PHY link was working before, so, maybe the rgmii=20
>> delays are not
>> correctly configured.
>
> Hi Vicente
>
> What phy-mode do you have in device tree? Have you tried the others?
>
> rmgii
> rmgii-id
> rmgii-rxid
> rmgii-txid
>
> =09Andrew

Hi Andrew,
it is configured as in the vanilla kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/=
arm64/boot/dts/rockchip/rk3399-sapphire.dtsi#n191
,that is,
phy-mode =3D "rgmii";
There are also these configuration items:
tx_delay =3D <0x28>;
rx_delay =3D <0x11>;

Instead of going the trial-and-error way, please, can you suggest a
probably good configuration?

Thanks,
  Vicen=C3=A7.

