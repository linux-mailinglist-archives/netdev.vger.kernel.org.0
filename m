Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A51C214F97
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgGEUuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbgGEUuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:50:12 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A3CC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:50:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d10so2495612pll.3
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TmEpPocSVj4bUhJjAMJaUjV5Vr4H5d2YKw7adlNzK5s=;
        b=bBC4ZbxIWLFUodvB73e/Z4DwKSlaYmaxl4LPl6+hqU9VSfbwm2F9sy02E3QwdwRiiX
         nlV1isPApdWtvavz1rYb4Fu48sBsjGJWcMkKJYZwgjEbc0SNAucnNGNF7fyBDdTbEKSw
         RwGk84ve/ttfoXpx8mmGuD/vFc8p7owux83WG2kMX8vgHokb58J0BJkdezkFsQTJO3U2
         SgyoOu+nItAMqp8xNoxQLc7367IbdaQvXnoD7OH2reKcMqJXrSaL272KCgFipVneOabr
         QnrVwh5yN0TJnVFCyYwxZ+M/2Eb2E43SqzA/ue1QXc3/4lmHAb3OY+9yNW0z1zOiVhuv
         dUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TmEpPocSVj4bUhJjAMJaUjV5Vr4H5d2YKw7adlNzK5s=;
        b=C0Wap4kUpFr49QqzpheO1K+yXnIrQyURolf2QQCVdwiE7l8NZzs3uHTF+cBTee/983
         O8gqu7OskhmGEhleLW8VyubTofBvfp4V/+uFAfA65LqjpCqavqFqipUUn8SAT5d4iLGY
         Bvl8mzLseVX2rbV9y6FbgM7m9ynkQ3QsXXi0Ox1vFGwME1ZZgF6zvVKyKp7Svi5+j0r7
         6RX3uPTBit02G0ZTFi4OUmh26xLJQpagaEXawbCUW0xHm9Ip+hJw3OQPc2NBsvLxJpgQ
         JzNzVShmA1fhfV4wfi88ssXRyHn0i4o1WGIIvm9frXdvPyTLb9es4h1R/vdjBBZNJl4l
         6LFQ==
X-Gm-Message-State: AOAM533CT5WuGJ9yBZehXpxHRhCaMRBLJUzHhILpZLKEDHe1tDJZIFiI
        WShTZjs7y6y6WZPym8/8ib4=
X-Google-Smtp-Source: ABdhPJyz4N5yK1xEMg82kDtge7+RcfGoIqJ0Pzo99URnce1LFasw/j9mNDSnK3dsWEJBIhJEZBRl0g==
X-Received: by 2002:a17:90a:ff0c:: with SMTP id ce12mr49146876pjb.100.1593982211712;
        Sun, 05 Jul 2020 13:50:11 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id t188sm17692404pfc.198.2020.07.05.13.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:50:11 -0700 (PDT)
Subject: Re: [PATCH net-next 7/7] net: phy: mdio-octeon: Cleanup module
 loading dependencies
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-8-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <18acb74f-d592-d822-7110-32a50f401154@gmail.com>
Date:   Sun, 5 Jul 2020 13:50:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705182921.887441-8-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> To ensure that the octoen MDIO driver has been loaded, the Cavium

s/octoen/octeon/

> ethernet drivers reference a dummy symbol in the MDIO driver. This
> forces it to be loaded first. And this symbol has not been cleanly
> implemented, resulting in warnings when build W=1 C=1.
> 
> Since device tree is being used, and a phandle points to the PHY on
> the MDIO bus, we can make use of deferred probing. If the PHY fails to
> connect, it should be because the MDIO bus driver has not loaded
> yet. Return -EPROBE_DEFER so it will be tried again later.
Do you also want to add a MODULE_SOFTDEP() to ensure that mdio-octeon is
loaded prior those those modules? This is a hint for modprobe and
libkmod but it would be nicer to have. With that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
