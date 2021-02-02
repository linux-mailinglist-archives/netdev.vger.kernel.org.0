Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343C930B41D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhBBA1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhBBA1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:27:22 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FD2C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 16:26:42 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id s23so12369694pgh.11
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 16:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zvj4aYU0y0Jr2U0ONP7hvmfsczhs3+MnKcZwV/cnZdw=;
        b=nBic+2wNERUVxh4frW5hHdXZSE5Ed5BXva852fRGqSn4IWxee7J3HN6igQHkbbSjly
         pj5o9Hzb/pSXKDKFklPFcaQH+JPOHPASayCxRhrgWDu6EeL9N59zPQqcjMEs46yQZxhM
         r6HQHp3Ns6tm62de4Abh82qTpIBZiNuh1IOAUwBMYyw9dkuCCONA/R8swbUD0ZbZ3nns
         PKEXbZGux2uGHJI0EVuihKYVH2v74Hb0RRRFlqQ4iFEkONyUheIpXXGPpeGMRdsPoxRU
         z5txulPnUQIqv9owJI4BGK90jhOVKcFP34YKI1raUFWkSwTVJH1Z+7FkrW9jlr6fOUQZ
         PesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Zvj4aYU0y0Jr2U0ONP7hvmfsczhs3+MnKcZwV/cnZdw=;
        b=VvlWceU90erCuPXjkBtKK6ZXKWjzFQTx/HLg8sZsrw2amLwc6bOiSV10CNHSQF4bDM
         eWmU2Uk93e6pfdDJJXIWz34+2DnNJAPOaHpnpCZCm37vGxmM2Vuw5exFBC0b6bAtTJdw
         Zuit7N+cQuIcuK3gZkyvwhOLsf9NABSw+teFbGlb0ilzG2OMWzagxkVg/uWloe6895Lu
         7eB+r2Xt0WltmeR7tPcdqo+CQ1YVlQ+6g1czp5HlsKcReSZMCrXJE6dg8/BM0SnTm7Tl
         flu4C4dQPUM9dW0YaMOmtG4YvCNzLmoECS+yAkbvH6BKYaGCyQ8pu5Wq8nh+XnZdFKgc
         1GjA==
X-Gm-Message-State: AOAM531F2eqROjMkLOXCdRA4r19FdGWlJIr20pyzVKJobdrrRNfwmLad
        k33pH++lCmld7d5WkwqgofXjH5y53WM=
X-Google-Smtp-Source: ABdhPJyk/IIIRpTxoz85df1g1efKZSVygUAV3RhkhWUOpgig77CxqmyYy4ROzLdJyVhPgtU99nvzPg==
X-Received: by 2002:a63:5407:: with SMTP id i7mr19456240pgb.418.1612225600960;
        Mon, 01 Feb 2021 16:26:40 -0800 (PST)
Received: from [10.67.49.228] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y20sm9194223pfo.210.2021.02.01.16.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 16:26:40 -0800 (PST)
Subject: Re: About PHY_INTERFACE_MODE_REVMII
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20210201214515.cx6ivvme2tlquge2@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <5a4d7b45-b50c-f735-b414-140eb68bc745@gmail.com>
Date:   Mon, 1 Feb 2021 16:26:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210201214515.cx6ivvme2tlquge2@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 1:45 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> I was looking at
> 
>   commit 2cc70ba4cf5f97a7cf08063d2fae693d36b462eb
>   Author: Florian Fainelli <f.fainelli@gmail.com>
>   Date:   Tue May 28 04:07:21 2013 +0000
> 
>       phy: add reverse MII PHY connection type
> 
>       The PHY library currently does not know about the the reverse MII
>       connection type. Add it to the list of supported PHY modes and update
>       of_get_phy_mode() to support it and look for the string "rev-mii".
> 
>       Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>       Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> and I couldn't figure out its intended use from the drivers that do make
> use of it.
> 
> As far as I understand
> https://www.eetimes.com/reverse-media-independent-interface-revmii-block-architecture/#
> RevMII is a set of hardware state machines used to describe a MAC-to-MAC
> connection in a richer manner than a fixed-link would. You mostly get
> auto-negotiation via a minimal clause 28 state machine, which should
> help avoid mismatch of link modes. You also get the illusion of a clause
> 22 register map that should work with the genphy driver and give you
> link status based on (?!) the link partner toggling BMCR_ANRESTART, for
> the most part - which would allow you to catch a change in their link
> mode advertisement.
> 
> The thing is, RevMII as I understand it is simply the state machines for
> autoneg and the virtual MDIO interface. RevMII is not a data link
> protocol, is it? So why does PHY_INTERFACE_MODE_REVMII exist? Having
> RevMII for the MDIO link management doesn't mean you don't have MII, or
> RMII, or RGMII, or whatever, for the actual data link.
> 
> Another thing is, I think there's one fundamental thing that RevMII
> can't abstract away behind that genphy-compatible clause 22 register
> map. That is whether you're on the 'PHY' side of the RevMII block or on
> the 'MAC' side of it. I think mostly small embedded devices would
> implement a RevMII block in order to disguise themselves as real PHYs to
> whatever the real SoC that connects to them is. But the underlying data
> link is fundamentally asymmetrical any way you look at it. For example,
> in the legacy MII protocol, both TX_CLK and RX_CLK are driven by the PHY
> at 25 MHz. This means that two devices that use MII as a data link must
> be aware of their role as a MAC or as a PHY. Same thing with RMII, where
> the 50 MHz clock signals are either driven by the MAC or by an external
> oscillator (but not by the PHY).
> 
> The point is that if the system implementing the RevMII block (not the
> one connected over real MDIO to it) is running Linux, this creates an
> apparent paradox. The MAC driver will think it's connected to a PHY, but
> nonetheless, the MAC must operate in the role of a PHY. This is the
> description of a PHY-to-PHY setup, something which doesn't make sense.

It depends on the level of control that you have and expect more on that
below.

> I.e. the MAC driver supports RMII. If it's attached to an RMII PHY it
> should operate as a MAC, drive the 50 MHz clock. Except when that RMII
> PHY is actually a virtual RevMII PHY and we're on the local side of it,
> then everything is in reverse and we should actually not drive the 50
> MHz clock because we're the PHY. But if we're on the remote side of the
> RevMII PHY, things are again normal and we should do whatever a RMII MAC
> does, not what a RMII PHY does.
> 
> Consider the picture below.
> 
>  +--------------------------+                    +--------------------------+
>  |Linux    +----+------+----+           MDIO/MDC |-----------+      Linux   |
>  |box A    |Side|RevMII|Side|<-------------------|    MDIO   |      box B   |
>  |      +--| A  |block | B  |<-------------------|controller |              |
>  |      |  +----+------+----+                    |-----------+              |
>  |      |                   |                    |        |                 |
>  |   internal               |                    |     phy-handle           |
>  |    MDIO                  |Actual data link    |                          |
>  |      |            +------|<-------------------|------+                   |
>  |  phy-handle       | MAC  |<-------------------| MAC  |                   |
>  |                   |as PHY|------------------->|as MAC|                   |
>  |                   +------|------------------->|------+                   |
>  |                          |MII/RMII/RGMII/SGMII|                          |
>  +--------------------------+                    +--------------------------+
> 
> The RevMII block implemented by the hardware on Linux box A has two
> virtual register maps compatible with a clause 22 gigabit PHY, called
> side A and side B. Presumably same PHY ID is presented to both sides, so
> both box A and box B load the same PHY driver (let that be genphy).
> But the actual data link is RMII, which is asymmetric in roles (all MII
> protocols are asymmetric in roles to some degree, even RGMII which does
> support in-band signaling driven by the PHY, even SGMII where the same
> thing is true). So somebody must tell Linux box A to configure the MAC
> as a PHY, and Linux box B to configure the MAC as a MAC. Who tells them
> that? I thought PHY_INTERFACE_MODE_REVMII was supposed to help, but I
> just don't see how - the information about the underlying data link type
> is just lost.

That is true if we consider that you can use an electrical connection
other than MII, which was the flaw in the reasoning leading to introduce
the above commit. If you took the name reverse MII literally like I did,
you would not think it would apply to anything but MII and maybe reduced
MII, but not GMII or RGMII. More on that below.

> 
> Is it the case that the hardware on Linux box A is just supposed to hide
> that it's really using RGMII/RMII/MII with a PHY role as the actual data
> link, and just give that a pretty name "RevMII" aka "none of your business"?
> But again I don't believe that to be true, somebody still has to care at
> some point about protocol specific things, like RGMII delays, or
> clocking setup at 25 or 50 or 125 MHz depending on whether MII or RMII
> or RGMII is used, whether to generate inband signaling and wait for ACK,
> etc etc.

I don't believe I ever saw a system that used reverse MII and yet did
not use either plain MII as far as the electrical connections went. That
does not mean you could not electrically connect these two systems using
RMII, GMII or something else. With RGMII, I don't see the point in using
a RevMII block especially as far as clocking goes, both link partners
can have their own local clock and just do clock recovery upon receive.

When this commit was done, the only use case that had to be supported
was the case of two Ethernet MACs (one a video decoder, the other a
cable modem) connected over a MII electrical connection and we could not
change the cable modem side, so we act to make ourselves "look like" a
PHY which the hardware supported. Back then the GENET driver was just
getting a facelift to use PHYLIB and so it still used a fixed-link plus
phy-mode = "rev-mii" to get that mode to work which was probably too big
of a shortcut in addition to the flaw in the reasoning about what RevMII
really was.

If you would like to deprecate/warn when using PHY_INTERFACE_MODE_REVMII
value and come up with a better way to represent such links, no issues
with me, it looks like we have a few in tree users to convert.
-- 
Florian
