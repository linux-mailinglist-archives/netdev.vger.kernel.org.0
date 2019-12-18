Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78442123D58
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 03:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfLRCox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 21:44:53 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41486 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfLRCow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 21:44:52 -0500
Received: by mail-oi1-f196.google.com with SMTP id i1so326102oie.8;
        Tue, 17 Dec 2019 18:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YWi3K95SEBeRjnRWdOK8Q10pTSn780ACt51k9yfRaVQ=;
        b=uEM2uJKscLsW4BGK+h1L5KosmppEqpFqhf/nEyRZEazhQQTxrTVkL+x6lE/qePg1RB
         Ss/6QlSPbg3jXY3Jh/93xYH2VJ0xP2eL/kOSBj8Cr1QbO1uIN+OsB29Cncf60OAhJR6e
         Ct6Nt6mbYPG/DqdgZMBijlnXJuUAXRV3Q45CEPJPlQETUIPIkmnjFXTfM9r4FgqF1LRD
         fRM6yFUSA03051I9m4odXihLrd47e78yzXZZ+2fb/7cKtkjirDRXOVe15NPrOVfsHx4n
         uZRwBLG9kmVtZuz7ym8ZQWtSCZAn+1E6aj773fl2/+zOTGjpMSny/3IEoNDpGij8f7ne
         Lwcw==
X-Gm-Message-State: APjAAAXk+X2neKX8ZQ6xCXVVHdeaoX8eU0AfYRUfJ7pO+rm6tIKfwP1f
        ByHTQqItxNGbdFIQC+JUBQ==
X-Google-Smtp-Source: APXvYqwbuB7pYmy0hdiMv22z/UrvUpDb35O8l0zgFDaeOBoJW3aVKuVSZpMkhpjI26lPsEtoxw2/jA==
X-Received: by 2002:aca:2b1a:: with SMTP id i26mr172079oik.64.1576637091733;
        Tue, 17 Dec 2019 18:44:51 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m7sm286278otl.20.2019.12.17.18.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 18:44:51 -0800 (PST)
Date:   Tue, 17 Dec 2019 20:44:50 -0600
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
Subject: Re: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti,power-gpio as
 optional
Message-ID: <20191218024450.GA5993@bogus>
References: <cover.1576606020.git.hns@goldelico.com>
 <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Dec 2019 19:06:59 +0100, "H. Nikolaus Schaller" wrote:
> It is now only useful for SPI interface.
> Power control of SDIO mode is done through mmc core.
> 
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.
