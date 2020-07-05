Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D29214FD3
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgGEVNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgGEVNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:13:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D91C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:13:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d10so14542117pls.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wp8wZGHJtRkkpDrGoBVTe9ywipVoOYesgfI6G6v97uw=;
        b=uuwxNIhyFPQylbnKXPw8pBz3oU4ldn+Yua8w/bu0aunKi9n+oY2FlLCZh+yJa5vMTB
         eV2f0CsVljdm8w5f3/Ov2KfNp0Zk9DjxfEFmRqRCgC2lWzm51f9kTNGexuCaeSme/0bR
         MYc+mEL0VhptvBAghFYUr9Yavj0snyHLH5Cc5qyzRnYw9fXCeAq2xzLm1gU90AE4Pz2o
         TjEfZdEeXYV+0MFk6U6aje7Dc5dNbEDs9yGHGJcE84CgOrQuF+N+DLzY2N8YapaW7/q3
         /uU7TwXDGZxOmcTnt0EjQu2CWHonrWQASH78uLAYJWSBC+bEZ/WCWxw8o7DAh7UABsUq
         Yj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wp8wZGHJtRkkpDrGoBVTe9ywipVoOYesgfI6G6v97uw=;
        b=qvb9qWrY+FmBSBT0zR19M0zb6u4dkoRW04rjlx/AHcKqlf77GAnvrz3jJODJXhI/f0
         onX4vKEmunKhRnn0LxFCX0FM70SwpH7sVcJVDnqsh+db0KD6+gEBIheQWt3DXCYSv0uW
         mY2dzqlNEN8xfg6jOz90IYj1fVVaXRvi+wHSXTMe1RkNnOe8070ASSE5c+DzjDcupqqO
         20GOv6eAF7CWrcIc3F9nfC9R+OHVa0nu0HENFJbXcvhH3IU6GkxgcXCyGKMMokPyLNXY
         eQ8jhsGNeygxs6oVVgwnfGh05j6tzlljCqpcGEbdVC9RSvamY+IM7cw84YJp2+5o8wIP
         dhyw==
X-Gm-Message-State: AOAM533snNHaBl5EKk1RAtNAm2cQfBEawN1xIGhDcS4SSowoy6KVaBAb
        Lvy7K+g/V2mD8bcPQktgIkU=
X-Google-Smtp-Source: ABdhPJxk2i8ly6wt2M9tj06AuSEqYNue6ExWFIygVn3FcfsyBDFjkTI2UZ5ZDEef7CYdnfu+4KpC/A==
X-Received: by 2002:a17:90a:b98d:: with SMTP id q13mr22277355pjr.82.1593983603061;
        Sun, 05 Jul 2020 14:13:23 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id u8sm16239679pjn.24.2020.07.05.14.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:13:22 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 5/6] net: dsa: felix: delete
 .phylink_mac_an_restart code
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
References: <20200705161626.3797968-1-olteanv@gmail.com>
 <20200705161626.3797968-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <174ed683-f67d-f691-26de-6121d15097b8@gmail.com>
Date:   Sun, 5 Jul 2020 14:13:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705161626.3797968-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 9:16 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Phylink uses the .mac_an_restart method to offer the user an
> implementation of the "ethtool -r" behavior, when the media-side auto
> negotiation can be restarted by the local MAC PCS. This is the case for
> fiber modes 1000Base-X and 2500Base-X (IEEE clause 37) that don't have
> an Ethernet PHY connected locally, and the media is connected to the MAC
> PCS directly.
> 
> On the other hand, the Cisco SGMII and USXGMII standards also have an
> auto negotiation mechanism based on IEEE 802.3 clause 37 (their
> respective specs require a MAC PCS and a PHY PCS to implement the same
> state machine, which is described in IEEE 802.3 "Auto-Negotiation Figure
> 37-6"), so the ability to restart auto-negotiation is intrinsically
> symmetrical (the MAC PCS can do it too).
> 
> However, it appears that not all SGMII/USXGMII PHYs have logic to
> restart the MDI-side auto-negotiation process when they detect a
> transition of the SGMII link from data mode to configuration mode.
> Some do (VSC8234) and some don't (AR8033, MV88E1111). IEEE and/or Cisco
> specification wordings to not help to prove whether propagating the "AN
> restart" event from MII side ("mr_restart_an") to MDI side
> ("mr_restart_negotiation") is required behavior - neither of them
> specifies any mandatory interaction between the clause 37 AN state
> machine from Figure 37-6 and the clause 28 AN state machine from Figure
> 28-18.
> 
> Therefore, even if a certain behavior could be proven as being required,
> real-life SGMII/USXGMII PHYs are inconsistent enough that a clause 37 AN
> restart cannot be used by phylink to reliably trigger a media-side
> renegotiation, when the user requests it via ethtool.
> 
> The only remaining use that the .mac_an_restart callback might possibly
> have, given what we know now, is to implement some silicon quirks, but
> so far that has proven to not be necessary.
> 
> So remove this code for now, since it never gets called and we don't
> foresee any circumstance in which it might be, either.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
