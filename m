Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DDB227280
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 00:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgGTWtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 18:49:14 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37628 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTWtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 18:49:13 -0400
Received: by mail-io1-f68.google.com with SMTP id v6so19371299iob.4;
        Mon, 20 Jul 2020 15:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LID56iHwZMP0VoZCB6NI9xhlSxo80lQVl96V5jSbArE=;
        b=G7dgkLLoWvID//D1GQedGbnYLCD1BlfO36Y+0U3cD+PbWMgF1ZzxsLMlIjtQyyrnW2
         wazrP7mVg6TwcpiBf3/mzi5vkauRrwycsg7ZtCAQMh7PVYaz18duNwaEZEYntN1VxuJG
         RM5mxuQH4RctYtjfRRBFyYE6IICbEkAQUG02RoJwlMc2CVr8LygMGzvvyKcfeAUxlsyq
         rT15/szlPBBYTBGXdfSn9Z2+8X3OKuRCEJqRXHxyaxyOY8wfy5vxttSNKE9Hg0impsC6
         msBkQFpXfd9XpqsJCIYXECl2Cr8kLd9W2rm1Z7S/xTOK49N8e3WGTRksBLx9iDFv9J6q
         8F9w==
X-Gm-Message-State: AOAM533XTk8JegNiDGUzYix2YWHl3sDH6WCbERDqyyWOTpLEDF+jHHbG
        tvlGRgo+oBUPQgGh78zMSQ==
X-Google-Smtp-Source: ABdhPJxsZ1/O+yZSWlinkffOk4WHkw8nlWSNtNLvOLRgbe2vt1jf34WKMe0ZpImwH9bcGfdNWStJEQ==
X-Received: by 2002:a6b:1449:: with SMTP id 70mr25146746iou.153.1595285352861;
        Mon, 20 Jul 2020 15:49:12 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id z9sm9660322ilz.45.2020.07.20.15.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 15:49:12 -0700 (PDT)
Received: (nullmailer pid 3092500 invoked by uid 1000);
        Mon, 20 Jul 2020 22:49:09 -0000
Date:   Mon, 20 Jul 2020 16:49:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, ilias.apalodimas@linaro.org,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v1 7/8] dt-bindings: Add vendor prefix for Hirschmann
Message-ID: <20200720224909.GA3092466@bogus>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-8-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710113611.3398-8-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 13:36:10 +0200, Kurt Kanzenbach wrote:
> Hirschmann is building devices for automation and networking. Add them to the
> vendor prefixes.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
