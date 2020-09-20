Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B8B271804
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgITVGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 17:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITVGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 17:06:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E9EC061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:06:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so7207712pfc.7
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 14:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d+hazLB9SuQWdu3YJl++0+3a1YQycILLwZEAoTBZIwI=;
        b=LNwGPjy8Zm1/9a0rvgwbEfYMO8C9KtAVzfIdwLHf+Q9wOLTlPf21nNX+elek2HDCOy
         3b3CIbB2e08wfZAEWGcy8xat0PnFrIbnDuU4NEU33v+W2aVsCxLKYGbPAqIk049IK4ng
         Ag7dsP5AfknEEuJud8eoqSCxfSS7vaqLVfkB5KE14yAijlqmPVRtpnLyOLRiDoOiNIzU
         k3kvcC7OiLwSIBFaTatTlb1q8nCPsw+a3YyZLDG7/sfrk7N5Q80MhPMWQsirD7iDMP5O
         frAoPH3da13uwYnIWGiUbw4VTA/jY4cpgH68+JIcKSUpoiqNtiNZbzT+nogymP30ImlC
         hHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+hazLB9SuQWdu3YJl++0+3a1YQycILLwZEAoTBZIwI=;
        b=QY+kSp5ucrJw5Sjz7d07k+kDW/8HekpBTz47hvd73OTCT5bltIjiZG6Nl5GoSTSAo+
         REa9vwibVp2bTpB9Uye3rjBQ4gKEAKd6ciAeo0W3oMUZMZnv7ilwpCW9qFPGc+wOxyCp
         6JIWR8m0/k18LU4PyYaW0Tqnhxw+3AcxTUyIdJAT+O/pJcqBtOCUBbvgZkDDhaJRPUTK
         d5tx6iObvjcP0rwulDopr6CJPCKGohdGP3/kW9zuWCaJOoav+D3goxp+kxBvK6eKY8t/
         FB0vOV0xzmQ65btB9re3WKulajdb2OE+Wp4tozuliYSJKWDouo3MsRbW94k/yS52w0T0
         SklQ==
X-Gm-Message-State: AOAM532+0A+tW2VIwjbkt9QjOE5apGyvkbU6nOt8RyBeFh1rvFXmSm4S
        iBWtHQ4IS5UPK2yRS9/znkQ=
X-Google-Smtp-Source: ABdhPJxeJIMg2ahWRaiRIG7FjieaFLTIQS4bX2Sf0tBs2GmlQIAl43ujmqBHNKhGiqU2QFyBJ+MyZQ==
X-Received: by 2002:aa7:9548:0:b029:13e:d13d:a08d with SMTP id w8-20020aa795480000b029013ed13da08dmr40439909pfq.36.1600636012896;
        Sun, 20 Sep 2020 14:06:52 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v6sm10087773pfi.38.2020.09.20.14.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 14:06:52 -0700 (PDT)
Subject: Re: [net-next PATCH] net: dsa: rtl8366rb: Support all 4096 VLANs
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20200920203733.409687-1-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3d5feeba-c438-1d79-723b-d22d2d0b9d55@gmail.com>
Date:   Sun, 20 Sep 2020 14:06:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200920203733.409687-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2020 1:37 PM, Linus Walleij wrote:
> There is an off-by-one error in rtl8366rb_is_vlan_valid()
> making VLANs 0..4094 valid while it should be 1..4095.
> Fix it.
> 
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
