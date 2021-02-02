Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE1930CD1A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhBBUa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbhBBU34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:29:56 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E486C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 12:29:16 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id j12so15122444pfj.12
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 12:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PHArYdOc7ktm2pPPAkiUUKEoN0eMEZ/R7cifHxfHrpY=;
        b=PqFP5GD4SxjXyoY55jBlwcA5YSfJbyBCIdZiLLoSEQF6Y8jGINAe8haiKhOOeFoIig
         EWBW5mEdSNP/KFsJu3XQnSLOoplCuUEa0LP+0IMfMfRkegTL5mi6xnveEZesAEy9jWee
         8gMDS7WIdAlazirzoJWmGMGMGd4/3F8tjcVCib/3mVKDwl7mIIW3BbsCbG3+9+9ZCJ6l
         /AGLyKeVfk0ZQw8FzGBx4x3JZXzy8zcDgt5RGXrA0TDoDWdtbc+xtXnR+xUFFSUU2l1f
         L67Z+Lj5hEC1mNoD7poqPF6hkdD4swN5uzQ0kOW5qiSqTHHe/AcwNj5EDP3g0FMAerwt
         VwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PHArYdOc7ktm2pPPAkiUUKEoN0eMEZ/R7cifHxfHrpY=;
        b=KMGJYp1mDTy1E0wwKlKMokdPNzSVUENRxUHEpzpnX01COwNI6sJCWxgbIyx+bHwTAN
         8/Lf6IJhhgeGQKaPPshfTi3EVRXJfx0Gblvqd3QDetw2PRoRBKvmmMW5TfFh6geRir29
         QtdS1Dxg9QC6TfjUH5vGc2stTNTjhh+I1Xht+GBYsf7a7N2KW/RhK/cEzLzt7BRU/7fl
         4uNRXJovN6ga5JmBZc9nifPbLjvrfz+OzV4IRJjCeM3AxcZ0piHGkvf7j2mblqjLe2Ml
         /pqu63mZdla3b6Tpw3J3MVHgLSSrFrgXCn/EJquedNzMdxFKR0NvgafC5B5y8weAZ2uS
         vEGA==
X-Gm-Message-State: AOAM531hx9mbWGYt8OX2R42GVlUkg2I05CvpCsaXPbFg2tPfYnAjt3g8
        uenIdNkm/VnjPBLnuRDoC4vIM6OEcs8=
X-Google-Smtp-Source: ABdhPJyIFrB79PUsbmvtcvBy92mnLRHTIzW6UeVaW/TI4t0VNEXFV60qwdWXrqlt3EVO1xGEEdKEoA==
X-Received: by 2002:a63:a401:: with SMTP id c1mr23990765pgf.60.1612297755209;
        Tue, 02 Feb 2021 12:29:15 -0800 (PST)
Received: from [10.67.49.228] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u3sm24285448pfm.144.2021.02.02.12.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:29:14 -0800 (PST)
Subject: Re: About PHY_INTERFACE_MODE_REVMII
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20210201214515.cx6ivvme2tlquge2@skbuf>
 <5a4d7b45-b50c-f735-b414-140eb68bc745@gmail.com>
 <20210202005306.k7fhc4hhwbjxqbsr@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <9802cd3e-dd8f-9006-cbaf-127aeab19b05@gmail.com>
Date:   Tue, 2 Feb 2021 12:29:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202005306.k7fhc4hhwbjxqbsr@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/21 4:53 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> Thanks for the quick answer!
> 
> On Mon, Feb 01, 2021 at 04:26:36PM -0800, Florian Fainelli wrote:
>> It depends on the level of control that you have and expect more on that
>> below.
> 
>> That is true if we consider that you can use an electrical connection
>> other than MII, which was the flaw in the reasoning leading to introduce
>> the above commit. If you took the name reverse MII literally like I did,
>> you would not think it would apply to anything but MII and maybe reduced
>> MII, but not GMII or RGMII. More on that below.
> 
>> I don't believe I ever saw a system that used reverse MII and yet did
>> not use either plain MII as far as the electrical connections went. That
>> does not mean you could not electrically connect these two systems using
>> RMII, GMII or something else. With RGMII, I don't see the point in using
>> a RevMII block especially as far as clocking goes, both link partners
>> can have their own local clock and just do clock recovery upon receive.
>>
>> When this commit was done, the only use case that had to be supported
>> was the case of two Ethernet MACs (one a video decoder, the other a
>> cable modem) connected over a MII electrical connection and we could not
>> change the cable modem side, so we act to make ourselves "look like" a
>> PHY which the hardware supported. Back then the GENET driver was just
>> getting a facelift to use PHYLIB and so it still used a fixed-link plus
>> phy-mode = "rev-mii" to get that mode to work which was probably too big
>> of a shortcut in addition to the flaw in the reasoning about what RevMII
>> really was.
>>
>> If you would like to deprecate/warn when using PHY_INTERFACE_MODE_REVMII
>> value and come up with a better way to represent such links, no issues
>> with me, it looks like we have a few in tree users to convert.
> 
> Well, everything depends on whether a formal specification of RevMII
> exists or not. If you're sure that all users of PHY_INTERFACE_MODE_REVMII
> actually use the 8-bit wide parallel data interface that runs at 25 MHz
> and 100 Mbps ("that" MII), just that they operate in MII PHY mode instead
> of MII MAC, then I can work with that, no reason to deprecate it.

I just checked with the designer of the GENET controller and he
indicated that there is no known specification to date for Reverse MII.

According to him this is really just specific to MII because for every
other electrical mode defined there after: Reduced MII, GMII or RGMII
you can either share the same reference clock (reduced MII) or you can
recover the clock from the transmitted data.

> 
> The problem is that I saw no online reference of RevMII + RMII = RevRMII,
> which would make just as much sense as RevMII. And as I said, RGMII does
> support in-band signaling, it's just probably too obscure to see it in
> the wild or rely on it. RGMII without in-band signaling has no reason to
> differentiate between MAC and PHY role, but taking the inband signaling
> into account it does. So RevRGMII might be a thing too.
> 
> For example, the sja1105 supports MII MAC, MII PHY, RMII MAC, RMII PHY
> modes. But it doesn't export a clause 22 virtual PHY register map to
> neither end of the link - it doesn't have any MDIO connection at all.
> Does the sja1105 support RevMII or does it not? If RevMII means MII PHY
> and the clause 22 interface is just optional (like it is for normal MII,
> RMII, RGMII which can operate in fixed-link too), then I'd say yes,
> sja1105 supports RevMII. But if RevMII is _defined_ by that standardized
> clause 22 interface, then no it doesn't.
> 
> In the DSA driver, I created some custom device tree bindings to solve
> the situation where you'd have two sja1105 devices connected MAC to MAC
> using RMII or MII: sja1105,role-mac and sja1105,role-phy. There are no
> in-tree users of these DT properties, so depending on how this
> conversation goes, I might just go ahead and do the other thing: say
> that RevRMII exists and the clause 22 PHY registers are optional, add
> PHY_INTERFACE_MODE_REVRMII, and declare that sja1105 supports
> PHY_INTERFACE_MODE_REVMII which is the equivalent of what is currently
> done with PHY_INTERFACE_MODE_MII + sja1105,role-phy, and
> PHY_INTERFACE_MODE_REVRMII.
> 
> Having a separate PHY interface mode for RevRMII would solve the situation
> where you have two instances of the same driver at the two ends of the
> same link, seeing the same PHY registers, but nonetheless needing to
> configure themselves in different modes and not having what to base that
> decision on. What do you think?

Agreed, at least it is consistent with the existing
PHY_INTERFACE_MODE_REVMII and the presence/absence of a fixed-link would
tell us whether a C22 compatible interface exists... works for me.
-- 
Florian
