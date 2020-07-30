Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB15233643
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgG3QEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG3QEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 12:04:05 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E7CC061574;
        Thu, 30 Jul 2020 09:04:05 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id s9so15264310lfs.4;
        Thu, 30 Jul 2020 09:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3FAlPclAAJUPeaquH0F3zuzVHhEiAYktWTdgxNqLyxg=;
        b=l5yxfADWF+7UgfBleV9u3q2R33gIGym9UqKGzwpLmHNShotjVvgmuiW50nzpgbFJZ+
         XT6svmnrorvNIfvTicqJHlBmx7/jvIrZPKMrWTxQ0zdoOsGPnw7n+xRLAe7yEit42rsC
         RlGZmSW6kk5vvnAokbb+wCSi16N5IlkKO3vNy6CbPGZYllrD1M1aUIJ56Awv3Ua1asdJ
         BJ0Hl5aVWZnKvesjJT3Qwtw38JqZhh3PUm1I3D6P8R3onO3Z7kCe1PI1k/mY5yUzsrjB
         a9rPj73K5nMAC17Nixi4jVv+ZpYiNFCaAb6D+82yfB4fmX7qo/1Y1gKZSa8DbJkhSA9d
         kYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3FAlPclAAJUPeaquH0F3zuzVHhEiAYktWTdgxNqLyxg=;
        b=bNObCg4KP3RuHZr+JAKBI3SlHbbiij4jFs4+hekbX0Cgx996xuiWAib6ojPyyu4ol9
         Qb9Zo8WwzKOydShhTqG+y5omPJ+PVv2KTD34uJBoLpa70zOxd5p8qGRJ9CrrOeQWs3p9
         TdRy2yTUf0Q443SDAdHTakWZ6UY8DkYqU7JLqvDyugl5jkE1cu7Ky+0J4Ola/19Yq+6h
         8715Y82WdPb/xhzky3U1STjBx88t39+UjTFJG2eZfoI0Crb7mT5DhcBIxGfnKFgIXi6W
         8BrUvZCF+M5W44v/qF7DtNJKZWAEzmnTdf5YZV/Vc1KPARxtN1A3eGCw6l7bxUpBeb/x
         6k2w==
X-Gm-Message-State: AOAM5304VgffV/03E5HcnxXcUUWYUkTy8XEcSskynLfh9F0dsLlvEa2c
        +BXyipqETNbdf+XIbW4e/x6FSXCJeZo=
X-Google-Smtp-Source: ABdhPJyA36NyGFwXgDeY3DZ9aaKOcZyAMrZLjP1m0fsxq68yN/kMGhOS2NTH+/FKpDKgAy2XnSJnTw==
X-Received: by 2002:a19:1c6:: with SMTP id 189mr2064146lfb.158.1596125043611;
        Thu, 30 Jul 2020 09:04:03 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:217:b665:71e9:90c2:18f2:5bd7])
        by smtp.gmail.com with ESMTPSA id u12sm313074ljl.88.2020.07.30.09.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 09:04:02 -0700 (PDT)
Subject: Re: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <ce81e95d-b3b0-7f1c-8f97-8bdcb23d5a8e@gmail.com>
Date:   Thu, 30 Jul 2020 19:04:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730100151.7490-1-ashiduka@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/30/20 1:01 PM, Yuusuke Ashizuka wrote:

> ravb is a module driver, but I cannot rmmod it after insmod it.

   Modular. And "insmod'ing it".

> ravb does mdio_init() at the time of probe, and module->refcnt is incremented
> by alloc_mdio_bitbang() called after that.

   That seems a common pattern, inlluding the Renesas sh_eth driver...

> Therefore, even if ifup is not performed, the driver is in use and rmmod cannot
> be performed.

   No, the driver's remove() method calls ravb_mdio_release() and that one calls
free_mdio_bitbang() that calls module_put(); the actual reason lies somewehre deeper
than this... Unfortunately I don't have the affected hardware anymore... :-(

[...]

MBR, Sergei
