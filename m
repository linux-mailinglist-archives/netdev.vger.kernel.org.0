Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196C711452A
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 17:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfLEQv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 11:51:59 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37599 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbfLEQv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 11:51:58 -0500
Received: by mail-oi1-f194.google.com with SMTP id x195so3364256oix.4;
        Thu, 05 Dec 2019 08:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V5CClDsvvWShXeom5UYJJ6CQjYP00jyKXyF2U0f40Bk=;
        b=Q/BPet+BUYV+d6QRJq+97JfxO+clb3gUyCh4yWUrwWrSvGoKLIqrGlFuCfN1ez9Swj
         XrEkCQ6+medZNTQTYl4NPqFKGoYE4ygbLbiqIdTV4jU0fddFhajIe9sUwOwpvI1dmQEM
         CpOfdPOCnZ7mOobPBo7VWdRV6/6YCOMWbvJ9O4obulpEGkopyTOOAugeO4xjk/HlAVAK
         oxP234p9KWhPq4/pNQk4GYMxXQ+TdD0Z67pxuMqd+fGh5RrUuG0VBz7nGIvLKpL6yqlt
         XAU+h4g942EybQlLOB44it86Nv0brLR20jMK+xe2MCeS/RaCwhVW/kV9EDfuZi3AuUd5
         0Qwg==
X-Gm-Message-State: APjAAAUtqXGvg9Ac9tpftFQ5AS/KvkWyzhJfxESKBzDbZtR2SAV3Ka5o
        Y2HGZR++scd8aF0Ajt+7uQ==
X-Google-Smtp-Source: APXvYqxBvsot0cyZ13VBy4GxyGsUKNxaQpkizOPoH/p84X7Bq9kEEbQ3hWUc0e1BHvhCJ+k4DJ1VnQ==
X-Received: by 2002:aca:aa0d:: with SMTP id t13mr8146299oie.18.1575564717419;
        Thu, 05 Dec 2019 08:51:57 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e21sm3723982oib.16.2019.12.05.08.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 08:51:56 -0800 (PST)
Date:   Thu, 5 Dec 2019 10:51:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: [PATCH 1/2] DTS: bindings: wl1251: mark ti,power-gpio as optional
Message-ID: <20191205165155.GA613@bogus>
References: <cover.1574591746.git.hns@goldelico.com>
 <c95e814deed075352a05c392147e9458b0d1a447.1574591746.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c95e814deed075352a05c392147e9458b0d1a447.1574591746.git.hns@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 11:35:45 +0100, "H. Nikolaus Schaller" wrote:
> It is now only useful for SPI interface.
> Power control of SDIO mode is done through mmc core.
> 
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
