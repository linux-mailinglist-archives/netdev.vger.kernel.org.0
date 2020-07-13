Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ECB21DA30
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgGMPgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:36:22 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:46730 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgGMPgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 11:36:22 -0400
Received: by mail-il1-f195.google.com with SMTP id p15so3911268ilh.13;
        Mon, 13 Jul 2020 08:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jbp8Qd0VM4i5o2+ZvQtYmlD17b1myrPfM1phWvGO84c=;
        b=f7ET/NFltsDuAI7I+EA8kqQI1AdAOwO84+nlRvKWUMNPOfzxSV3X+a3rUWZmIYXcS9
         eN001FVD60GPZ757JcqwqCCyqQHyCNwufNifYXAxVrWqs7b2IEH0hFNYiodFlepqdHWk
         LjC1A3RGAdIO8qRg0bVnUzxDODedU+Pz7Js0QUaralWG8t1kRxsQ4CeZRKmdYdsB26/z
         vJUiNDBeWt/wEc5dtAvgMnAyeDqycZwN+q1qCHVBvPspZM8LifhndIj5EIdG4dsDXb0U
         9pzznOg+iLPMqFxJH37OgLNoWpBqX3+F+D20i9N5U0kWZ5KolCq8NcDLYMokz/GQ/5Ne
         ejmw==
X-Gm-Message-State: AOAM531KWp7R09zoinC1UEnu/tD0KI7ARZn6UhPrT4ZiqGpkv0evhIDF
        4PwL8Rs0a0ltbdOXrl7zmg==
X-Google-Smtp-Source: ABdhPJx/SwvihlwlXRQkZRbFgjXB3HUvCfuB2zXCyjfPOsn46CnyYzMH4CLgs3SyYCvPxFIMNn0rGQ==
X-Received: by 2002:a92:7309:: with SMTP id o9mr236880ilc.5.1594654581414;
        Mon, 13 Jul 2020 08:36:21 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id a13sm8406011ilk.19.2020.07.13.08.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 08:36:20 -0700 (PDT)
Received: (nullmailer pid 247908 invoked by uid 1000);
        Mon, 13 Jul 2020 15:36:19 -0000
Date:   Mon, 13 Jul 2020 09:36:19 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     devicetree@vger.kernel.org, hkallweit1@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: dp83822: Add TI
 dp83822 phy
Message-ID: <20200713153619.GA247395@bogus>
References: <20200710143733.30751-1-dmurphy@ti.com>
 <20200710143733.30751-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710143733.30751-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 09:37:32 -0500, Dan Murphy wrote:
> Add a dt binding for the TI dp83822 ethernet phy device.
> 
> CC: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83822.yaml   | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
