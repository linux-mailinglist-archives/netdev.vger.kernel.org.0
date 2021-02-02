Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACD930B454
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhBBAxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBBAxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:53:50 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91227C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 16:53:09 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id hs11so27314010ejc.1
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 16:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d/iAS7QB8gFJSHPCF/AJnAOZucDFyXJceXXzY89Q0Fo=;
        b=MVxdf1E9RSje8y16Z0+/OcAfRh/JnQP92Okb8BQ8rFxOn8cTFsu8SVudGRdlJYE0Jr
         CnHY2wNOBPlDBNITb02zGaulCv2llcNA/Nw3J+ztcR1do9/JxekKNa2J7r3P/ssj1Qzu
         528o/DBbw3tlykB1Hq7x2J+K9n3hnqP05mpn6oGC1m5TD9bt7TYJQchRbkiB7X6Cm3z+
         LLFMvU/94u+0lVaZm9PMkFHbfzeKbzqDdVcbmQqHgxwnNrM68DSCNQdoMI9p1ck90GON
         vYvSN93mmUpnOSfAiVEfkUFfdKQ61bo+AtjQA9jKIF/vmnTjFymvJMKjcf20k3pKlU/Y
         UrEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d/iAS7QB8gFJSHPCF/AJnAOZucDFyXJceXXzY89Q0Fo=;
        b=kpWTIoYgL+G6kudZltfLeesmG5Z/hV7tyQUfPXSVlb0+6eEG5u4I8BOhlEACI5EUke
         8T/MH/g0oywZgN6MRi44c/X9Dupbi2b1elJZnsyUorlWI2Qj9c0RuiNuFm8sW6NUGtyQ
         9/8ztpYyXUrXKzwCXD5dIQWPL67Mp7blf++jVsQahq9dwpJKx8+Y5zvGpXtV2lfXhpyM
         EBSi1zCWRfeyz6a+52/socqkRYWZolgr23a3zFBAvdxA05RyeHdDpPwLWEE8yiUYPaSy
         5cL66drSWXzwgDDtcfLYNchknWarrV+izzTWGg1y+Q1Kalhd/Py/21B3g4sT6UHqYIkS
         ae8w==
X-Gm-Message-State: AOAM531t3w4rZW07ogdEa67e2Gh5Mv2G0LGrtbL3xueZnoREGFiRAqPN
        QWqjd16BGfFI8KHiZSFNox5p1MyO8qs=
X-Google-Smtp-Source: ABdhPJwzR45NBpOi8D8VT3gsverGPAVMqs+D5doCVJsGC2gFjgWiAzTMwwYYf5JdneQK3DKLxsC1jg==
X-Received: by 2002:a17:906:fa18:: with SMTP id lo24mr7849154ejb.221.1612227188221;
        Mon, 01 Feb 2021 16:53:08 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m10sm9326396edi.54.2021.02.01.16.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:53:07 -0800 (PST)
Date:   Tue, 2 Feb 2021 02:53:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: About PHY_INTERFACE_MODE_REVMII
Message-ID: <20210202005306.k7fhc4hhwbjxqbsr@skbuf>
References: <20210201214515.cx6ivvme2tlquge2@skbuf>
 <5a4d7b45-b50c-f735-b414-140eb68bc745@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4d7b45-b50c-f735-b414-140eb68bc745@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

Thanks for the quick answer!

On Mon, Feb 01, 2021 at 04:26:36PM -0800, Florian Fainelli wrote:
> It depends on the level of control that you have and expect more on that
> below.

> That is true if we consider that you can use an electrical connection
> other than MII, which was the flaw in the reasoning leading to introduce
> the above commit. If you took the name reverse MII literally like I did,
> you would not think it would apply to anything but MII and maybe reduced
> MII, but not GMII or RGMII. More on that below.

> I don't believe I ever saw a system that used reverse MII and yet did
> not use either plain MII as far as the electrical connections went. That
> does not mean you could not electrically connect these two systems using
> RMII, GMII or something else. With RGMII, I don't see the point in using
> a RevMII block especially as far as clocking goes, both link partners
> can have their own local clock and just do clock recovery upon receive.
>
> When this commit was done, the only use case that had to be supported
> was the case of two Ethernet MACs (one a video decoder, the other a
> cable modem) connected over a MII electrical connection and we could not
> change the cable modem side, so we act to make ourselves "look like" a
> PHY which the hardware supported. Back then the GENET driver was just
> getting a facelift to use PHYLIB and so it still used a fixed-link plus
> phy-mode = "rev-mii" to get that mode to work which was probably too big
> of a shortcut in addition to the flaw in the reasoning about what RevMII
> really was.
>
> If you would like to deprecate/warn when using PHY_INTERFACE_MODE_REVMII
> value and come up with a better way to represent such links, no issues
> with me, it looks like we have a few in tree users to convert.

Well, everything depends on whether a formal specification of RevMII
exists or not. If you're sure that all users of PHY_INTERFACE_MODE_REVMII
actually use the 8-bit wide parallel data interface that runs at 25 MHz
and 100 Mbps ("that" MII), just that they operate in MII PHY mode instead
of MII MAC, then I can work with that, no reason to deprecate it.

The problem is that I saw no online reference of RevMII + RMII = RevRMII,
which would make just as much sense as RevMII. And as I said, RGMII does
support in-band signaling, it's just probably too obscure to see it in
the wild or rely on it. RGMII without in-band signaling has no reason to
differentiate between MAC and PHY role, but taking the inband signaling
into account it does. So RevRGMII might be a thing too.

For example, the sja1105 supports MII MAC, MII PHY, RMII MAC, RMII PHY
modes. But it doesn't export a clause 22 virtual PHY register map to
neither end of the link - it doesn't have any MDIO connection at all.
Does the sja1105 support RevMII or does it not? If RevMII means MII PHY
and the clause 22 interface is just optional (like it is for normal MII,
RMII, RGMII which can operate in fixed-link too), then I'd say yes,
sja1105 supports RevMII. But if RevMII is _defined_ by that standardized
clause 22 interface, then no it doesn't.

In the DSA driver, I created some custom device tree bindings to solve
the situation where you'd have two sja1105 devices connected MAC to MAC
using RMII or MII: sja1105,role-mac and sja1105,role-phy. There are no
in-tree users of these DT properties, so depending on how this
conversation goes, I might just go ahead and do the other thing: say
that RevRMII exists and the clause 22 PHY registers are optional, add
PHY_INTERFACE_MODE_REVRMII, and declare that sja1105 supports
PHY_INTERFACE_MODE_REVMII which is the equivalent of what is currently
done with PHY_INTERFACE_MODE_MII + sja1105,role-phy, and
PHY_INTERFACE_MODE_REVRMII.

Having a separate PHY interface mode for RevRMII would solve the situation
where you have two instances of the same driver at the two ends of the
same link, seeing the same PHY registers, but nonetheless needing to
configure themselves in different modes and not having what to base that
decision on. What do you think?
