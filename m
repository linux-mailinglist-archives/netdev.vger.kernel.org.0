Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356AE3E1B67
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241335AbhHESgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241044AbhHESgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:36:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A54C0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:36:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so11685063pjh.3
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YIMav/La51ZrKR78GNIBd1q2L1Ytr3GQcPivgQa/OyI=;
        b=nJrzi2yhP0UKQHFJPFbWT6UwK++Pt+d6epKul13YdgjEVwmlkL5fCx4q6njbmNWIz5
         AfzVBw4yvjW5BOcMIhziOXIkRIGsWxNMR0K7HKO+pu7dXYK2fr8QMJOGAuWMFXNK0wL1
         F1zbgph7VHHteaZmaj1W2j6QQfrgXD+adUN466Rk33cuaWPCZyMUBD7qHpsS5kKSs0uz
         iJBakUSBS2v1opXIZb9e1CpZzrKF6pw3vXnxO/D+swMW+nJ2abjBCQGmpNo5nm7rDwF6
         ggGB4cihjU6egXnslG3O8TVCu/qNQgMIvU9MUQ1aKGGwOWfDfY5Qov4v6hg/yZa90S0S
         B//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YIMav/La51ZrKR78GNIBd1q2L1Ytr3GQcPivgQa/OyI=;
        b=DFnDqBpm9WwWiEW//7g1DsSkuTbqskusXSZ3ldXVtF7UXpBFi1FS6/GC7axDMtGhoj
         7YBFoyhnom/x1VXWOrYqzEjyEO/yEAknxIX/xUUhCZg6lOucBQ+tjQiEfu9ftruPyXjB
         yOVqr43Qz6nTbXlZdfUlNbgqUyFx2Dyt6Q/T9VcnRNQssPS5iCs/WeZtdDGi/mQUa3co
         gJBjh5vCqiC5Rx7nRm293DI0EwrVq0gklo0zJ2k/4o5jAWmzEcpRMOi2SH34PupXrV0X
         5DbBIwgN6EYAh+t61HRO1jxEa+/fFHYjRiG4wyKaq2H3qNskFA3hQWF/543e/1uPnXCP
         R4dg==
X-Gm-Message-State: AOAM530WW181ShujtW5rxipfXDmQbkShCT2T16R9BoJ1H8KDnIj08SKM
        8EHcN6gbc6ad9lPkiZL+K6Y1tg==
X-Google-Smtp-Source: ABdhPJytjIE85GWEjPS6HThNxgBSb9Rqc6SliBd1gG3FpFAZBO3H8U69cXYn3pME9qOhQqDnJ48FEQ==
X-Received: by 2002:a17:902:da89:b029:12c:d398:64e8 with SMTP id j9-20020a170902da89b029012cd39864e8mr5146132plx.56.1628188597527;
        Thu, 05 Aug 2021 11:36:37 -0700 (PDT)
Received: from localhost ([2601:602:9200:1465:3cf3:58bc:1858:688c])
        by smtp.gmail.com with ESMTPSA id o22sm7354195pfu.87.2021.08.05.11.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:36:37 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Marc Zyngier <maz@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        kernel-team@android.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Clean up and fix error handling in mdio_mux_init()
In-Reply-To: <87v94kb6xa.wl-maz@kernel.org>
References: <20210804214333.927985-1-saravanak@google.com>
 <87v94kb6xa.wl-maz@kernel.org>
Date:   Thu, 05 Aug 2021 11:36:36 -0700
Message-ID: <7hfsvng2mj.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc Zyngier <maz@kernel.org> writes:

> Hi Saravana,
>
> On Wed, 04 Aug 2021 22:43:29 +0100,
> Saravana Kannan <saravanak@google.com> wrote:
>> 
>> This patch series was started due to -EPROBE_DEFER not being handled
>> correctly in mdio_mux_init() and causing issues [1]. While at it, I also
>> did some more error handling fixes and clean ups. The -EPROBE_DEFER fix is
>> the last patch.
>> 
>> Ideally, in the last patch we'd treat any error similar to -EPROBE_DEFER
>> but I'm not sure if it'll break any board/platforms where some child
>> mdiobus never successfully registers. If we treated all errors similar to
>> -EPROBE_DEFER, then none of the child mdiobus will work and that might be a
>> regression. If people are sure this is not a real case, then I can fix up
>> the last patch to always fail the entire mdio-mux init if any of the child
>> mdiobus registration fails.
>> 
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Neil Armstrong <narmstrong@baylibre.com>
>> Cc: Kevin Hilman <khilman@baylibre.com>
>> [1] - https://lore.kernel.org/lkml/CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com/#t
>> 
>> Saravana Kannan (3):
>>   net: mdio-mux: Delete unnecessary devm_kfree
>>   net: mdio-mux: Don't ignore memory allocation errors
>>   net: mdio-mux: Handle -EPROBE_DEFER correctly
>> 
>>  drivers/net/mdio/mdio-mux.c | 37 ++++++++++++++++++++++++-------------
>>  1 file changed, 24 insertions(+), 13 deletions(-)
>
> Thanks for this. I've just gave it a go on my test platform, and this
> indeed addresses the issues I was seeing [1].
>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Marc Zyngier <maz@kernel.org>

I wasn't seeing the same issues as Marc, but am heavily using everything
as modules on a few platforms using this code, and I'm not seeing any
regressions.

Thanks Saravana for finding the root cause here.

Acked-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>

Kevin
