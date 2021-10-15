Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14D642F9F0
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242214AbhJORSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242134AbhJORSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:18:35 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71760C061762;
        Fri, 15 Oct 2021 10:16:29 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e7so9190528pgk.2;
        Fri, 15 Oct 2021 10:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nNU/Jlv2Z8cbVRwF3uZFRercElyzOMBVYw9cMxYKxuw=;
        b=hN/4clyKdcquXclbvcXDjifrAC5C7tXFpaOABzlWCNUeB7sx8GJeIIVfww1oE8qv5b
         liFfVLF6kf5FaPoagCWeN4ED+NNt87xy+h3F9v2hN0aG+Lk75pi60xImfJ7AtKfVFGLI
         snkxk9OQ3XvTt0pV9TWnmd7HRcfN3b118uryDDLR8jQ1Jb+bousljKcKYdeAKOAlR7Cu
         /yTJhviiRaBHZjQY4Dq3I3edtMrplcdNHTruH0ilE2WzratxhXS9xfVXB2SCIenI/Rhm
         l/1fHaD2mc9DAgia0NJIzQD2JKH6n6RS8A7sJLFyvwpA1yHnHa/ESWWhA/oK/Ep9MTpP
         qR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nNU/Jlv2Z8cbVRwF3uZFRercElyzOMBVYw9cMxYKxuw=;
        b=bzbudXyAM+el9NNVNrXde5DUA+68Bn+uPyYfmPYJ6UXu3AHtQnziFbwzHZ0d4Q/oX6
         X/b5hunxlPDSPfptj0SYLQvb/85CXWfary6CXnqGb9hW/mXhvNSZiFOf6SaQuJ7X6S9q
         PWG6r+NKT6s/9MHY/lP35vuyyfZqJBo0jaaBCK8jzgzsagN7uUgDYatPYjfnzMoCBg2j
         CyNknU0CpY6EMMdqHip1jvp0J9ueOs28B46CPqtEgOfqoG5lm8008lV+kGYekHmNlbsN
         JsLe/26BL8u3EvB8qsU6K1TeJGUGya51E2ajtKpClouwN+/cxa2ij0mNPKKDsV7H3W0M
         PVaQ==
X-Gm-Message-State: AOAM531O56eIzzaqMA6FBWkMPZnjA4/3M0Qr+jCY09T6NtklxgEADD+K
        Ve8WlOGRnYXHgGVtKAW/HCw=
X-Google-Smtp-Source: ABdhPJyeVQ4RBcDSAtV/MP8O6OdXDyGXgWtMA2JJsP4mR4E29TlsXLxOlQ5lyi8886/0iXwWwGcyVA==
X-Received: by 2002:a62:7506:0:b0:44c:efe8:4167 with SMTP id q6-20020a627506000000b0044cefe84167mr12897706pfc.59.1634318188961;
        Fri, 15 Oct 2021 10:16:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k1sm5262100pjj.54.2021.10.15.10.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:16:28 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] ARM: dts: imx6qp-prtwd3: update RGMII delays
 for sja1105 switch
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <531b85ec-4227-85b5-f1c7-206f293ec0b9@gmail.com>
Date:   Fri, 15 Oct 2021 10:16:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013222313.3767605-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:23 PM, Vladimir Oltean wrote:
> In the new behavior, the sja1105 driver expects there to be explicit
> RGMII delays present on the fixed-link ports, otherwise it will complain
> that it falls back to legacy behavior, which is to apply RGMII delays
> incorrectly derived from the phy-mode string.
> 
> In this case, the legacy behavior of the driver is to apply both RX and
> TX delays. To preserve that, add explicit 2 nanosecond delays, which are
> identical with what the driver used to add (a 90 degree phase shift).
> The delays from the phy-mode are ignored by new kernels (it's still
> RGMII as long as it's "rgmii*" something), and the explicit
> {rx,tx}-internal-delay-ps properties are ignored by old kernels, so the
> change works both ways.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
