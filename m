Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAF6162F02
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgBRSvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:51:31 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55179 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgBRSva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:51:30 -0500
Received: by mail-pj1-f65.google.com with SMTP id dw13so1419987pjb.4;
        Tue, 18 Feb 2020 10:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VVBvTCIz+yTpld7B2DsaTCEQHI9uyXmzgTeduGY+LYA=;
        b=YyfD8RI2sOZkvpQX+EPsxFwPE+8W6Mqhbgaev0cp3lZfa1zBdEkHJwnYok6Q84CGw5
         4MotE/7eB6g0ZFFCcYW59THKajcBFuVQkh9BFG99NU4OcPCBKIJ5IhyZ5S4hXa/oScm2
         nJSmaVJsd7eIJneNj5ixjj6vNqkw18m3Z+AYZTXAPJwSTIctzoTUoqVaTLRt7mGsD+sH
         I1tHTvOVQyjydoojWGlPS7DCuqsXCz2zvXVXBjr/KPWLvxOvhKdQMPPN7a8FmN+0QRCP
         bOoSRgPbC+gfD5KTmFsJiwvSQTGqMFcHqg1hlbCyOdsHBv/KcWHzGF2qBRfQ2uM8e332
         BFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VVBvTCIz+yTpld7B2DsaTCEQHI9uyXmzgTeduGY+LYA=;
        b=JmwkiKjVioIH+MajnlXHcrTxgpJG7gYd++LcoQv+VhoiggcGoycobmlDhWGdQSNFcM
         9Lg1xvgtA8qq++AmUR2Lvy4aoJo/FcR4kKJ5MYQfUCLZPRBEIdtJhl+hV6dTmK0zUnBA
         M62K5rIbwkAWmaq8GSiGqLJdak6ixekJCbEiDZUoAprju1kyZ/0Nh2b/EyEsCo18QqN5
         dve1sOy+RvVqGe3PSzX6tVYEFRz5hjxnRByKB/pqTi4O7fgYTLE72tjfhflUI7/iwSkV
         +4Kxz/1kmti3la9KOwohnTQPzX2r1I0YLvStY5eU2r5xPcWeIcNOAhG+vDkDfJE5eF/w
         uRJg==
X-Gm-Message-State: APjAAAWYIO59qTijlxele266b6cOd6VoPDJjK11ydsY6L3U7c/BXG8Hr
        AadVA/uWdwswqGHVQAqva2E=
X-Google-Smtp-Source: APXvYqzvrBKSEU9iKuP0lRt9jwVl6eac+xJEeOlhpux5veVmUEO3+4YXawgvXtL/rE+XQnMB3A5eUQ==
X-Received: by 2002:a17:902:7283:: with SMTP id d3mr21924336pll.118.1582051889702;
        Tue, 18 Feb 2020 10:51:29 -0800 (PST)
Received: from [10.67.49.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gx2sm4000789pjb.18.2020.02.18.10.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:51:29 -0800 (PST)
Subject: Re: [RFC PATCH 00/11] Removing Calxeda platform support
To:     Rob Herring <robh@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     Mark Langsdorf <mlangsdo@redhat.com>, kvm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, Will Deacon <will@kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>, soc@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        devicetree@vger.kernel.org, Jon Loeliger <jdl@jdl.com>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Alexander Graf <graf@amazon.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthias Brugger <mbrugger@suse.com>,
        Stephen Boyd <sboyd@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Robert Richter <rrichter@marvell.com>,
        James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@alien8.de>,
        Robin Murphy <robin.murphy@arm.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218181356.09ae0779@donnerap.cambridge.arm.com>
 <CAL_JsqJpDLn5Zr2UHno1TeReqrwZ-HAAfd78AouigGi4sAQuOw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <f2b15018-2b88-01b8-14f1-a6c326b10b58@gmail.com>
Date:   Tue, 18 Feb 2020 10:51:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJpDLn5Zr2UHno1TeReqrwZ-HAAfd78AouigGi4sAQuOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 10:40 AM, Rob Herring wrote:
> On Tue, Feb 18, 2020 at 12:14 PM Andre Przywara <andre.przywara@arm.com> wrote:
>>
>> On Tue, 18 Feb 2020 11:13:10 -0600
>> Rob Herring <robh@kernel.org> wrote:
>>
>> Hi,
>>
>>> Calxeda has been defunct for 6 years now. Use of Calxeda servers carried
>>> on for some time afterwards primarily as distro builders for 32-bit ARM.
>>> AFAIK, those systems have been retired in favor of 32-bit VMs on 64-bit
>>> hosts.
>>>
>>> The other use of Calxeda Midway I'm aware of was testing 32-bit ARM KVM
>>> support as there are few or no other systems with enough RAM and LPAE. Now
>>> 32-bit KVM host support is getting removed[1].
>>>
>>> While it's not much maintenance to support, I don't care to convert the
>>> Calxeda DT bindings to schema nor fix any resulting errors in the dts files
>>> (which already don't exactly match what's shipping in firmware).
>>
>> While every kernel maintainer seems always happy to take patches with a negative diffstat, I wonder if this is really justification enough to remove a perfectly working platform. I don't really know about any active users, but experience tells that some platforms really are used for quite a long time, even if they are somewhat obscure. N900 or Netwinder, anyone?
>>
>> So to not give the impression that actually *everyone* (from that small subset of people actively reading the kernel list) is happy with that, I think that having support for at least Midway would be useful. On the one hand it's a decent LPAE platform (with memory actually exceeding 4GB), and on the other hand it's something with capable I/O (SATA) and networking, so one can actually stress test the system. Which is the reason I was using that for KVM testing, but even with that probably going away now there remain still some use cases, and be it for general ARM(32) testing.
> 
> Does LPAE with more than 4GB actually need to work if there's not
> another platform out there?

There are ARCH_BRCMSTB platforms that are 32-bit only and have 6GB of
DRAM populated, and those continue to work just fine, though there is no
known use for KVM AFAICT.
-- 
Florian
