Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACE2361678
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbhDOXqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238039AbhDOXp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:45:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8379CC061760;
        Thu, 15 Apr 2021 16:45:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id t23so12947030pjy.3;
        Thu, 15 Apr 2021 16:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Si2QMfbQyLWbLgTfPoCpkBS5/xPKKL/YtpVajnarAcI=;
        b=kJ+NAzxfY/BsEzepP3FS2mXt64Fg+cRrsT6q4kMEbQ9g5aK+OpcfZkw/rcCJT2ikHo
         wI5ZhVfCkQDcJY5ELSPwcaQ+gN92pkZMxRwbk9KV5fFgPYeO/426kDe2OmyDpqMR77Ks
         UOXa60lvMI99d+xC3c0V3d1p8C5TZ1OqNAY1pEeQk9jb9agBgOmgjYURHBbb/GntICKU
         TdlD0cHLqJJLb/m6xzkaeXZ+HEB2GgehE6DiwnBVIJg75IH3mvkN8oKmGE0inGtsQTKV
         7JS/SJUufdeAUVbGDjIGWmqjt6hRYcM0Nuy0Sqj8qLaKfQ0lhQTWHJZORd9kzQEgqTts
         c1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Si2QMfbQyLWbLgTfPoCpkBS5/xPKKL/YtpVajnarAcI=;
        b=ngtiqYeJX6YbIqn28HRchQ0rYr3UdFBDgVhP8kSwTA3HXT2rfMwWjrjQynCxVOzY8a
         dTCdlOOnrY/OfvCyvkaUPzkCa9I0j+Q000D9/Sic6w0lP0pid88L6YAo7PNhK8HZVUYY
         iMoPai6U5P30qPReVicTdVIHr3f2lktCGzS+V1eAkT+b3tjN7aUeN1DHFIh961AB43KV
         couXOvAazI/HL8tu0X5aYzPEP13x+d4oq1yTLj1+yTsYc3iMs7mx01VxjZemsZRadMvl
         WI63K2ScEs5njLnXvU3Oo1K2L8b21eaE+ciHA2Cdp53sNbioXd85l+n33t2nm93MEptQ
         N6qg==
X-Gm-Message-State: AOAM530gKX21QBsmOSubdACPqFZYPeiqVc0POhn8+X6Z9DuOgVpRhcLv
        MdRGlPlbH6bPyONqC3zXZ7Q=
X-Google-Smtp-Source: ABdhPJzeqRVyikE4g2NRC6TxUumt+P8SvYO2O62BPk2NkduFoclTNNpxyVloGDdnngdwnYJ3LHdnkg==
X-Received: by 2002:a17:902:9685:b029:e9:abc1:7226 with SMTP id n5-20020a1709029685b02900e9abc17226mr6695757plp.64.1618530333787;
        Thu, 15 Apr 2021 16:45:33 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g10sm2786670pfj.137.2021.04.15.16.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 16:45:33 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add
 nvmem-mac-address-offset property
To:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>
References: <20210414152657.12097-1-michael@walle.cc>
 <20210414152657.12097-2-michael@walle.cc> <YHcNtdq+oIYcB08+@lunn.ch>
 <20210415215955.GA1937954@robh.at.kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a49f4027-126f-7bcc-24e5-75499ec5e1fa@gmail.com>
Date:   Thu, 15 Apr 2021 16:45:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415215955.GA1937954@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 2:59 PM, Rob Herring wrote:
> On Wed, Apr 14, 2021 at 05:43:49PM +0200, Andrew Lunn wrote:
>> On Wed, Apr 14, 2021 at 05:26:55PM +0200, Michael Walle wrote:
>>> It is already possible to read the MAC address via a NVMEM provider. But
>>> there are boards, esp. with many ports, which only have a base MAC
>>> address stored. Thus we need to have a way to provide an offset per
>>> network device.
>>
>> We need to see what Rob thinks of this. There was recently a patchset
>> to support swapping the byte order of the MAC address in a NVMEM. Rob
>> said the NVMEM provider should have the property, not the MAC driver.
>> This does seems more ethernet specific, so maybe it should be an
>> Ethernet property?
> 
> There was also this one[1]. I'm not totally opposed, but don't want to 
> see a never ending addition of properties to try to describe any 
> possible transformation.

If only we could load eBPF bytecode embedded into Device Tree ;)
-- 
Florian
