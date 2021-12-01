Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD714656B8
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbhLATwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhLATwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 14:52:22 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E14C061574;
        Wed,  1 Dec 2021 11:48:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso2581820pjb.2;
        Wed, 01 Dec 2021 11:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oL3wdxAt3wkQd9kCKUB3Vib1vH+Yv4Fjc3Goi+/KQ4c=;
        b=U2mH2UwDGKGfVXwUAm2E+l6agtDsMBmRqHT8q/a98xvuWX8JJB+ZLJ8BtuRNpIl8oR
         e0TtZZg+M+khzd81k7Z7R/BPOCEv8opFrpr3H7RVO+EQ7Avijaa1VyauYE6n2SUrRoyF
         z4YoE5rKjjy7F1Almn4vlocbQe4IjPYbDDUtLF7TRjVm7CuqWH3ouZiLrf8dvjY6OZjQ
         vals9DmsPTd1Y5OqMRu2kSXa/bjrTcmMnzX2QEMlXyRN9c9vGUAK1UrUzzCL9SZ9iJ8B
         sPI6/20p0BM6B5Fbtm+tDXK8dqsuqfgD3KnUxiwBnV3eIVZ2tKX+FmPj9fKCtEy0IuTq
         +OfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oL3wdxAt3wkQd9kCKUB3Vib1vH+Yv4Fjc3Goi+/KQ4c=;
        b=F37oajSJK3uRESemUAkIvznt3Jv3w3D2fLn5de2CVkGA9mJzFIdM4HXKzFi3OrJbdM
         ixXneKQvkYQ/pa0GOlcU/IZMWgVGttshRvTQPgf4WhCio+IpL5yztWsW+lRAJ6IS0tCT
         sxCVbSMQ/I2cBZTbMEYnv4SkayGuY6URS66ns+mnDcTEfL7XBEz4vhUm+sIZ43lS0gYd
         gz/262laJaqT9GQn5/MYaKSYF+V8LGeWeTtS/GchMPF8K5zqhZbgvc00Bazq+d8S5D+S
         Tdbo3r0mVqjTSiM9t/bmH6xJ6X0RqLl+4mgf4gbqPgRPLiLCQusUOkxhlwZPWpmCJ7wN
         vUIA==
X-Gm-Message-State: AOAM530zcDjGiRUTKBgxMnR8b/608ZnRmUswr5TG9smEq4CWitqQP3hc
        Ut6GXHv1HYyhf9V8oneKL5Y=
X-Google-Smtp-Source: ABdhPJzV2YXZzUvZsfhJRruR1dYP/GDV32dldTWUYKFhqlIoj348wlKRdJBLnSfRu2eGfBm3oMNLyQ==
X-Received: by 2002:a17:90b:128e:: with SMTP id fw14mr338996pjb.173.1638388133872;
        Wed, 01 Dec 2021 11:48:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f29sm418759pgf.34.2021.12.01.11.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 11:48:53 -0800 (PST)
Subject: Re: [PATCH net-next 7/7] dt-bindings: net: Convert iProc MDIO mux to
 YAML
To:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "maintainer:BROADCOM IPROC GBIT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Doug Berger <opendmb@gmail.com>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
 <20211201041228.32444-8-f.fainelli@gmail.com>
 <YafH0nADqO7DTU4A@robh.at.kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <85b4d71e-243f-7bb1-4e0f-b68b8cff4652@gmail.com>
Date:   Wed, 1 Dec 2021 11:48:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YafH0nADqO7DTU4A@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 11:06 AM, Rob Herring wrote:

[snip]

>> diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
>> new file mode 100644
>> index 000000000000..a576fb87bfc8
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
>> @@ -0,0 +1,80 @@
>> +# SPDX-License-Identifier: GPL-2.0
> 
> All Broadcom authors on the original. Please add BSD-2-Clause.

Sure, please review v2 and let me know if there are other changes that
should be done, v2 was sent before you had a chance to reply to this one.
-- 
Florian
