Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A109C17EA2C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 21:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCIUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 16:37:14 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44402 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgCIUhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 16:37:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id v22so10954672otq.11;
        Mon, 09 Mar 2020 13:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1n4yXD8CThTOxD2EDR7I2aRpPsppUZVF3HLI87zQ4ZY=;
        b=go0dVBjgRN87R/f7y7T8y5AItvvdkRgUs/xYZe7kqzytFhavX9tv46YfeTf1uJ3q5g
         UJAzixwSlwm2K/WibdZpSMLNEGhZLBSbgfG/rEdbNHxrWBrU987sQV4/49jsgX+/h6Qc
         wv6eRlqPQjDxThE57/yD9LfkiRG+Xe3FNzagfeeEJ8CDVKh+0vDotqDKQtFaWDV7kF6S
         78nB8tytw2GXXLQ8gBuEfh/LGzKEgBAywJT+jusYs+MksEmVlKZpugNSExTcsEV5uSgC
         rje8OjXy6jhGOktO3tuY8ESosWJytC3PYNvmefT9KzujaKuNwbTyeR0AmLVmd6IOZgYQ
         bbpg==
X-Gm-Message-State: ANhLgQ3hoaGoTRl2IZc4zeIwq7yU68+a+ph3a5legtfoedrShHd1kjBo
        gv33Zew+s5DAzfgJ97pvW7YPhco=
X-Google-Smtp-Source: ADFU+vt7V3uyoj4pVmg02Jxf/Z1VF/kbucOhU+qbtUfrGu4N3GDlO3Br9L3hOmcZncjvzboSC3Tyhw==
X-Received: by 2002:a05:6830:1345:: with SMTP id r5mr987211otq.342.1583786232592;
        Mon, 09 Mar 2020 13:37:12 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w15sm3464104oiw.43.2020.03.09.13.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 13:37:11 -0700 (PDT)
Received: (nullmailer pid 27764 invoked by uid 1000);
        Mon, 09 Mar 2020 20:37:11 -0000
Date:   Mon, 9 Mar 2020 15:37:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        devicetree@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH net-next v2 4/9] dt-binding: ti: am65x: document mcu cpsw
 nuss
Message-ID: <20200309203711.GA15678@bogus>
References: <20200306234734.15014-1-grygorii.strashko@ti.com>
 <20200306234734.15014-5-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306234734.15014-5-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Mar 2020 01:47:29 +0200, Grygorii Strashko wrote:
> Document device tree bindings for The TI AM654x/J721E SoC Gigabit Ethernet MAC
> (Media Access Controller - CPSW2G NUSS). The CPSW NUSS provides Ethernet packet
> communication for the device.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 225 ++++++++++++++++++
>  1 file changed, 225 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> 

My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dt.yaml: ethernet@46000000: 'pinctrl-0' is a dependency of 'pinctrl-names'

See https://patchwork.ozlabs.org/patch/1250679
Please check and re-submit.
