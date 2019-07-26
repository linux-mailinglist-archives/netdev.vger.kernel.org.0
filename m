Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43BE9771D0
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbfGZTFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:05:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33511 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388306AbfGZTFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:05:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so55556152wru.0
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gVa8cIbPutE5rL45K7Sot9V21PybDTNJygwf/2u2+nU=;
        b=SotgcCso6c/cna9LVi/B1UJr2mtT7q8m87lO0v85tshWFNBQdXSioVH1nJoOjsj24p
         qB0r0gmRjD7SIG0Zgfrr/tmKgE7XDzuG0KGDmQL8a1GiEPkMXcxRN2udZlH529ODi6sd
         T6ZmrGcMK5NxDMU4U+PwlbD0qWZ2+XlCBfSor6AFpoy6c0A5UDxd6qteIePhj9QjJVY3
         Iqqs4Mk57T0a7Uo+AcN1YOC0D18MDru/n0U/em2lUKdWEjYHrc5XOGyuEf3o4XZFKHup
         HiaCPg2nbYf6fECPDHIjYIY3nqdfESKGIfAX7Fmxcak9UFXVptPOrq0pjQxT+5IkI6w6
         CZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVa8cIbPutE5rL45K7Sot9V21PybDTNJygwf/2u2+nU=;
        b=TuX0PKkbp6JRdvJxqMP2N2ipBVv/Pn9bgqq8lK7svKjnbepSd4243g8ajur/cIsBQs
         Dl30hB4/LlNecVPPS86f4pzrEVW+RCdLk6q+5coc0JNluNTYjzacNh66PRE1F+agbTG2
         h3ZlUXC8/qSrd8FYjT/SEgo1ynSTGQUlWj5XgMdpuzrcpMKwYgFUrhtCmBq6aGfARH/c
         moc/HgaHuRmZELOcdS3siQaW2QcoUJYK8BTQg1+X37nB8WmsZyoj8biE1L06Kzlb0XuG
         DFr2BesvmYip0Y78Fytays9hfP0m/h4sGueWdGO29HBZt6uIM4xCZ53KmF7J7q5OaJ/I
         sEsA==
X-Gm-Message-State: APjAAAXC2SD3xA2w2Hj/hKv5sJkIri/j5r2ooTQeLc3eGbRkp1kPJSbq
        wVG0riH0SqIRPzuqkVuq1ls=
X-Google-Smtp-Source: APXvYqxIrXvIFUMenEl4saGYID2J6nEtUqtt8CxSjcZXWkvEhJXz7gphABRE+FA2vfv2bZokKh1ONQ==
X-Received: by 2002:a05:6000:1186:: with SMTP id g6mr93258286wrx.17.1564167912637;
        Fri, 26 Jul 2019 12:05:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:55f1:e404:698f:358? (p200300EA8F43420055F1E404698F0358.dip0.t-ipconnect.de. [2003:ea:8f43:4200:55f1:e404:698f:358])
        by smtp.googlemail.com with ESMTPSA id h1sm39654182wrt.20.2019.07.26.12.05.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 12:05:11 -0700 (PDT)
Subject: Re: Driver support for Realtek RTL8125 2.5GB Ethernet
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     Linux Upstreaming Team <linux@endlessm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
 <e178221e-4f48-b9b9-2451-048e8f4a0f9f@gmail.com>
Message-ID: <a3066098-9fba-c2f4-f2d3-b95b08ef5637@gmail.com>
Date:   Fri, 26 Jul 2019 21:05:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e178221e-4f48-b9b9-2451-048e8f4a0f9f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.07.2019 22:02, Heiner Kallweit wrote:
> On 24.07.2019 10:19, Jian-Hong Pan wrote:
>> Hi all,
>>
>> We have got a consumer desktop equipped with Realtek RTL8125 2.5GB
>> Ethernet [1] recently.  But, there is no related driver in mainline
>> kernel yet.  So, we can only use the vendor driver [2] and customize
>> it [3] right now.
>>
>> Is anyone working on an upstream driver for this hardware?
>>
> At least I'm not aware of any such work. Issue with Realtek is that
> they answer individual questions very quickly but company policy is
> to not release any datasheets or errata documentation.
> RTL8169 inherited a lot from RTL8139, so I would expect that the
> r8169 driver could be a good basis for a RTL8125 mainline driver.
> 
Meanwhile I had a look at the RTL8125 vendor driver. Most parts are
quite similar to RTL8168. However the PHY handling is quite weird.
2.5Gbps isn't covered by Clause 22, but instead of switching to
Clause 45 Realtek uses Clause 22 plus a proprietary chip register
(for controlling the 2.5Gbps mode) that doesn't seem to be accessible
via MDIO bus. This may make using phylib tricky.

>> [1] https://www.realtek.com/en/press-room/news-releases/item/realtek-launches-world-s-first-single-chip-2-5g-ethernet-controller-for-multiple-applications-including-gaming-solution
>> [2] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
>> [3] https://github.com/endlessm/linux/commit/da1e43f58850d272eb72f571524ed71fd237d32b
>>
>> Jian-Hong Pan
>>
> Heiner
> 
Heiner
