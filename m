Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C71A1257B4
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfLRXY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:24:56 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45448 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLRXY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:24:56 -0500
Received: by mail-ot1-f65.google.com with SMTP id 59so4535133otp.12;
        Wed, 18 Dec 2019 15:24:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dELFswO/ZamTfaCN5XxodoQpvZdOkZM8MbmQEsadND0=;
        b=IVhU+NsrrR4AupUkIbPzUhMuJAq9PTyz+EMBBlRXQTOWzSeNig7RED/60+8cS6PX0O
         HvTks9zfG+Ym/S+S24l8yRW02y5xnJgWQpJxiQW37iUFkCBUQq2hZjoqc7Mh+dT8ouqW
         E9SUNwwTYZnuRGObBBsUyNGgpgPftnFhcOtbq/y0CNB9LfPG4Q1L0870pJKYWgz/G6PC
         o+NcYUuFA6K/bq62mdcAtjt3ZbcB6NOU0zxs5FcFOvhfCeZJZHODJTDVEEvghh5lBa8U
         N0DrnCUkYsGxWely5pElmsRbBN7VP+4Ro2oMBr8p0nheWDvZ+upSSN90PP0OMDHOeLYF
         Gghw==
X-Gm-Message-State: APjAAAULbPLGR7aVXbZ9WFLC6amsAxsO2EGS11OsgphzD2NvWKjLPVbC
        WtkxZBVoycBXJI66x03VkSpr9tnyiA==
X-Google-Smtp-Source: APXvYqzHyWcPfEyL2EH+lh3tYRLKLa8Bfyz/wUmiKWWg1qLqXOiPu4DAaIA4Yfl1oR1eEiVXugQmNQ==
X-Received: by 2002:a05:6830:1716:: with SMTP id 22mr5695216otk.229.1576711495116;
        Wed, 18 Dec 2019 15:24:55 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j23sm1320099oij.56.2019.12.18.15.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 15:24:54 -0800 (PST)
Date:   Wed, 18 Dec 2019 17:24:53 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/4] dt-bindings: net: dsa: document additional
 Microchip KSZ8863/8873 switch
Message-ID: <20191218232453.GA23039@bogus>
References: <20191218200831.13796-1-m.grzeschik@pengutronix.de>
 <20191218200831.13796-5-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218200831.13796-5-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 09:08:31PM +0100, Michael Grzeschik wrote:
> It is a 3-Port 10/100 Ethernet Switch. One CPU-Port and two
> Switch-Ports.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
> v1 -> v2: - nothing changes
>           - already Acked-by Rob Herring

So you need to add the ack to the commit msg.

> 
>  Documentation/devicetree/bindings/net/dsa/ksz.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
> index 95e91e84151c3..a5d71862f53cb 100644
> --- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
> @@ -8,6 +8,8 @@ Required properties:
>    - "microchip,ksz8765"
>    - "microchip,ksz8794"
>    - "microchip,ksz8795"
> +  - "microchip,ksz8863"
> +  - "microchip,ksz8873"
>    - "microchip,ksz9477"
>    - "microchip,ksz9897"
>    - "microchip,ksz9896"
> -- 
> 2.24.0
> 
