Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD7A1D9F14
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgESSVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:21:10 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:46797 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgESSVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:21:10 -0400
Received: by mail-il1-f196.google.com with SMTP id w18so304710ilm.13;
        Tue, 19 May 2020 11:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BxKepCnxAnPan9/joPNAvI+aFl02Nb0s1TrAnbr7oJQ=;
        b=N8IMz4h6Aq4fK4YJDeHPOx9goBMhWQmZ9MY2vx127pIK9JAt1vTiJlSn1gXj80Sd3j
         zTImvLn7jGZDqr5A1D/at02zKK4cAvAy8L0VtJ02xFF5VLRcGhVlCCOu1S1KVINSjbsO
         bxyITKkUjtJ/YV7dM4tJo7Bjdrv/zKsThdYJkMwYAy+kPZCOkFWnhSQMTzn8tQE5sV+z
         Y7AD6DBFblaljwshJT4c9jDqrBAJcXH78HEj0KvstOANc4lLYWC/OE2B8PEZRTQpThNE
         Rvei0bAZrZOpTXMWPwnqPr0N6qDPE/LheAVIizV9s0kmIs2S+THxci9nfpb1KVPez22z
         ONuw==
X-Gm-Message-State: AOAM533p0VauNz8yJQoU6F8WxvIS5A2FZZXOOPA/vmNsyvXUwC1mkiT5
        AVcI8VlFxy3sP/TRnQoaWgaDih8=
X-Google-Smtp-Source: ABdhPJyPxlgJYBcByRA709z9iumi95cUnEURRxVMZSA9mrbBZ/PFIbTZ0T+AmNp24FJczgvO1MoY7A==
X-Received: by 2002:a92:d34b:: with SMTP id a11mr314603ilh.180.1589912469070;
        Tue, 19 May 2020 11:21:09 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id h28sm97743ild.53.2020.05.19.11.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 11:21:08 -0700 (PDT)
Received: (nullmailer pid 412848 invoked by uid 1000);
        Tue, 19 May 2020 18:21:07 -0000
Date:   Tue, 19 May 2020 12:21:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     kernel@pengutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v3 2/5] dt-bindings: net: mdio-gpio: add compatible for
 microchip,mdio-smi0
Message-ID: <20200519182107.GA412796@bogus>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-3-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508154343.6074-3-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 17:43:40 +0200, Michael Grzeschik wrote:
> Microchip SMI0 Mode is a special mode, where the MDIO Read/Write
> commands are part of the PHY Address and the OP Code is always 0. We add
> the compatible for this special mode of the bitbanged mdio driver.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/net/mdio-gpio.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
