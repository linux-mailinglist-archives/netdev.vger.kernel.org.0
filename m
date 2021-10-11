Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05F94284EF
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhJKCAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhJKCAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:00:49 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5AC061570;
        Sun, 10 Oct 2021 18:58:50 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id r1so15078273qta.12;
        Sun, 10 Oct 2021 18:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=secg3M8hKqp7ABXCyHNDCf5TMq7hAKRkIgWu/3F1Qzk=;
        b=SLcUQHHZAl0b8aHzucgOVC4MybPeZ8eZYRcD7q6Uq3JWndQ3MRDv+/qizElziirPEP
         /mPZxZ3+OQhuaV+eLlkzcOuXaWw648uHP4WyG6gjbIxI2SkuA6jSjL1TsplCsOQXA8P4
         VwpsJvUjeyFHesP9UzQ14vZzmmaJdHuA8XBFrTqXvR3T269UmgzcgKs2cmnxpjIoh2r4
         XKvEBA34nQsYII5BJg1OD6X95c3gYhd7DTG2KH1x2ghwe/MYjTk9BfotBpD809WcXA3O
         fFxOYWXKp909BmWPpnyJRUhzWZA1TrGiCV9aPBGXK2rRY8U3YVXN/ikCa7TzaCb5hJFu
         C1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=secg3M8hKqp7ABXCyHNDCf5TMq7hAKRkIgWu/3F1Qzk=;
        b=HXj96+aI1nRNAdmEpbwnUML3Y2BvSsGxUGxO8kGy7CJWe9TGvgAvZSpZmmPl4HkIbd
         qewyMF0DbWwoQQtOmhYxVMjNUxT09ABn3n8uXhwUIDJYwIjqcrqg8vGOxQIysU2gFfvh
         gwiWId5KL63qlERiulXYdiLrbNkblYWY3O+3VtF6TUFYBRsiw9gtCviVmINBgyN3S6et
         Da6H67dZxuPJAW2kTAjBtQGmYlSKtuoG4QqunuOm0H29mwmbgPuNR2kk2c4SnDe8gEZY
         paeMGzn0n1M/fPYXwrvtWb2rQzIoe9BOFkoBVoHGOvr/6QkqWvOySXakEJqWzsOgiVcj
         OfjQ==
X-Gm-Message-State: AOAM532xv+Ue+1+kpnVB3qVsqL6ELFBVXKB35xpmkxxMwFUjHRjy+2/a
        zWvC/fDzowgW+pu9RRwI81Y=
X-Google-Smtp-Source: ABdhPJw+OUtsrIIsHCzWCDzilnL5LgNVNfnPv5p1BVM3nObgYua2rVaKsy1VJo0dfj+XCEBvgnqrDA==
X-Received: by 2002:a05:622a:170f:: with SMTP id h15mr10745291qtk.176.1633917529579;
        Sun, 10 Oct 2021 18:58:49 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:802c:b332:26e0:e0aa? ([2600:1700:dfe0:49f0:802c:b332:26e0:e0aa])
        by smtp.gmail.com with ESMTPSA id bi24sm3655163qkb.33.2021.10.10.18.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 18:58:49 -0700 (PDT)
Message-ID: <9f83b393-22b0-f7d1-fd29-f18acce7a77e@gmail.com>
Date:   Sun, 10 Oct 2021 18:58:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 11/14] dt-bindings: net: dsa: qca8k: document
 support for qca8328
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-12-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-12-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> QCA8328 is the bigger brother of qca8327. Document the new compatible
> binding and add some information to understand the various switch
> compatible.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
