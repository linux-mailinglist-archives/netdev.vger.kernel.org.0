Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B853E1127
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 11:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhHEJSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 05:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhHEJSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 05:18:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB3CC061765;
        Thu,  5 Aug 2021 02:18:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mt6so7225525pjb.1;
        Thu, 05 Aug 2021 02:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZwVoN/DI9XW1PFvWC8iFcWp68xBNJWcGRgCDQYYughw=;
        b=FR5RGyfUSND4F+gmoV9oK380dxTM7+ziCHumx4TBxTt6bi1b6SMISZ+Tgw5TKasDR0
         bVjwAf9p6D1bugYEFB7+c1F17/uLJ25a1RTM9tUDO1JKDhadgjAP0sIiw5w31ADzrwFX
         ycqgZrXjPEJk4i1rqXDYq+1ZVheRFJ+c4PDGmiDmV5+AVUf4hO2ArjtScS/DCYovjUoH
         BZx/M5IPR1b2YvQoA+rRUJuMMzSresa7T8zDtc256V0ZjMJnJEaIhXoay7VDU8Hgjd5U
         CZJ2Z2aO/MOqErvpGLZKqJbaJj7ggskmjKe1QOOF631KNQsvpCrPbongWu0LYSKIRyor
         Y+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZwVoN/DI9XW1PFvWC8iFcWp68xBNJWcGRgCDQYYughw=;
        b=BiYpfoFKM+W+lX3L37U3ctL7mrgs5JoYpov+edmUOlX9Ya5oq11oaBKyFhCwk4Ckk1
         prdYgMmoMjUpmXTkJGglFufBqwPPSrky+ZSWQeDWe3UVUOGjDd/rlrWZk/HGhXonwlGa
         MkMz0MahQfITT68o2ravJc3kSbHIXmeV1q5516oiyPLw8fsPVPQymn3cwidzLpDIx7Uq
         9rcr3qscOTcKbrlbYp/MQkD74CdRrDOXKqStc5em2TBW3s4c3i+DYWqwlz29quS1p4F+
         /V3OJSOqNGkcdt8hUiVsvy8z8t55SYwEQqdWvQSnATSQ1VDaW7h8/H58lOBnymMS4J0y
         c8yQ==
X-Gm-Message-State: AOAM531GlJSn7yEADNhO2W9a7u5VKrfGWE7b3ZXKoD5QATTcR5v8HOff
        hWLvNIGwiMMunXRY/116/7o=
X-Google-Smtp-Source: ABdhPJw8fzKyJU1taP3hkSUjNczdllqZhha3EOq7EN43CuiVgY/sEQz0EF8oBb8Tq+7Uk3Cbu7LIHg==
X-Received: by 2002:a63:a902:: with SMTP id u2mr754513pge.123.1628155104681;
        Thu, 05 Aug 2021 02:18:24 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b8sm5220826pjo.51.2021.08.05.02.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 02:18:24 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, andrew@lunn.ch
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
Date:   Thu, 5 Aug 2021 02:18:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210805074615.29096-2-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/5/2021 12:46 AM, Joakim Zhang wrote:
> Add "fsl,wakeup-irq" property for FEC controller to select wakeup irq
> source.
> 
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

Why are not you making use of the standard interrupts-extended property 
which allows different interrupt lines to be originating from different 
interrupt controllers, e.g.:

interrupts-extended = <&gic GIC_SPI 112 4>, <&wakeup_intc 0>;
-- 
Florian
