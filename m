Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6881FFA70
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgFRRkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgFRRkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:40:17 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3D1C06174E;
        Thu, 18 Jun 2020 10:40:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e9so3204041pgo.9;
        Thu, 18 Jun 2020 10:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aZyVgZA/aGlFLqfwHIlBa0P8fvi2V1/pQvZTXXNeaVE=;
        b=MrFu2lY/eamgb46QOFZHaNirpy+HavawooId56MrNgqvzUSKR7ewRhGv/krem7aoet
         /hgJ9kKGUfth5dPh5WL5kEn2LBmrqYll/jrUouftkKFUaSU6WVnC87nD2m0prFhoiHhQ
         tt1DD4LmDocHdL5oNA4OYCkue6wIeeeL5z3r5HQmisUSY8HKvOvvlp9ZgEEw996z1W4J
         J3e742IVsK3LRYq1ozjK0Mictz9XJ3C3Cl6+4of7xmy1s6cxklzNeHVrg42P5EjGBAbv
         xVekrHvmBBIpelSygzglCjgriCvYpAYP6rHLWGl7cl6mkpMf7cEzCD4xym3TdXv1wAq1
         VrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aZyVgZA/aGlFLqfwHIlBa0P8fvi2V1/pQvZTXXNeaVE=;
        b=h9THM8G6zL0wCrZwF1TtgVF4oMkyhKkMQz1R3gLaGLbZDA1HHO4M0Pc4CYQzYFj8cI
         oHkwVOgxmmZ583V34DnkwcgNififod636vB7kEsP1LI0+LtGIuclU42TfKoL55QXO6DK
         +iaA10d1cF/6mMqstzQO3xbk5Fwur8zgttL1zgq+z64x4Xx9heRXQn6R9r7NbhX5q39d
         QhZ65cF1zPV8UaXi6eszebHP25CuzpcThLYxrzPhgP04e8m7L7UYPqa9B1cAyM5pzBlq
         al44uhYexuzMsy37CED1DrzAcPlBnV5P2oJYxkRh7BR2L7KkzrztytRPgjQ2CtGwoxY1
         e0kQ==
X-Gm-Message-State: AOAM5308h8QC2KsBwrxSmGkH1V2VFtVQm/l0SAnm+DOutsnYez+6vMJS
        9rVF33MjlpG5ARqmO+F9vNM=
X-Google-Smtp-Source: ABdhPJwd+KzfI08O2Xp/PD5G8jDuv1Mj+T/R8GF07WKyt3RE1f3gawAJRaxCKu+/EZ7C/tvNVqqJag==
X-Received: by 2002:a63:d208:: with SMTP id a8mr4076822pgg.351.1592502016129;
        Thu, 18 Jun 2020 10:40:16 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l134sm3067105pga.50.2020.06.18.10.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 10:40:15 -0700 (PDT)
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-10-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e8085c6a-0b61-60f9-f411-2540dec80926@gmail.com>
Date:   Thu, 18 Jun 2020 10:40:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618064029.32168-10-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2020 11:40 PM, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/hellcreek.txt | 72 +++++++++++++++++++
>  1 file changed, 72 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.txt b/Documentation/devicetree/bindings/net/dsa/hellcreek.txt
> new file mode 100644
> index 000000000000..9ea6494dc554
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.txt

This should be a YAML binding and we should also convert the DSA binding
to YAML one day.

> @@ -0,0 +1,72 @@
> +Hirschmann hellcreek switch driver
> +==================================
> +
> +Required properties:
> +
> +- compatible:
> +	Must be one of:
> +	- "hirschmann,hellcreek"
> +
> +See Documentation/devicetree/bindings/net/dsa/dsa.txt for the list of standard
> +DSA required and optional properties.
> +
> +Example
> +-------
> +
> +Ethernet switch connected memory mapped to the host, CPU port wired to gmac0:
> +
> +soc {
> +        switch0: switch@0xff240000 {

Please remove the leading 0x from the unit address.
-- 
Florian
