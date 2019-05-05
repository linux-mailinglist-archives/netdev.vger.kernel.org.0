Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F131413C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfEERBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:01:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39434 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEERBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:01:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id e92so5140993plb.6
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 10:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f53uxdGSlyuVAmhNGpORR0T9sTiP0o+doPgItxtU3r8=;
        b=BDUg7Ove0N2PrcXtb3tNLi0MBKyAH/kDpPbtx73GtID3Qrf2dZtDfdSnIQRPUr4+6+
         AlEs2Mk3cuyoBZIKSFtJCyO8Nq2BhYtKRfkFiI1IC5cq5InZ0ro/ddS06x0HB6iNVtay
         VX93i+WN2Z6Vvak8ZShe7jkIEtwI0Et3V/qEcmhyXj6KDAmgBjOGvzB2VLiOH2RtwR8y
         ShQ2n+n6VJP2qa1In4aMmMLPX0jfSWx+Be3Utkez5tVf1EfWtPyG4pRRWzoDIiMUVi9g
         P4+EnRuI0TT6oQty7w/AzHaCDBuOA0vEKlkpm0i5s3D941t3P7pQunN3fnh6vAMU9m1T
         KROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f53uxdGSlyuVAmhNGpORR0T9sTiP0o+doPgItxtU3r8=;
        b=pL0qwHSs3nqFfUiL0x5HFKjD2jhk9a/OI9VNwx1gWGpl2ftF3T7m54zJ/R7cLfN/yh
         ST7e9V93kcT/+/I7JPQwEX8X7zi+PaRVcmNF6Ylfg0hAeHfkdQXl1qJnxfDqENXL0hs+
         kgIOEy1nJxDt584VgKI0OTUwrFLwqEPuQAYdfq7tg3Jf48mHg1+gNt61FYZpGHHYwQ9n
         82cR7OABKp+FT/G9xb8/JJETYEZ714nIAk8y4LqEjsUQSKETQaAYRKGidOoNUezqmdiR
         Ncu2Dp7zaN7X/DKA7R4wEiMvWe9rdiGxw9vxO90EEuQDdrAKmRedkM9NRfaIvqEX1mi0
         0AKQ==
X-Gm-Message-State: APjAAAVp29/PbqCZ9jMh66RIfVNyeXIARmz5989+BZU7BSpRB7xURrHZ
        Dcg9yekXUtvNsojqYG0yknxnRGuC
X-Google-Smtp-Source: APXvYqy5c2aice3/2IUjOIYfK4fWDuOATwSTv2klewdfQ8d2nJ28/VuOkb2XMdEqmAsOC1f0+zx0ww==
X-Received: by 2002:a17:902:7689:: with SMTP id m9mr26060227pll.274.1557075682991;
        Sun, 05 May 2019 10:01:22 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id b63sm16771795pfj.54.2019.05.05.10.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 10:01:21 -0700 (PDT)
Subject: Re: [PATCH net-next v3 02/10] net: dsa: Export symbols for
 dsa_port_vid_{add,del}
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190505101929.17056-1-olteanv@gmail.com>
 <20190505101929.17056-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <b32a8e0e-a603-aa44-cc49-0dfdfcb93c4c@gmail.com>
Date:   Sun, 5 May 2019 10:01:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505101929.17056-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 3:19 AM, Vladimir Oltean wrote:
> This is needed so that the newly introduced tag_8021q may access these
> core DSA functions when built as a module.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
