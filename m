Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002972E8D4A
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 17:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbhACQq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 11:46:59 -0500
Received: from mail-il1-f174.google.com ([209.85.166.174]:34393 "EHLO
        mail-il1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbhACQq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 11:46:58 -0500
Received: by mail-il1-f174.google.com with SMTP id x15so23186993ilq.1;
        Sun, 03 Jan 2021 08:46:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ffZhLDx1ZIXWinyTI5FwjoXv0iSv8x4xy+lWUM9m96I=;
        b=f1N+ZDLkAiSEzBc3JziCyBqkAxayGWKbecZqJ9ZiYKBLgJK5ipailvQNfNVQmKEp6O
         m3mdOwfsdy7rkLvhuqf/JXQ9GGkjYRY+1PuolA2ej5YnQGXOI3vr6MYu0I/nDyPVQYCy
         1v+RygnDgem34HKmRoS++3y2DPxnDa0PN/lAf4dOUqQYN3+PhcmF7Ppct2W+ME1bCPXG
         Wtmj8YQWKHuTEIb5qUxctawmK/LpuJrYEubeugFmGjutlu01uS7kzjh5wS09PBx9TTSM
         01DOwxS/l5EEsAhjPp9jKDDnT55sZHAAgx1iOw1ywB/7np5mPMknMmVjkHO5hoFB660H
         01YA==
X-Gm-Message-State: AOAM531H9FAAAUycumqckjJSVhENhUzzEtIh1Q8eFgC+rPTeqq4oZDVZ
        jYZkca9K5K6D1CIvzHiMwQ==
X-Google-Smtp-Source: ABdhPJzv60vTDLt3yS2Zv96+ngEHZT+oYgJ7gxvHHAcvf71gXzN5bGnai3VRln0CfLhZwOA+1eisZg==
X-Received: by 2002:a05:6e02:8d:: with SMTP id l13mr66933409ilm.163.1609692377840;
        Sun, 03 Jan 2021 08:46:17 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id r8sm38127799ilb.75.2021.01.03.08.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 08:46:16 -0800 (PST)
Received: (nullmailer pid 4022471 invoked by uid 1000);
        Sun, 03 Jan 2021 16:46:13 -0000
Date:   Sun, 3 Jan 2021 09:46:13 -0700
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Robert Marko <robert.marko@sartura.hr>, agross@kernel.org,
        bjorn.andersson@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 2/4] dt-bindings: net: Add bindings for Qualcomm QCA807x
Message-ID: <20210103164613.GA4012977@robh.at.kernel.org>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
 <20201222222637.3204929-3-robert.marko@sartura.hr>
 <20201223005633.GR3107610@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223005633.GR3107610@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 01:56:33AM +0100, Andrew Lunn wrote:
> > +  gpio-controller: true
> > +  "#gpio-cells":
> > +    const: 2
> > +
> > +  qcom,single-led-1000:
> > +    description: |
> > +      If present, then dedicated 1000 Mbit will light up for 1000Base-T.
> > +      This is a workround for boards with a single LED instead of two.
> > +    type: boolean
> > +
> > +  qcom,single-led-100:
> > +    description: |
> > +      If present, then dedicated 1000 Mbit will light up for 100Base-TX.
> > +      This is a workround for boards with a single LED instead of two.
> > +    type: boolean
> > +
> > +  qcom,single-led-10:
> > +    description: |
> > +      If present, then dedicated 1000 Mbit will light up for 10Base-Te.
> > +      This is a workround for boards with a single LED instead of two.
> > +    type: boolean
> 
> Sorry, but no. Please look at the work being done for allow PHY LEDs
> to be controlled via the LED subsystem. 
> 
> > +  qcom,tx-driver-strength:
> > +    description: PSGMII/QSGMII TX driver strength control.
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
> 
> Please use the actual values here, and have the driver convert to the
> value poked into the register. So the property would be
> qcom,tx-driver-strength-mv and it would have the value 220 for
> example.

The LED binding has properties for specifying the current already. And 
it's max current which is the h/w property where as anything less is 
just software configuration (IOW, doesn't belong in DT).
