Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B11E3EA09F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhHLIhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbhHLIhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:37:22 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7999C061765
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:36:57 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r6so7131520wrt.4
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 01:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a6NNiQME50WHs2hgAEXfyqN+iTAC9fhJz0yHc/XzASY=;
        b=txYfv4EBBu+do3uMvbzB7esEi6jdcGA3NIAApu9wttDjDahImWJf71XwBIoILKwLNH
         mciboiRbioPX2H5pmrGMvrkaGLOmZ5oKw5EMaN6gR/CoDsKCmb8mXdUvu3V/AFMJsim8
         mcI0QpVgpLNccymU3FT12jv9OVK4CFzoFyIVC+6fXrQFBBBeA/Sds1qXRBRDH1Cog53f
         Ze32M51DPc9CxIlEBOIIXjJbSxDnWlfTStt6Dp8f/iAS03m3LvVSgDeYTZ9sl4Z8Ran/
         jkK0uVBBREOknh9A8PuG/YV4bPgt72QcufI+wunAwS8kCv68uIO/jrJG9IBI5jAfX05u
         tLJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a6NNiQME50WHs2hgAEXfyqN+iTAC9fhJz0yHc/XzASY=;
        b=evgN6J8opH/rWRRIHqPUORXuvFi19JmEbDdqauSjqyDfJZatlgRGPDwFhGh3I+apY7
         2Z7i3Qpqu6gEQW3bfo7yTk64LQHyBRtn8SULbxifMQfVFDqWLzR2znFmkWNpKqK0QivD
         EptkPJeJKzJXqk5fEcaSW/UEMp0kZTmHpwopEEJe47sBxtXnJnia4tSA4KWbzsBnWpaO
         +bGIHGG3FZpdbk0xHj3l2zrqEFJ0lh7ae/x4q0gwEYyNfdl6eiP1SOtwfC8gQgk4NK/C
         WH+RYUk5f48wWSxM4QAIs3mY08asIdt+5IjegoCik6b8CJRKngdA0syCbwOT+1d0nWG9
         7b4w==
X-Gm-Message-State: AOAM532CmKuizq6aIXLV9+duVGfIimMi1hqG6GjUXFCMZ/bb2iVWABrc
        t+xpkAhDvMovB1HLCN0madg=
X-Google-Smtp-Source: ABdhPJzbRTvZ12WsmiXohCsb7R3TT4N7HPC4vDj9yzXGCbLhy+W0nYorXsrsRfgrizbKlx+wRwCW9A==
X-Received: by 2002:adf:fb8f:: with SMTP id a15mr2717416wrr.92.1628757416297;
        Thu, 12 Aug 2021 01:36:56 -0700 (PDT)
Received: from ?IPv6:2a01:cb05:8192:e700:90a4:fe44:d3d1:f079? (2a01cb058192e70090a4fe44d3d1f079.ipv6.abo.wanadoo.fr. [2a01:cb05:8192:e700:90a4:fe44:d3d1:f079])
        by smtp.gmail.com with ESMTPSA id i10sm8594536wmq.21.2021.08.12.01.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 01:36:55 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: print more information when a
 cross-chip notifier fails
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
 <20210811134606.2777146-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <aa4245b9-5e6f-0d60-d1ee-6bf8326501a4@gmail.com>
Date:   Thu, 12 Aug 2021 01:36:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811134606.2777146-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/2021 6:46 AM, Vladimir Oltean wrote:
> Currently this error message does not say a lot:
> 
> [   32.693498] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
> [   32.699725] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
> [   32.705931] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
> [   32.712139] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
> [   32.718347] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
> [   32.724554] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
> 
> but in this form, it is immediately obvious (at least to me) what the
> problem is, even without further looking at the code:
> 
> [   12.345566] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 1088 deletion: -ENOENT
> [   12.353804] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 2112 deletion: -ENOENT
> [   12.362019] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 1089 deletion: -ENOENT
> [   12.370246] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 2113 deletion: -ENOENT
> [   12.378466] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 1090 deletion: -ENOENT
> [   12.386683] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 2114 deletion: -ENOENT
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
