Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCCA1ED707
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 21:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgFCTnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 15:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgFCTnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 15:43:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F22C08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 12:43:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id l11so3674317wru.0
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 12:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AQr2Ka2YanwAroXZBYUCo6D07lcOrZs5/ic+XxZVkGk=;
        b=obm8+D/meYb3G4IxeDC7bxxyh1V2VjX9SmtRdQWHooRFj5/UU6FmXIXQAHZk1UjeeC
         ZqpGuu5dreAY+tYaDXfJsSHw4OhCSzxSaqQGporGMi1kOFqFPsbMYfdyn3o16Urnv3cW
         fJKA5X7K+Hzzco8xvmqSUXBlol12dkPYwtBjIBNCG4o5AcQFfjpz/DtRsNTsuB0LP8a0
         IGCLg1vke6sLOk+VC7yFNicE7vPgXTRmvtSH7GiGuuq8S1Yf2TcZOivGNB5IGdkwx01X
         HetXawKmEQYuTcYjKmRpJMJOrgdqEyYvry9EvI6rOarz09FFIQdXogylbIx8LQu/Q0oU
         l74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AQr2Ka2YanwAroXZBYUCo6D07lcOrZs5/ic+XxZVkGk=;
        b=tAaXgGwvTEEAZjJ+jVDdxfogNWxS4+o8PDifkxJpNHhSGYl1fvKHt9X9swHKnkefEh
         2fFt/Pd5ORnk63XjvwQwcySq7m1waFGy4MlCJg3u1+6+i/9qHms6gHzwVi+SGm3Nf32k
         ET70geifLXXPD//XsCkjVULDvw6rPxDyxaCYYdq7Pj6NwCf5u3pcWr1Dgm1/ZvGEAgUi
         zndW47Eg7RxTAzFlDAiZmzB7xHS4mh0uiHeTDeIaCJu8T+QXGSRVJKouCfgTkKcBqrxd
         StS1Ng3wg93gtQ+cHwT0whV/5Hts/kBkW/F2PuU9qUhrpzhEfGDLt6+QWPKeO2pDKkDm
         sXJQ==
X-Gm-Message-State: AOAM53342jSyG5tH/2szddUEzoZxeEo9jw2IphDbuywXJ6ketVHTxQwd
        XnJkuT6QA0+m5ydWhkghpBhiEH6f
X-Google-Smtp-Source: ABdhPJzUkCYYjGkx6N2/P3GbVKAdoRL6JVBSG6KCwnnHSl4XcagKBvs+NQTAg/EjPjSo6SJstTYp0g==
X-Received: by 2002:a5d:4c8f:: with SMTP id z15mr933597wrs.19.1591213409413;
        Wed, 03 Jun 2020 12:43:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:7165:d336:c1fe:9e7a? (p200300ea8f2357007165d336c1fe9e7a.dip0.t-ipconnect.de. [2003:ea:8f23:5700:7165:d336:c1fe:9e7a])
        by smtp.googlemail.com with ESMTPSA id h15sm4514719wrt.73.2020.06.03.12.43.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 12:43:28 -0700 (PDT)
Subject: Re: Unrecognized RTL8125 in r8169
To:     Eivind Uggedal <eivind@uggedal.com>
References: <CAM-O=1A6og-E9YBLa59tvz+iZcTs5Qa2yX7kUC0O2VZbtNpNMA@mail.gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <66af2954-b34d-73d6-d7eb-d697b709b5c7@gmail.com>
Date:   Wed, 3 Jun 2020 21:43:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAM-O=1A6og-E9YBLa59tvz+iZcTs5Qa2yX7kUC0O2VZbtNpNMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.06.2020 20:57, Eivind Uggedal wrote:
> Hi,
> 
> I saw you added the initial RTL8125 support in r8169.
> 
> I have a recent x570 motherboard (MSI x570 Tomahawk) with onboard RTL8125. With r8169 from 5.4 and 5.7 I get:
> 
>> unknown chip XID 641
> 
> from the r8169 driver since XID==641 does not match any of the mask/val in rtl8169_get_mac_version().
> 
> I did not see any relevant unmerged changes in the netdev-next tree.
> 
> I have a hard time following these "magic" masks/values and could not correlate them to anything in the Realtek oot r8125 driver. I have some C experience, but zero driver/low level experience.
> 
Thanks for the report. XID 641 is CFG_METHOD_5 = RTL8125B in the r8125 vendor driver.
This new chip version isn't supported yet by the r8169 driver. Typically I wait for
reports like yours because:
- Not every chip version in the vendor driver makes it to the market.
  Adding support for it would be wasted effort.
- I don't have hardware for testing. I need users like you for it ..

> I could try to just fallback to RTL_GIGIA_MAC_VER_60 or RTL_GIGIA_MAC_VER_61 locally, but ideally I'd like a proper patch that can be mainlined.
> 
This may or may not work, partially also depending on the link partner. Typically each
chip version needs it own quirks, therefore they are treated differently by the vendor driver.

> At least one other poor soul has the same issue: 
> https://forums.unraid.net/topic/92998-dhcp-networking-issue-v-683/
> 
> Seeing as this board had a world wide release just days ago maybe this is a new revision of the RTL8125 chipset?
> 
> Appreciate any pointers and help to debug it further!
> 
There is not really something to debug. I have to port all chip quirks from
the vendor driver and ask Realtek for a firmware file.
I'll put it on my roadmap, maybe it makes it into 5.9 or 5.10. Until then
you would have to use vendor driver r8125.

> Regards,
> Eivind Uggedal

Heiner
