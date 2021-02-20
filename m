Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F2F3203C2
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 06:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBTFPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 00:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhBTFPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 00:15:20 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCD3C061574;
        Fri, 19 Feb 2021 21:14:40 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k22so4517162pll.6;
        Fri, 19 Feb 2021 21:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o9reUPtchiVg8+dPYDuDLwMmtsy0TiLmDYyaeL4F0T8=;
        b=G3zIdIPVpuc6woYpa//v9zo+I4FCvqhbaJf/1f41pzRhCHOGLCTpyRIzmh86yFDlWv
         /MKKnk2Pw+EkmJQQT9P6H0wIWTsAh68WWM9128yv7oRAvppLZZ4ySItphxcs/jzQeyZB
         WnGIWxkwy2ZylnYzV3IhF73F9SdwY5+OTKZ4JO6Kiz53kyvoPM8HJ4VcCRQp7uwiB7SV
         wHliPlLU2JIDKvVh3EluTggJEXpXHP2z+lmtQHs0RWUWKUpiCJD9cMOqz0qdpSAmncfF
         lUB34hgYZ6u3aEQNC2ZMSGexK2Ojb3ZViuZx7dGYW59OzqChYOd0OfBRLeBDF8SiuIRI
         eImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o9reUPtchiVg8+dPYDuDLwMmtsy0TiLmDYyaeL4F0T8=;
        b=GdRrrFltyq6WLs5CBFr+ofW22PHcgujOGpGo3zJitwwNNEqVErqmuKdf2eudaABIGA
         XVIaiXo4nz8oev47M1LrSphRXuUtqwKWRIcrJrEv7V8MCpuLDB7lypQPGVFnT80pmP6J
         RRICupu24mQTjAcAtDwFAMf4erp0edu1IBU8DxCDS/dK7yRT5pybc2BwNvWBy61VmjyO
         4r0Ie8IBs3HJ2+VbYnMx64w0GUIofkch+F5DxI1RWWQtXTjt6uiB7h6xfl9vcuZnQoNE
         RpUBDJfl1jlkPDEEfY1m6Wv07Ou+0HGjPc7vqnkaVJ/N7m55OwPR667QuPZO4oiO0P74
         2f2w==
X-Gm-Message-State: AOAM531UUYn2+cgTmk9Jt4WwIjP1TEbB72zEhJoeJE9SxnXR9leDn8c+
        BgTPOEMOgkRChfhpg8ZRDzvcconsPyk=
X-Google-Smtp-Source: ABdhPJz5swjqiw0YiiHcQcUn/tnwMvLZy3pi2GObJGw7Kbs0bDGTS3HcCcX442+k3WjHbZDUfp6LlA==
X-Received: by 2002:a17:903:188:b029:e3:dd4b:f6c1 with SMTP id z8-20020a1709030188b02900e3dd4bf6c1mr241837plg.81.1613798079330;
        Fri, 19 Feb 2021 21:14:39 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u142sm11918394pfc.37.2021.02.19.21.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 21:14:38 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: Fix dependencies with HSR
To:     netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210220051222.15672-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <22f9e6b7-c65a-7bfb-ee8d-7763c2a7fe74@gmail.com>
Date:   Fri, 19 Feb 2021 21:14:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210220051222.15672-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/2021 9:12 PM, Florian Fainelli wrote:
> The core DSA framework uses hsr_is_master() which would not resolve to a
> valid symbol if HSR is built-into the kernel and DSA is a module.
> 
> Fixes: 18596f504a3e ("net: dsa: add support for offloading HSR")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> David, Jakub,
> 
> This showed up in linux-next which means it will show up in Linus' tree
> soon as well when your pull request gets sent out.

I had initially considered making is_hsr_master() a static inline that
would compare dev->dev.type->name with "hsr" since the HSR master would
set a custom dev_type, however the xrs700x driver would still fail to
link because it calls hsr_get_version() and for that one there is no
easy solution.
-- 
Florian
