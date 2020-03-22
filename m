Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E3518E630
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgCVDDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:03:07 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46990 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgCVDDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:03:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id r3so4295864pls.13;
        Sat, 21 Mar 2020 20:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WMhY0cWXzJNSFE+R5ZlYq8GhanMI8L49EmbBfXYaPc8=;
        b=t/KT82Ga7Yn3Ujoty56BWTvXREr8JeoHrRRp0wr96qCQfuukSu6qUfuN/qu7BD0NlU
         yielUgMlLLPY5gfg1Lm3E6IVvpx3DpdV0JzIDQ2xJIRX+Wo9rXJlKL/aoMezchjLyuQH
         zs1fIVg2qw5nhX7voYVx4UM0ns8zUKsYf+2CF2y/syPLx9TDf55C/3HGPXlawY3fk0E1
         8+hy72wJHxbVlE1afRfA4m+B7Z3F99RpF/Q9DUutltJ3wljaPbkODrOvV6whOwKVQNMK
         z6ptX8bpuuio0P2rCK4KNvHX5YT47sS/PlgPKmCWEE0/qyRuBfTNjfYyaQOb3yqtTgcI
         6Idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WMhY0cWXzJNSFE+R5ZlYq8GhanMI8L49EmbBfXYaPc8=;
        b=lSvFG1RRk1672B3RuWSiBDQHKmMRxg5UHXYSRc8q49ZvUYpyhyx+iMXBuTtao6trOG
         orpDAKYWPEShB/8cCUbRr1Oz4Diw4wgjg/La9tWFq+6VqJvY2iOL4v3Yi+x5I18AEaOn
         waEKCyWMK4MSKMH8+z48ECZMxrHzj52VKPsCpwlIfGDNdy1Jq9mb4I5OryK+kSaM/aKj
         JHgszFK3yV2I2es9jnyv8OqmRejNnbEu5ctCFXNYOBRvnYFpkMnyEmHwYR8VdF1xRiJZ
         scLWPsuNSR+j2mRLd2J9+Nfb8u+Sy29lZW8YL8G+aP5d+r3fekgC2QB5C6F1e8TZn7ng
         3Ilg==
X-Gm-Message-State: ANhLgQ0t9hQUK7uBIj4DPgIt83RRLHpm+LAVFV4+3i2G3qzvpOW9zBsG
        d4n+T2PF5qcy+GHHtwtklnw=
X-Google-Smtp-Source: ADFU+vshITSurdtD2KIngwe4FgygSTH20ImwzSQ745/COUEW0AiScZmFJalbWz00XwlxWtc9zdvSqA==
X-Received: by 2002:a17:90a:25c6:: with SMTP id k64mr17610781pje.9.1584846186091;
        Sat, 21 Mar 2020 20:03:06 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id a19sm9733964pfk.110.2020.03.21.20.03.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 20:03:05 -0700 (PDT)
Date:   Sun, 22 Mar 2020 11:03:01 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, allison@lohutok.net, corbet@lwn.net,
        alexios.zavras@intel.com, broonie@kernel.org, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] introduce read_poll_timeout
Message-ID: <20200322030301.GA31541@nuc8i5>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
 <20200321165014.GD22639@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321165014.GD22639@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 05:50:14PM +0100, Andrew Lunn wrote:
> On Fri, Mar 20, 2020 at 09:34:24PM +0800, Dejin Zheng wrote:
> > This patch sets is introduce read_poll_timeout macro, it is an extension
> > of readx_poll_timeout macro. the accessor function op just supports only
> > one parameter in the readx_poll_timeout macro, but this macro can
> > supports multiple variable parameters for it. so functions like
> > phy_read(struct phy_device *phydev, u32 regnum) and
> > phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
> > use this poll timeout framework.
> > 
> > the first patch introduce read_poll_timeout macro, and the second patch
> > redefined readx_poll_timeout macro by read_poll_timeout(), and the other
> > patches are examples using read_poll_timeout macro.
> 
> You missed lan87xx_read_status(), tja11xx_check(), and mv3310_reset().
> 
> If you convert all these, your diffstat might look better.
> 
>    Andrew
Hi Andrew:

ok, Thanks for your reminder, I will do it.

BR,
Dejin

