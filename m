Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB3D909D7
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfHPU7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:59:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45242 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfHPU7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:59:39 -0400
Received: by mail-wr1-f68.google.com with SMTP id q12so2721382wrj.12;
        Fri, 16 Aug 2019 13:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fF23+eeI8IwqTgiv4la+N5iJcg94TGRZOaJt6jU0zYo=;
        b=UqAgh1kdtKJ99eTg1a0x/izcunJ++rokRIH2L1KbGWWMFK/9a0OMSfu7C8oSNEI45V
         sCc0zBqLNk3yhtcbG+fN7QRCZvzjMcIBXYKouGYMWpwaDVZogEI76BUzyUkckvFD2Ho3
         ZSnMWCr9ye+c6MDPS4HVQO1q0u/G5UmPqvznPI4lj4l0KHAdzQ2kuEbauBsirUvGDVpg
         Zgj8lksCC2+cI+CCcs7iXhKA7po5lt/D0GPoIoG7vFaCJvIlA7XAhVP2hv4cVseDqMYu
         bZaifm20rPtUK1ydAOn88TBi9bhgcyJShe83IcvUOD13JWloz39zqZMeUaxyNRINm3pW
         h/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fF23+eeI8IwqTgiv4la+N5iJcg94TGRZOaJt6jU0zYo=;
        b=KU73MGG17jmyBrlykYntpdxMDAXxMORDk7DEKkPKXy1oBgslMHKqUeYT+Y8yjE6xsH
         LuLn6feI/aX05rUpRu2aZh/qlInEJfF3tqMjg8GTO6NHnjLbYoXBTYOfgBISTs7asDaP
         tOWqOuqUOcTd4jJBBberzHnc+kkSDXnv11VefpANQoyg2RwIH1+OHHKT1lv6BppAwIlm
         wfVVbEfTMXZtiX/0ekoOzvRnR39+M+E7ODnPo+xHAKFqDEWPto2U9M/tsDrFwLngxezh
         PxsR8bApzTuNw4hlCce4m71o9NF/ywKNrPseXjwVOc9K82NHHvoCkyIbtjtVM8boCka/
         OcAA==
X-Gm-Message-State: APjAAAXmskIKkpMQYwGYnrRziKmQqksKLCnis4j7fGlRYgK/lu1YweAj
        E+VMZZ6l6m/syQ6GrCEzaxRPeb0l
X-Google-Smtp-Source: APXvYqyc6ut71s8E9UUeQKX7vw5SXrA/4uOVU/fOnefl2URT4r2l3XtaA+gDA5Y2O5ZYEeC2HhCyRg==
X-Received: by 2002:adf:fd8b:: with SMTP id d11mr12233594wrr.300.1565989176963;
        Fri, 16 Aug 2019 13:59:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id s19sm5193349wrb.94.2019.08.16.13.59.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 13:59:36 -0700 (PDT)
Subject: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
To:     Christian Herber <christian.herber@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190815153209.21529-1-christian.herber@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
Date:   Fri, 16 Aug 2019 22:59:29 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815153209.21529-1-christian.herber@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 17:32, Christian Herber wrote:
> This patch adds basic support for BASE-T1 PHYs in the framework.
> BASE-T1 PHYs main area of application are automotive and industrial.
> BASE-T1 is standardized in IEEE 802.3, namely
> - IEEE 802.3bw: 100BASE-T1
> - IEEE 802.3bp 1000BASE-T1
> - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S
> 
> There are no products which contain BASE-T1 and consumer type PHYs like
> 1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BASE-T1
> PHYs with auto-negotiation.

Is this meant in a way that *currently* there are no PHY's combining Base-T1
with normal Base-T modes? Or are there reasons why this isn't possible in
general? I'm asking because we have PHY's combining copper and fiber, and e.g.
the mentioned Aquantia PHY that combines NBase-T with 1000Base-T2.

> 
> The intention of this patch is to make use of the existing Clause 45 functions.
> BASE-T1 adds some additional registers e.g. for aneg control, which follow a
> similiar register layout as the existing devices. The bits which are used in
> BASE-T1 specific registers are the same as in basic registers, thus the
> existing functions can be resued, with get_aneg_ctrl() selecting the correct
> register address.
> 
If Base-T1 can't be combined with other modes then at a first glance I see no
benefit in defining new registers e.g. for aneg control, and the standard ones
are unused. Why not using the standard registers? Can you shed some light on that?

Are the new registers internally shadowed to the standard location?
That's something I've seen on other PHY's: one register appears in different
places in different devices.

> The current version of ethtool has been prepared for 100/1000BASE-T1 and works
> with this patch. 10BASE-T1 needs to be added to ethtool.
> 
> Christian Herber (1):
>   Added BASE-T1 PHY support to PHY Subsystem
> 
>  drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
>  drivers/net/phy/phy-core.c   |   4 +-
>  include/uapi/linux/ethtool.h |   2 +
>  include/uapi/linux/mdio.h    |  21 +++++++
>  4 files changed, 129 insertions(+), 11 deletions(-)
> 

Heiner
