Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737C32C184C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731601AbgKWWPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730427AbgKWWPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 17:15:15 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C012FC0613CF;
        Mon, 23 Nov 2020 14:15:15 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 5so9564084plj.8;
        Mon, 23 Nov 2020 14:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nucHxpp26qc0ylPI7uSda+OP6ZowlVW2c8oc856XvWs=;
        b=Qba2Pd2/LUw6ydm54H22Tl0peo96S94ThTMATb1D/yTD0swt3FgUXmZOeQJrgogDyK
         1AGYeTfKEYqR10ewLRG/jx2vjT6/RNjDmyaianQt239jl/LYywLyw3df7c8FypryESQb
         /vaTb2XipMDTmVXtS31JXvHqgDdVltQ5L43zZ4i4CyQiJVEwJJN1+ADJYSUxQoJU67nS
         8Jih65OMUaZKi+3WWV3l98JUoMqvcpcoS4i6d4i1YAAuiXoLBqElvB5PuXEScvd0/CuT
         j/3T2NXMYtMhKjmrFKq3ctFxp4OneV8MkDWz9HZBuOlZCSEYW1E8dMkiWILbpuIS6GNW
         ut4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nucHxpp26qc0ylPI7uSda+OP6ZowlVW2c8oc856XvWs=;
        b=iAKREkqWx+E84ZoM2O2+2ZhYV0JCCKr1AZgB0Oloh0UUoZc5ibn5Egdc834u7ljBDN
         e7M2txO3M+763hfCCigvo2msN/mJNxwuA76XMBz+kgyYCgkJ72YK6/Lt+UaHZ5+S1aHQ
         ARQBVb81umOSTYXNUmayauSxsWRGFZ8qFK3VyQVfclMSMgvqO/doQVcOdVtHVgJKJITE
         3XAFWykYVSvu4hhTtufm6fHspqLFNv+9ilbdkL54RROBMajpn3/4pHe/CbwSyPMu1S2F
         BsTB+6PiXyfVYdZA4T3ih84CLzwTTBSeDM6VEaaCb2s+329SbjaVKzWGnIqj3QT1WM+F
         XmSA==
X-Gm-Message-State: AOAM531nwJMwWs21SRFfluHFOtpEgjJIWobkBEQ1tgEVtJm2FCenhTOW
        IwW6LLNq+JQSBnKU1KMyP8ogwE7CW9g=
X-Google-Smtp-Source: ABdhPJyfBLqnqzskS0IIzPUGTV3XEMGsSzfOqiAQw8PfcsTp/UmNGnYBhojkld+dv1NPLNIXHclMTA==
X-Received: by 2002:a17:902:7606:b029:d4:c797:a186 with SMTP id k6-20020a1709027606b02900d4c797a186mr1360034pll.38.1606169714951;
        Mon, 23 Nov 2020 14:15:14 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s4sm362016pjr.44.2020.11.23.14.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 14:15:14 -0800 (PST)
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: add bindings for
 xrs700x switches
To:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-4-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <63f77359-3475-e37c-395e-26039856927e@gmail.com>
Date:   Mon, 23 Nov 2020 14:15:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201120181627.21382-4-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/2020 10:16 AM, George McCollister wrote:
> Add documentation and an example for Arrow SpeedChips XRS7000 Series
> single chip Ethernet switches.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
