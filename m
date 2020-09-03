Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B1325C6DC
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgICQca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICQc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:32:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404A2C061244;
        Thu,  3 Sep 2020 09:32:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id np15so3951907pjb.0;
        Thu, 03 Sep 2020 09:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OrbbM9DgLdnxe1+euwEacdEqAbrZFxcjaO4/M3jujnM=;
        b=IUjymj0/UHYW6IMRtHbsrn6e3DcUG7cIiYyWIzYS2D0E2oBsojdlwI20ybI1X51hqG
         QxS7mZObFOLhRLD2duuRVx/vKmC4NUUoGo1A+SUu6lWDuY4r6B0iLxo2cyLyleNzE+YL
         hRqnMu4Kgl1aUkrPtxUcjDx23xnhrHkEHkNWwTiAc59Vi84PhpaVJgFa0AlSHInBRB5D
         rdWNALNNVByl9yGxQZGgU7/UPzT8fKVGsreuldQI1Dv13nmOFY7c6+SQVIpJUwDRfcCH
         b9H3U7xlZgfvadKj1RMinLmFStXwStM5iZRobhzI0bxo9Utm8rkKVFoTY79C5hQHqhqn
         FMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OrbbM9DgLdnxe1+euwEacdEqAbrZFxcjaO4/M3jujnM=;
        b=jPzZQ5Qz9JwQzr5VwDYsjIqSizFpZoiYWcRC+Ou5guZG6QAh3Apwm3EaTftB+uhLkf
         OSJsMbi4E4mvjIKm1MdtUKWPgWqE6OCzZTK13zwLRpGZnZ0/H3+gdoy1oJ9veOBacD0q
         AUp2eK3S/0yW8gG1HPUOfCUrLV853/BHEr6bUv6VBKHjYTMfNKJQxCRczx/U48avgb5U
         XvENBU0jJQv7eo45TlnXSYFEgOU6pmNIAyX8pzPPSOE5IewlYipQyJls3liC3KZkKVTL
         G0xKUGa5yS2ZBe3ygmHW1muYJm0PigXhBK+p3b5n/ndDAGAjMppwp4tFLZDz+XNSvzXE
         9nqA==
X-Gm-Message-State: AOAM532DtO7vz2Y9zsrd/z2YBbMGdBxaOujaGNsXol8O8Bi+1Qo/aeV/
        t6p0ZzN0IICkMwDXvFLP3l5hyVc3EVw=
X-Google-Smtp-Source: ABdhPJycN1aKoSoawdEpEEDqOzxI/pTlR7295SDkrS1slo2Cre6TmhVDQSycptAG69QgHHiiMGz0NA==
X-Received: by 2002:a17:90b:3717:: with SMTP id mg23mr4090514pjb.42.1599150744730;
        Thu, 03 Sep 2020 09:32:24 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d13sm3724864pfq.118.2020.09.03.09.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 09:32:24 -0700 (PDT)
Subject: Re: [PATCH v4 5/7] net: dsa: hellcreek: Add PTP status LEDs
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
References: <20200901125014.17801-1-kurt@linutronix.de>
 <20200901125014.17801-6-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c8e43260-1535-6171-b9e6-f2593178a3e2@gmail.com>
Date:   Thu, 3 Sep 2020 09:32:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200901125014.17801-6-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2020 5:50 AM, Kurt Kanzenbach wrote:
> The switch has two controllable I/Os which are usually connected to LEDs. This
> is useful to immediately visually see the PTP status.
> 
> These provide two signals:
> 
>   * is_gm
> 
>     This LED can be activated if the current device is the grand master in that
>     PTP domain.
> 
>   * sync_good
> 
>     This LED can be activated if the current device is in sync with the network
>     time.
> 
> Expose these via the LED framework to be controlled via user space
> e.g. linuxptp.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

There appears to be quite some boilerplate code to deal with the default 
trigger, default LED label that could presumably live in the LED 
subsystem, nonetheless:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
