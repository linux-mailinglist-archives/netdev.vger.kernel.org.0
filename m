Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D6D409AB9
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbhIMRhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243027AbhIMRhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:37:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6166C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:35:55 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e7so10137837pgk.2
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 10:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I8NR9yudfChnSKOUbmx3DBZ58eNUhCPKTgafujvi1J0=;
        b=QX1LlfEgaFiWj6CTJ9GuzIiLgg/R7rHUKvWsgJQ23X/232DzdGxW0Lq3g706Yk5B0m
         yrMGxZt1h/dN846zIuQ9k432uzfLvcHPeOaOz8R1ox35HbRBaf98dmKaG0aXEPnGnhco
         b5XKCjf2rHVAVWEsxF+Ddf+JumZ9ERDq5jRGU2yiLejBRLu382qpysduH9IKlcs7N2KT
         zPXqj9hm5RsWp5uFetC2ivaAZWZKKDxB/gfiiO+NOW9eI3MbydgzGPLe6ZKYS4rrMK8Z
         MmSRe6gjVBjPV5xKBU1hU1X8WzRk6StHmqiUrV+EOLSsyZjJ7nnxPvjWYVbc+2WmCmb9
         zLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I8NR9yudfChnSKOUbmx3DBZ58eNUhCPKTgafujvi1J0=;
        b=RT+zCxDo1yAKqw3j1GxNnIKyYPRhYR+Cfes+1f3dBH5YjFKe+6Fve7KuqAcMsC0YSf
         073gMFbZcs7oL4YqYMHf4t14g9X9OSKUQJXm18gfjY9u11ji9zm1/c+4oHfUQppNEPWq
         YvrBWkiPqLIvNvuC8WbnsasYITgAaBvErJqLjY1r/tvx/Lj6UZMGpnkrwdnDauQ/aujl
         zE2t1zMXz9gAm9xtN1RbCIFoedgChz0IV/G2cCes1Gq5XWum02FBRDqSA9wW1QRejbaI
         CYIBDkey0LZS2YyrX3hjU7B53eTtAGTyjoG/E07YIq1B0ty6YOjmJ5m0/OU/sEyIH78g
         v+Dg==
X-Gm-Message-State: AOAM531RTHu5LTqStW4feqDH7WcdEII6c3EzbpsFZeSAMNxy0Yp6OlRI
        9l2kkwLc+1Cb7QeQE5ftxXA=
X-Google-Smtp-Source: ABdhPJyny/Dk4IUTBWOOI1gZ/OS4QhzfCQ77+C64pG+rkZr7B0ZHS6jE0vZZJ3PT/3g7wGHbQtHbAQ==
X-Received: by 2002:a63:7984:: with SMTP id u126mr12003746pgc.468.1631554555449;
        Mon, 13 Sep 2021 10:35:55 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d7sm9105409pgu.78.2021.09.13.10.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 10:35:55 -0700 (PDT)
Message-ID: <7e029178-c46a-9dbb-2ee4-58d062f6e001@gmail.com>
Date:   Mon, 13 Sep 2021 10:35:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 8/8] net: dsa: rtl8366: Drop and depromote
 pointless prints
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-9-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913144300.1265143-9-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2021 7:43 AM, Linus Walleij wrote:
> We don't need a message for every VLAN association, dbg
> is fine. The message about adding the DSA or CPU
> port to a VLAN is directly misleading, this is perfectly
> fine.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Maybe at some point we should think about moving that kind of debugging 
messages towards the DSA core, and just leave drivers with debug prints 
that track an internal state not visible to the DSA framework.
-- 
Florian
