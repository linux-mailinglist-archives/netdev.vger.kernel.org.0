Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705982EC6C9
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbhAFXTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbhAFXTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:19:36 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483A7C061799
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:18:51 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id w5so3834808wrm.11
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=smuNpjn1omety5y1ZI25Wf6WWShNtH6K3hRtcH4ZOPQ=;
        b=MrzYOhEFc6rvdvyZ94kZink/rMoUmlqM0045xIB5kuBdcK+bOYFqn4JZyrKio+e1x8
         kvyDeS3t7uqDtFUWQ4VwV9oJEIJsDstYGpM/A50F9tJ1mUYbKN9suHRQWZT7Stcq0Edy
         VnFmicnhOXwAPoaaHIZhxhPiUYTX8MwnCKETU5tAwHG0bpfOVnEKHV8Mn4p07vfYDrXK
         AzqLb+/7Nx17Z4VxVyhz6twFZnq+UNASWe9aS1dt3oOLPm0bIgLDAWq8Za2GFF+p7TYn
         cmdD5GaBnKbzRpgI376l8JrYCqE+XqsDM3RpDrA5lASJ+okFB6s31ayWIiRhtVdueTvd
         NRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=smuNpjn1omety5y1ZI25Wf6WWShNtH6K3hRtcH4ZOPQ=;
        b=GfAGjPYP0uICpqWfbjXLKJxMHmBTP03VJAdTUZ1j5NMZQn5hh2CvvNUJx23bxxNNKc
         va1pMhxbklJjTg1ioc2jZ5Cy/ywcNC9SiHxw1blQPkrtunrFZ6rv3BLMIklCZWL6+Db1
         FUSl+MipXWsdcqgbs+H505r+m58VExK0YyXZS7XjQQ948jWUiVTKVSwjdxUEqx5XsrSA
         4np4fGEZCIFaues3lehL0dvVpSekw6m8W+BbcuGZ6afUxRLbQgVJyLGSGF5JvKfn+VC3
         F32Gv+PgagLNm8HcTRge55yLM+Z3Wyn1gICCxhHrS7KkmqvzzpJsj0TkIksnETZJDmbr
         Zakg==
X-Gm-Message-State: AOAM532/FCqlzgRMOs07kXrINV7N/0v4gRqu09K4zgdiCjDUVmbWmtVf
        SpRtij1C54JaPaKADcUmNuU2jG+LDPM=
X-Google-Smtp-Source: ABdhPJyka5DS4b1l0iQkXTlF2Y3w7YfZX1CP2fIB1rHJeRnzQo/3WxTpSADZQXH61X5PSMUBnUTpeQ==
X-Received: by 2002:a5d:42d0:: with SMTP id t16mr6269684wrr.230.1609975129776;
        Wed, 06 Jan 2021 15:18:49 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id c4sm5549899wrw.72.2021.01.06.15.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 15:18:49 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
 <X/Y8D2TgQDBumfvO@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: replace mutex_is_locked with
 lockdep_assert_held in phylib
Message-ID: <17717d40-ff36-dd59-bfaf-0abb513bab06@gmail.com>
Date:   Thu, 7 Jan 2021 00:18:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/Y8D2TgQDBumfvO@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 23:39, Andrew Lunn wrote:
> On Wed, Jan 06, 2021 at 02:03:40PM +0100, Heiner Kallweit wrote:
>> Switch to lockdep_assert_held(_once), similar to what is being done
>> in other subsystems. One advantage is that there's zero runtime
>> overhead if lockdep support isn't enabled.
> 
> Hi Heiner
> 
Hi Andrew,

> I'm not sure we are bothered about performance here. MDIO operations
> are slow, a mutex check is fast relative to that.
> 
Right, the performance gain is neglectible here.

What I see is that more and more similar checks (e.g. in_softirq,
in_irq) are migrated to the lockdep framework. And as stated in the
commit message I've seen a number of equivalent patches in other
subsystems.

> I wonder how many do development work with lockdep enabled? I think i
> prefer catching hard to find locking bugs earlier, verses a tiny
> performance overhead.
> 
Well, I always develop with lockdep enabled and like the fact that it
provides a multitude of checks with minimal overhead. Would be
interesting to know the ratio of kernel developers counting on lockdep.

>        Andrew
> 
Heiner
