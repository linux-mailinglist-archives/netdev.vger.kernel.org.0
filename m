Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F60D1BD3CF
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 06:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgD2Epj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 00:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725497AbgD2Epj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 00:45:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFBEC03C1AC;
        Tue, 28 Apr 2020 21:45:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z1so524368pfn.3;
        Tue, 28 Apr 2020 21:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Frx0+RVrpCm9DrSh7gxAlCtwmgKX8JfrCAnMDtlrdNE=;
        b=BpfEeS4WE7I8omKbrjjEurzs0fV+ajJ0sWlfEgKCcR1dYed6MPouUTWcZwRxdoxjT7
         ZR6J9JtrCqPc/XYOjrXZMLcicPOSkvAiqR1AUACpT/96BY9nYhZQ9En4yNnEiAL/rASo
         SdD/dzvyMVKiijX/TFWkSRoXSf1jA/8r2uyoNH9aUreLL23rKz5oxERGtE2LQTFs9u3m
         i2oKqXlS5KJkf911nEy68hYKHzJZqY+wUO0rU83jWoHDRLAdGfco7ud+b2vP0brhwV94
         zWbLskLZsKwj/kJipRi9hBydqP2oyzBMurUuPEhcGuaVxufNuQ3vWIZyJ10GNnw75XYx
         /zYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Frx0+RVrpCm9DrSh7gxAlCtwmgKX8JfrCAnMDtlrdNE=;
        b=fQHuPjWwIIqHosq2wFaS50SvAQq3xbu8s2iJrMc+mmkBHNueVwmd2Zchw09JpL5Kp7
         zrouPqj8jIvletUIevlU4dQkG1IQ9rW3qd52nBw5MhzcwdlZVhxHAY43dxOp8bcB/1/5
         SDijqtKTwXHUpufjHYTgB/QfrTmVO54SQfLVZbG8TccWI2x4uqG3YroGpiH54l2qqmJM
         R4IER0tNNv8qrOdaH8hrU2193+tuyKKQvVVHMOTEuDauiSKNNvQSEzHzB2gFCzdp5F+2
         42Fe8UXndQ6SNyNKbDielAKLkDt/1BGrwf+o8CN7ZLrepUlO2YPoRhv5kQxOwp9A59ZQ
         s3mQ==
X-Gm-Message-State: AGi0PuY3a8vgk3CKyld2EmQXLVY/V3XHjMqoKPUJJ3L9IXn09gM37YW4
        QX7nV/H8doI3PBYGY4AWAXUYcfrs
X-Google-Smtp-Source: APiQypKs31ho4VlbCpyXSAcMqugR0nNSNbIPS2pP8dUX5rZzNEwu/xArSb1bZlNP5kYc6bhouuqs0A==
X-Received: by 2002:a63:214a:: with SMTP id s10mr29602200pgm.98.1588135538000;
        Tue, 28 Apr 2020 21:45:38 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z190sm14354403pgz.73.2020.04.28.21.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 21:45:37 -0700 (PDT)
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        David Jander <david@protonic.nl>, devicetree@vger.kernel.org
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de>
 <CAL_JsqJgwKjWnTETB1pDc+aXVYp0c-cYOE6gz_KYOn5byQOKpA@mail.gmail.com>
 <20200429043808.jdlhoeuujfxdifh7@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6478a83a-895b-5cc4-0104-1900c8374d7a@gmail.com>
Date:   Tue, 28 Apr 2020 21:45:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429043808.jdlhoeuujfxdifh7@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2020 9:38 PM, Oleksij Rempel wrote:
> @Rob, thank you for the review.
> 
> @David, should I send fixes or reworked initial patches?

You need to send incremental patches, once David applies the patches,
they are part of the git history for the trees he maintains.
-- 
Florian
