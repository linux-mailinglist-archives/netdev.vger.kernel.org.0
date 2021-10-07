Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34484258F7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbhJGRL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242922AbhJGRLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 13:11:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AE8C061570;
        Thu,  7 Oct 2021 10:09:30 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id v18so25977046edc.11;
        Thu, 07 Oct 2021 10:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lw3cNIiYL8m9zTvwAVZqBbOLR1nsCKzpoCkmdMBkxt8=;
        b=ol2T7R9i5EvBZp6YhOk9/MvviHE5+oJBDqhWDksiyg3yBZf2ovx7OkgTjIWQwEoBno
         CBtLkuHei295ACTzUV76IKRgVVQNtTu1tOnR/Ufgxwoyoe0AXqnOTKa+RI+qcc/jFvCe
         giIN+qWXwIKyWkG1aH0QdDO5yDP+W7D08VODkKRGnCYqngvJwj3LbyHKlcUGFNOoPJHP
         il2FdZgqKu/x6AIL8UwhxOxdnZXjYHodb3glnn/48BZuJsC4DLM7+NTVlzQwnuhoyBCy
         3y+0zybivE4VTQtS/SuDv2EIguoJAYS0CGH+RdNI1S8TqsAEza9Ein+0nAfOs1B37B+4
         xNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lw3cNIiYL8m9zTvwAVZqBbOLR1nsCKzpoCkmdMBkxt8=;
        b=VGgSFAgG8yqlW9Ngk5rCSWH6zqioc77gVn4mpedUOSvnixpM/nkzOxraiFghltBHsy
         KHRS/PHe5AlaGRKxvLcQ+IunPmnKU4k37dCGeglHBPWNF/90PRCOpgxP/Q92dWdGUmfi
         fUXfIuETkf9Ln1XgAgzkbXa63/RrnRbLl0H38d5xXfMeIESd4SUt0ISjyTqJcyRE3Yuj
         ZHWxHRvPNicuvZHrEyRZynkp0G015xLxYGyn7uyVcUBJH0z0urAIi1xXNQKaSXAxLIbp
         J10KAX6CPnsGKhYjt2QdrI0ZvshutWmvjpuxUCXodgARPJ+WzJaPBCOzNfb5URZuKywM
         wkKQ==
X-Gm-Message-State: AOAM531A8mt1kMNne12h3ji4Y2uU7FEVIldQJfc2m4WgxXKiOiqRT/LO
        r39F2uBmzhwBP6Sq5Df/RhE=
X-Google-Smtp-Source: ABdhPJxTFcWHWLhjC0TMoJrRtwSoQGs6f9VSzDYWqDaZEnpY21lDYElhSZhp5W98p+FNrd66OyYuOA==
X-Received: by 2002:a17:906:5808:: with SMTP id m8mr7099192ejq.195.1633626569090;
        Thu, 07 Oct 2021 10:09:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id ee13sm11477edb.14.2021.10.07.10.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:09:28 -0700 (PDT)
Date:   Thu, 7 Oct 2021 19:09:26 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 06/13] Documentation: devicetree: net: dsa:
 qca8k: document rgmii_1_8v bindings
Message-ID: <YV8pxsCeSbN+1utP@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-7-ansuelsmth@gmail.com>
 <YV46wJYlJZHAZLyD@lunn.ch>
 <YV71TCksnbixsYI0@Ansuel-xps.localdomain>
 <YV8kjnX2TKgESC30@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV8kjnX2TKgESC30@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:47:10PM +0200, Andrew Lunn wrote:
> > Only some device require this, with these bit at 0, the internal
> > regulator provide 1.5v. It's not really a on/off but a toggle of the
> > different operating voltage. Some device require this and some doesn't.
> 
> Can you provide a list of devices which require it?
> 
>     Andrew

one bcm device the cisco meraki mx65 doesn't have them set.
no qca8327 device have them used.

device with qca,rgmii0-1-8v
netgear r7500v2
Askey RT4230W REV6

device with qca,rgmii56-1-8v
NEC Platforms Aterm WG2600HP3
TP-Link Talon AD7200
Qualcomm Technologies, Inc. IPQ8064/AP-148
AP-161
netgear d7800
dev board DB149
Linksys EA8500 WiFi Router
Linksys EA7500 V1 WiFi Router
ASRock G10
Netgear r7500
TP-Link Archer VR2600v
NEC Aterm WG2600HP
Compex WPQ864
Buffalo WXR-2533DHP

device with both enabled:
ZyXEL NBG6817
Netgear r7800

Here is the list I could have missed some user on the ath79 target but I
hope I made a point on how random this is and that we need dedicated
binding for this. Thanks for the review anyway.

-- 
	Ansuel
