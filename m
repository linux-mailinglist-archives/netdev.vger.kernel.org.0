Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B770727D613
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgI2StM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:49:12 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37095 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2StL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 14:49:11 -0400
Received: by mail-ot1-f67.google.com with SMTP id o8so5507790otl.4;
        Tue, 29 Sep 2020 11:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2dhtLQGXefJzd+tdjQfXtxZsg30gzHAt+hvhP7pFDE8=;
        b=DT3HM0bgUvTtdJmK4Sff30uoVTNrPmT/t1gsQpuvJHLaTAB70X62ibQdwMzZ/MDVg3
         0Tpcqsw4dyZT3QZFQGdt8OG195tMV4i3LrYo9vjmS7qR0PLQLk8qc1x49UaN8orDjZcM
         siKw6e37qXg/qurDSgBdjWfJhdWAFrUFXbfcJ0KkKFMJt1Yb3qgd/BC4zRMhxkKbymIz
         6NUrpO/RKYj94/puk32dLVwYMSZJW7C14Eu6uIJaGXEOU15OecOymYE0f4KabW8UG58L
         +/j2jUjJQVRrdHuq4LZTpbXCqc3Oq4dk1ox3nCEY0F4WH7JG+oFnf1byvaNPTLwkL5Sw
         hgLA==
X-Gm-Message-State: AOAM533bzg6lnSKNWmpNKp4XvB0eLVvuABdif/+YDjnGHHp/+HUFhYdp
        PWFM6Vd18m0bhHPsH4APow==
X-Google-Smtp-Source: ABdhPJwTwGb1cNh7qPLO/bpNMCPhwNz2oDVlStKPD9KooQjEoEwCB5djQy3VGYkXlWUNwA52GDxFCQ==
X-Received: by 2002:a9d:7cd2:: with SMTP id r18mr3965579otn.231.1601405349395;
        Tue, 29 Sep 2020 11:49:09 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id d63sm1169958oig.53.2020.09.29.11.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 11:49:08 -0700 (PDT)
Received: (nullmailer pid 948703 invoked by uid 1000);
        Tue, 29 Sep 2020 18:49:07 -0000
Date:   Tue, 29 Sep 2020 13:49:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     linux-can@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        mkl@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] dt-binding: can: mcp25xxfd: documentation fixes
Message-ID: <20200929184907.GA948644@bogus>
References: <20200923125301.27200-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923125301.27200-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 14:53:01 +0200, Oleksij Rempel wrote:
> Apply following fixes:
> - Use 'interrupts'. (interrupts-extended will automagically be supported
>   by the tools)
> - *-supply is always a single item. So, drop maxItems=1
> - add "additionalProperties: false" flag to detect unneeded properties.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/can/microchip,mcp25xxfd.yaml  | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
