Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D27F214F72
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgGEUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728214AbgGEUke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:40:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B23C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:40:34 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k27so1352631pgm.2
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FHhNSRQAJo81LBFTiS7XaNO8EInY+4Q7wYdQHPp5Ups=;
        b=KKV/i6bxpGaYB7fRZc0L0bKQhVX13L/EI+fxBAQH0F1bvumtJpf6j2LwWIc+96Zx2u
         QMLc6pBdwMmwX1Yzqbnyl5czR6rJNJaogND6qV2arf8gtv03T/B9gqzqhi3ice6VYuzy
         6hCxZSjeJ/aLDdq87ZTwC48WRlyVnw5Yl7NGd2AZM4N0yvOJk+1608SbZ/Bi7xnfevl0
         dYSaWufzUcLftUB+x2Kv6dvosqdzstNjL9ya6mGzcsS5E0tBhGEO6HTA5CciNHkxnbtR
         rjkC6raHuSjcbN8rW5RWRDU4gRYa+Bao2y87ZOXJ1CF2EyStx+8lasYR7TKYc+3T5IRA
         eqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FHhNSRQAJo81LBFTiS7XaNO8EInY+4Q7wYdQHPp5Ups=;
        b=HaaHgNaY13xl5JgakG5tx+NwkbXG0Mg9CjsVadN/Jp3gNzaMXlcG23bODXINL0dhF6
         Cg7bWqHoHuGHamk+PrgZWCRF0XjM9Tw8YzryRW+gYb2BuPlyylV+SFzHg8MocQdF2f3/
         MFkZjyaNR3TGCQdCWNlyjqFc3ZykOCSr8ybkFf2MeNwx85IiTnzxxvjPmsG1MSZuwd2E
         /yVGOgdDVlVQer0qmFhAsJ4P8rIR2H8cmDsb2zrWJOHeQwNSEdsux8l08EgZJf9KnEaA
         FN8UCB9mpw98WQ+mN7ayF0OSSQtX5RJpm04Z0ttfybXrVhlKlOTzmfolviskaxG3e+9g
         eEFg==
X-Gm-Message-State: AOAM533fLxOROB4sDgEyMHHte8kQ9JuY3Qo+7nZrewvO7tkzQTh5bU7L
        zh+IHmiPqlg0kay89Ef42Qo=
X-Google-Smtp-Source: ABdhPJwFdf6yhT9IQWIQ6cZYjVJLgkUCC2RDim4amim8K1zxal1bV6r0i6x0S8Gw8GUXUgiPj3RssQ==
X-Received: by 2002:a63:6c49:: with SMTP id h70mr37377797pgc.150.1593981634171;
        Sun, 05 Jul 2020 13:40:34 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id c19sm16263027pjs.11.2020.07.05.13.40.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:40:33 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] net: dsa: Add __precpu property to prevent
 warnings
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705193008.889623-1-andrew@lunn.ch>
 <20200705193008.889623-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3e0c5980-e521-7e78-3b76-6a301c1ff182@gmail.com>
Date:   Sun, 5 Jul 2020 13:40:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705193008.889623-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 12:30 PM, Andrew Lunn wrote:
> net/dsa/slave.c:505:13: warning: incorrect type in initializer (different address spaces)
> net/dsa/slave.c:505:13:    expected void const [noderef] <asn:3> *__vpp_verify
> net/dsa/slave.c:505:13:    got struct pcpu_sw_netstats *
> 
> Add the needed _percpu property to prevent this warning.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Subject should be s/__precpu/__percpu/, with that fixed:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
