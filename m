Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D76428162
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhJJMwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbhJJMwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:52:04 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D60C061570;
        Sun, 10 Oct 2021 05:50:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w14so4259279edv.11;
        Sun, 10 Oct 2021 05:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xj8Z6kAQ15miY97+ii3p/Q9Q3qKv+e77ckapX27m/m8=;
        b=UvQN6zEWREg5fnj6SQak0csvdV4309eyM8mTKmzmkL/gsIIyMh8kQL/lEkVF2typYE
         7YvMGY94pU27HsKbmNxfvteYDsTxA+Y8z5uwioUrp1e3NkqQQGbCeKqKqvsFwN+k52b4
         hKBGZ6O0Ssq8CQ9pGcEyy6TLc3uTxDuvzS0A5IiiOrWh/Bb5LZvhHR85h/APEAVWF2Qd
         duoaTIGNhclB+vMooQ1qz4/XmsQgU7f3LCZA1pm09GsPRIymAlW3+t81Nrok6BNXGwMY
         IwJI6qmov9UXA/2UdbDF1VrcvIodF9mPtBwkVL2l7j7rTAiw0eitKlCInR0Hu8JSikhi
         Caww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xj8Z6kAQ15miY97+ii3p/Q9Q3qKv+e77ckapX27m/m8=;
        b=tbCJzt6rnZr/rZvE5p2BDz0NL+0VZEwxYb69tGVgjOocTkQ4WoR7NLRYb5DcrR8IzD
         TvpZBzSdqpdrnIR6rUR/ktmqzqUwRBLbBg0HNrh1yxXE+F5xA9qUgVsP2AdY6Tsu/8Hi
         IHRyW/l/ZiltHE36Fs46V1ba9sTuxdMrhPbV7OjzTtcT62ePcmxMqhCMAFNmNzeKF09b
         XI5HXCWwa3W7AlxAb7+7RQKfrk/4OEherdw1MAGB/zSFaw9aviNmvHxF4f4O0avsIlPB
         E5kZAOH2zQnxsRJoP6kqJbuAgWCDER28MVMqCVU0+PbqNq5USLrQAVu+WOK90yzDunSZ
         S1zA==
X-Gm-Message-State: AOAM533SdHN36mhgAH432Mq/WIZG7prt/BgJg0xBKCneze7JMp0FTlKO
        DEl6EeQFreX6k+6THKyZtrQ=
X-Google-Smtp-Source: ABdhPJyl1eOWHKjuIgm6OorOTVxPUZtxKZ0/g3Mc7EaM+j1Al1yqftEAYF8XxLGGZO6ybzzFtWoOPg==
X-Received: by 2002:a50:9d42:: with SMTP id j2mr33053427edk.7.1633870204494;
        Sun, 10 Oct 2021 05:50:04 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id z4sm2626707edd.46.2021.10.10.05.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:50:04 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:50:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v4 02/13] net: dsa: qca8k: add support for sgmii
 falling edge
Message-ID: <20211010125002.wtjkxeo2hndajrub@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-3-ansuelsmth@gmail.com>
 <20211010120526.xzd7m3ug4plvwcjw@skbuf>
 <YWLYGJjmjo/aHlae@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWLYGJjmjo/aHlae@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 02:10:00PM +0200, Ansuel Smith wrote:
> > I would strongly recommend that you stop accessing dp->dn and add your
> > own device tree parsing function during probe time. It is also a runtime
> > invariant, there is no reason to read the device tree during each mac_config.
> >
>
> What would be the correct way to pass all these data? Put all of them in
> qca8k_priv? Do we have a cleaner solution?

Put in driver private structures, or configure at probe time and never
modify touch again, anything goes.
