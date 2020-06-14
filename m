Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DEB1F899E
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFNQOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 12:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgFNQOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 12:14:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAC7C05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 09:14:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x13so14639357wrv.4
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 09:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TukYlSH90/lx+DZPwDOiJtp5ymqE/VSeT6bOu0/OzqI=;
        b=nfM9ldS1XGEci/0nMcrxea7JnfJjZB0jDkmzkrAyTgZS08hIl3qUOiieMRpLo+OLvB
         dSEqrAhfE5yd1NCgigP7X1HxT9pDfY9LbOc3v6dmLiqiXZ+DOdvcJhVRyo9EypanYJVD
         tokGhb60yAkMW7SPgmftp/fS6VY6Oo1DTGHKcHecEOIcNS4slpPFRt3tR3rRZQjADcU+
         2VJTMW7Q6/GTqn7sLDvwVUMAz6jVaZeVZOotjrcBsj2b4HA7yRZbBjtN63z43jDbamyM
         zu48MPHRFWPLsCW2ZqmAwDe8gnDsyiJaeSXHIEoVx1xExivsZYd6Hzan0WDBpnxUCBei
         aGdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TukYlSH90/lx+DZPwDOiJtp5ymqE/VSeT6bOu0/OzqI=;
        b=TjqW4yU12YQbSDnAk/Q8i2FnWQlCvfFkltyB3k6KPzpRb5Dh+mEkKZ+kxjrXNC9l3s
         rjsUpLS+o+ojklFj9hwerxCCWGZ/iwXIbalzxhrJmqZQdA1MI6LyRVHunkVzHetmDtAS
         mMcuZn3Rf8GQVpzYw052zG+kYVYBkNxY7ER4IYCQbVJqC1Hv/iq0JqWgafMERYrOmDFy
         /wU5AL0MjaxVtgtOuGb6cfGqUZDah+0UcjDCQd4Opq3XBahDizbm9tUsy9IPvXJ3kBkq
         amxpU1ensx3YmwXyFn3A8cIAiJByL3Z2xwhnD+cgoG3cz3/UAW/u5iW00InjLWF7Mufw
         Ddwg==
X-Gm-Message-State: AOAM532kkSos3iGiOfVJKogWNnldfgpMSq/lFfnexV5e6ZUTfb9x3WiT
        0lDvwCSoUw4bCOBQp5XMkwPfMH7Y
X-Google-Smtp-Source: ABdhPJxacAK/kK2s/xQmteQrJnqlalVcahSBCasobhjvj2WXb6XBG4Oe5gaRM3Bf7vU+aZ2nyj317w==
X-Received: by 2002:adf:a41a:: with SMTP id d26mr25297387wra.324.1592151258943;
        Sun, 14 Jun 2020 09:14:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b85b:4ddd:bc92:4bfb? (p200300ea8f235700b85b4dddbc924bfb.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b85b:4ddd:bc92:4bfb])
        by smtp.googlemail.com with ESMTPSA id o20sm21480082wra.29.2020.06.14.09.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2020 09:14:18 -0700 (PDT)
Subject: Re: ethtool 5.7: netlink ENOENT error when setting WOL
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <77652728-722e-4d3b-6737-337bf4b391b7@gmail.com>
 <6359d5f8-50e4-a504-ba26-c3b6867f3deb@gmail.com>
 <20200610091328.evddgipbedykwaq6@lion.mk-sys.cz>
 <a433a0b0-bf5e-ad90-8373-4f88e2ef991d@gmail.com>
 <0353ce74-ffc6-4d40-bf0f-d2a7ad640b30@gmail.com>
 <20200610200526.GB19869@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2994dba7-c038-5702-a5ec-e11d5741a1e5@gmail.com>
Date:   Sun, 14 Jun 2020 18:14:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200610200526.GB19869@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.06.2020 22:05, Andrew Lunn wrote:
>> Not sure it makes sense to build ETHTOOL_NETLINK as a module, but at
>> least ensuring that ETHTOOL_NETLINK is built into the kernel if PHYLIB=y
>> or PHYLIB=m would make sense, or, better we find a way to decouple the
>> two by using function pointers from the phy_driver directly that way
>> there is no symbol dependency (but reference counting has to work).
> 
> Hi Florian
> 
> It is not so easy to make PHYLIB=m work. ethtool netlink needs to call
> into the phylib core in order to trigger a cable test, not just PHY
> drivers.
> 
> Ideas welcome.
> 
When looking at functions like phy_start_cable_test() we could do the
following: Most of it doesn't need phylib and could be moved to
ethtool/cabletest.c. Or maybe into a separate ethtool phylib glue
code source file. The phylib calls (phy_link_down, phy_trigger_machine)
then would have to be moved into the cable_test_start callback.
I see that each callback implementation then would have some
boilerplate code. But maybe we could facilitate this with few helpers,
so that a cable test callback would look like:

phy_cable_test_boiler_start()
actual_cable_test()
phy_cable_test_boiler_end()

>       Andrew
> 
Heiner
