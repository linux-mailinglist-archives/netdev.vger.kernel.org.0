Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6E3477C15
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbhLPTAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:00:36 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:40673 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbhLPTAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:00:36 -0500
Received: by mail-oi1-f179.google.com with SMTP id bk14so242777oib.7;
        Thu, 16 Dec 2021 11:00:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hdOx86AunRNbUWN2dOi5//alRPIt6Fvuf4wwX65N5Oc=;
        b=Bojs2oqFmwF5ksx3clHC5oSUTm+X7iSEZs1yQ6dmV+s3HqusLeZRrQ7gIHKh1KAHet
         uaYs/m5xE8h7W15YpkrCocDrUiA9ndUdvgO4S3UzZtC8QX/d+p9CnD76zvHCIdlSjmBA
         A347sw2b4tUEInCEoEJaXTVvOGDIWCbA4TEGuSkfXD53R2qTx3p0+0Yea/vHZFyz9QQS
         Wcn+GK0ezOqyInkP5YBiDuD7k6UsR/aWYjTrxcPl482AYaQvqGKbElxFd3/MTA1AfKh6
         /z46UHP/4VRGcxDSjllYdiRyTpZZIapoQtyjgxcNarUhAKOZGi+J/9AvAv9SOKKYOe7p
         MQ9A==
X-Gm-Message-State: AOAM532iS+KZqTbHTKnG0Qp+WKEiR3fUXPJ+96Kyplfhzf/4g02Skvy2
        cdvY7f7VcMm2gE/5nfaKdCy0oEK2Zg==
X-Google-Smtp-Source: ABdhPJxAA4FqZcDNMQTzkF/3ZR6S8qz6JUkvnHqI7g0Ovfj1rOvdACXNg5MWTpSmXQn689kW3sAbnA==
X-Received: by 2002:a54:4792:: with SMTP id o18mr5188122oic.27.1639681235367;
        Thu, 16 Dec 2021 11:00:35 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s17sm1183485otp.20.2021.12.16.11.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 11:00:34 -0800 (PST)
Received: (nullmailer pid 570381 invoked by uid 1000);
        Thu, 16 Dec 2021 19:00:33 -0000
Date:   Thu, 16 Dec 2021 13:00:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Message-ID: <YbuM0fLCo28OPPhg@robh.at.kernel.org>
References: <20211215030501.3779911-1-davidm@egauge.net>
 <20211215030501.3779911-3-davidm@egauge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215030501.3779911-3-davidm@egauge.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 03:05:12 +0000, David Mosberger-Tang wrote:
> Add documentation for the ENABLE and RESET GPIOs that may be needed by
> wilc1000-spi.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> ---
>  .../net/wireless/microchip,wilc1000.yaml      | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
