Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F1325C6C0
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgICQ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:27:34 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:37508 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgICQ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:27:31 -0400
Received: by mail-il1-f195.google.com with SMTP id b17so3232840ilh.4;
        Thu, 03 Sep 2020 09:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9G98cfjW4ih1yFceyrDYIPmmPkqEkBCla9yvtnV5LIE=;
        b=lntn1xn3wyOiHo1vH0X1kaZqX2fI1GiLVXRz7N/WsGQGGP7vxCZYHSNvSKbRJZAyKa
         /DD/Q6gNEkYi9rkqsTtRUhoMMVAQ98WV+7zuuGz/b5nF/3xUxxFmH3wJyfSqYATxiDxi
         2RHHfBZ9359h+8jmEMyunoMNLJG/4ngb8wHehQCO+M9yD+hahDONZGvFRTxoG+NjaXW6
         jOmY/6eOgiPK6aS8He5ieWkI2/zkDVGOltY7Mjf6k65gsuyPWM4k+bqKJkfqnxM7fA0w
         0Lgs5Wx2eB6bDjFet6U8BaibVrhongXF9ToQKXWY8DeLFk146T7/o7YpGXoipIRp7sOX
         ZgMA==
X-Gm-Message-State: AOAM530jhPJwYrBuBvvh40Rx48xMI2bB3afrNtIZTleLylWsr6M6YbdA
        O8Ij9EKNq9UDU3MtYFbo3Q==
X-Google-Smtp-Source: ABdhPJxxbct2d3ddoVws+fKjDW+qICkONjrnKzFv1HfUla5MUydvbOOhCB8mdR0rnejmvu5DfbUdBQ==
X-Received: by 2002:a92:1597:: with SMTP id 23mr3977476ilv.206.1599150449960;
        Thu, 03 Sep 2020 09:27:29 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id c7sm1631160ilk.49.2020.09.03.09.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 09:27:29 -0700 (PDT)
Received: (nullmailer pid 2898742 invoked by uid 1000);
        Thu, 03 Sep 2020 16:27:27 -0000
Date:   Thu, 3 Sep 2020 10:27:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        ilias.apalodimas@linaro.org,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v4 7/7] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200903162727.GA2898615@bogus>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-8-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901125014.17801-8-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Sep 2020 14:50:14 +0200, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../bindings/net/dsa/hellcreek.yaml           | 127 ++++++++++++++++++
>  1 file changed, 127 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
