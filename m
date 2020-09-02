Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9900D25A4CA
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 07:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBFF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 01:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBFFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 01:05:54 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11572C061244;
        Tue,  1 Sep 2020 22:05:52 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 31so1923190pgy.13;
        Tue, 01 Sep 2020 22:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3L6vzknseRmTv7NN9xZcxpHNrmoOWjCAy8Z0FPY0LmA=;
        b=Bsdl47SWREhTgA94H7ygDHrhHYuYaRc9HkwxgwJgRiWTQyonLA/IdDzYVnrQw9pVTg
         kuMC4I1q0jgDZnNOPM5+tOz7EMvgtPJI4GJ6DiAv5q/yCGSKo6pfBE+DMQU5BhqMXtFU
         ZvaWyNIaDzbZoZlIERQTZnmQIMkIo6DQ+anL/ia8hMxXBUSpIVErL1uTAOFNkTtEXaYq
         ibrVCpNSUiH79+UKfm4G13mwSJY9l5SaDYya15mYEdg4oKzOKn92HMx2KBZldmbt1mx8
         1B732PMr373O/GOmfYZ4+6fJ+4rH2QvGjwvyWuXaS0Gag13Fk3xE0++0PemA+oBILQkL
         m06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3L6vzknseRmTv7NN9xZcxpHNrmoOWjCAy8Z0FPY0LmA=;
        b=RlkvWj2noM2XusoXyuZ2pc+sBleHKe98FerrDkaAo0LLFW2lEtM3GdCMO5LOfZO/Iu
         1FI2TS30iBCICFBFJ+5dhQhOGERwhAqXStb2VMTgF0fYNdtm8FYZzACiTckg3V9Kgzvv
         MTAQ/KSOWb7aLM+z5ToLNYfcCx1L13WdYdjxO8lf+pIH+0FOI3LJ/JGc/RzapAov94Qs
         yEzr72sOaAAcIs3HNYkJKb/bxmwj4hHFabIaUVsQJ/JTkCB+v4S+mb4U88DxChhso4Qm
         Q+Fw39RHgzvl0NlvriCXxmvZz3eWbkloW2P1UIk7oPsyzIDAHbptgTyO1Niymq8MG6gK
         t13Q==
X-Gm-Message-State: AOAM5302WY3bMWb3imGFQwx0Ir4yPUd3Z0Rhw7Zda5aZ2i+zGO86z0tG
        w26d43fSdKAdgn6Tv8kT3awsHwsjo7Y=
X-Google-Smtp-Source: ABdhPJzpWBO7YE9/suJUIVC9P4e7EIhGDDcXhL3tBvNDOfUG479BrgK8h67jwfVbvO3chlWZpKWE6A==
X-Received: by 2002:a63:6d4c:: with SMTP id i73mr601401pgc.63.1599023151237;
        Tue, 01 Sep 2020 22:05:51 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k17sm4056335pfg.99.2020.09.01.22.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 22:05:50 -0700 (PDT)
Subject: Re: [PATCH 4/5] net: phy: smsc: add phy refclk in support
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-5-m.felsch@pengutronix.de>
 <2993e0ed-ebe9-fd85-4650-7e53c15cfe34@gmail.com>
 <20200901082413.cjnmy3s4lb5pfhv5@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a4be65e9-64b6-81a0-4042-34cd024a137b@gmail.com>
Date:   Tue, 1 Sep 2020 22:05:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200901082413.cjnmy3s4lb5pfhv5@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2020 1:24 AM, Marco Felsch wrote:
> Create :) Can you provide me a link? What I can say for now is: This
> solution was used by the micrel driver too and it seems to work. I
> wanted to keep the change smaller/more local because the current
> upstream state is: SMSC-Phy <-> FEC-Host ==> IRQ broken. If your patch
> fixes this too in a more general matter I'm fine with it and we can drop
> this patch but we should fix this as soon as possible.

Still working on it, I found a platform where there were some timing 
problems and am looking into it.

If your SMSC changes are so important and critical, get them applied to 
the "net" tree, your patch posting makes no mention of which netdev tree 
you are targeting.
-- 
Florian
