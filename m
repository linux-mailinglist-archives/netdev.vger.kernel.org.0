Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754132477A4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbgHQTvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbgHQPSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 11:18:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805F9C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 08:18:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so8372494pfp.7
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 08:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0HMCwkrsLMt2hHMkkWD8fqqwc4lL5NXGlSxlPBlN8MU=;
        b=VoEcscRjiLZz8kBarANNcpClEd+NmFdtBTbVWG3ho+mxA1N8ukbzYk3YV6w5sfoOYC
         CqwB62n4bIELl5+IE66k0wCOTYb9sOYmDPkc/opzAN0qMwKwtQtC5hWIk0rJxMaE7qL7
         ARUqlygMU3XN8DHCAEh0itD4O19+RQOPYUYHgZmUsxJ62qTDtB4OMOezqgK+WIrxuQZD
         928MOyj4g+1yuwx3oocsJAkb8wYhWnu8OFIotJ4/VUjbu6WyicdUdKL7fpxHDFUFxqGy
         szaw7TZ/A4/z0LedftZFxByU6BLWF7fWk9S8CItezDuSkQaYYVjZLQ6+Et4cwxi9UmkQ
         j8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0HMCwkrsLMt2hHMkkWD8fqqwc4lL5NXGlSxlPBlN8MU=;
        b=CBAAALWXyXCzCjZ0w5JwPhZH8ZHxPpA1z9M0x3cGulLxZhTCn2jWWgI637u2FIBOpE
         LwL2T3jclTeJZxyOf50l36bRHxQ0xIVV+puhOqWy7LUjlTxCMVGlg1XCUfyQ86xuJCCH
         S0GQ/1Tzjth14QCICSqN2UjACEAGHHVudRB5PmUKBcn8nz/A9EsrjaCQ58bJZvZGC0qr
         J0HrlUIVns9TrOHP1qDzZbttHluW1C+yM5k2x677D0tObEek8B7fTukjcjzd8FWHRY8n
         5b5l9uw74RatTn01dvIyYuVI9qdMm0fhKyG6mpT/DMNKmdWW/gkdLnR+HCXObz6Ypapd
         65XA==
X-Gm-Message-State: AOAM531qRUarbFWH5ft7yhUSQrwCG9MRkkgmchRqRmjFfHfyaHUCUB5e
        mzqHA3eGveDECuBtR2M64AmPZmXavqY=
X-Google-Smtp-Source: ABdhPJw6rIqFSt04bQpPshJ9OPPsRHwHHsprGpoIrY+fzgb1gDR2r4vqBxZ1drSqmuIHYnwzp1tL6A==
X-Received: by 2002:a62:5b07:: with SMTP id p7mr11860623pfb.326.1597677524385;
        Mon, 17 Aug 2020 08:18:44 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e125sm20072382pfh.69.2020.08.17.08.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 08:18:43 -0700 (PDT)
Subject: Re: [PATCH v2 0/6] net: dsa: microchip: delete dead code
To:     Helmut Grohne <helmut.grohne@intenta.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200725174130.GL1472201@lunn.ch>
 <cover.1597675604.git.helmut.grohne@intenta.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <73ba5a2a-786d-e847-598a-20cdeef2e1c0@gmail.com>
Date:   Mon, 17 Aug 2020 08:18:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <cover.1597675604.git.helmut.grohne@intenta.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2020 7:55 AM, Helmut Grohne wrote:
> Andrew Lunn asked me to turn my dead code removal RFC patch into a real
> one splitting it per member. This is what this v2 series does. Some
> parts of the RFC patch are already applied via:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b20a6b29a811bee0e44b64958d415eb50436154c
> 
> All other structure members are read at least once.

net-next is currently closed at the moment, and these patches are 
clearly targeted at that tree:

http://vger.kernel.org/~davem/net-next.html

Also, please provide a commit message, even if it is only paraphrasing 
what the subject does. The changes do look good, so once you fix that, 
we should be good.

Thank you
-- 
Florian
