Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908E288057
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 04:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgJIC0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 22:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729724AbgJIC0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 22:26:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69221C0613D2;
        Thu,  8 Oct 2020 19:26:48 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so5571164pfc.7;
        Thu, 08 Oct 2020 19:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ianMI0skgT2+5Mr4X9GRt1HqniVrm6Fh/4YOQB+YSrU=;
        b=Qeh+BstLg+YnjX9buKFp8NLiYlnG/4bwAvdM9WmKjjyJSh3zxCP+hS6VYiyVpHO9Ia
         DruigZfmhEzVQabkhHCyWB2ovh9SjKbQ7sSkp9TeNucIE3SL0vChe0FUn46pLVYvJ7t8
         /VfHeZt+p8oF3iIpTDqkfCdrMm+uSckJJDUF4KFN5frLFAvzpwlFqLp0UogbKMZiZqSQ
         eXTsSl3wV4I+uoyPVkU7KxSCILLkKvStJdVuBwd8HtCb8aDVNYiQh5T9bihalWFhfUe3
         XuCyC1WNfAkhNQQh6UAstkaVKEHgm3dG/3SxXbcWL0y338naCtDqecaYnTxlOadan2B0
         deFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ianMI0skgT2+5Mr4X9GRt1HqniVrm6Fh/4YOQB+YSrU=;
        b=X+aftx43+pC1zpjiZL76Rzv6vclSD39rxOq75L3eVAYFoKpt71WdRfZQjuAIzdj7C4
         U6g9PCxB3vEfDmT+hJhHMvwR3zwv7KAYQCjjgKCeN3Gf2i6ZDJoNYZkPBJlrm92t9vka
         Vm+iQwexEA/kgmZBdY7pAxkdV5TlOrfMxiAvcY0htYrEBOgYXHf798MU9siwZ9qHFS1p
         C3b/01wOnnkcJmbkQdCrAiGTCQUut/3S5tNZdFjuhIwaHuJAyiNrifj4EsqKZpgsmlDQ
         xarGhqcNt5zsHlH6/UesHAwkG3DqQYRPbEnrXk0Jch4vZL9906D/Dze1n3GViclgwLsx
         KJOQ==
X-Gm-Message-State: AOAM532F+32foE5hoxoaBVRmRskOiJRivKHK3beTqVz6XajSiqG1fW24
        A7naa8zlWp4UmaRkixgDQ2BNs4cDL0F+kQ==
X-Google-Smtp-Source: ABdhPJw2KHvtC3OqHNVaYtkwsG8qrMazjs18l/MgsjU4PGfRxswG0nHXPWzTdaENAWFViCbsUk6tuQ==
X-Received: by 2002:a17:90b:1a90:: with SMTP id ng16mr2068760pjb.172.1602210407567;
        Thu, 08 Oct 2020 19:26:47 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5sm8442155pjn.19.2020.10.08.19.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 19:26:46 -0700 (PDT)
Subject: Re: [net-next PATCH v1] net: phy: Move of_mdio from drivers/of to
 drivers/net/mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Rob Herring <robh+dt@kernel.org>, davem@davemloft.net
Cc:     Grant Likely <grant.likely@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ACPI FOR ARM64 (ACPI/arm64)" <linux-acpi@vger.kernel.org>,
        linux.cj@gmail.com, Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        devicetree@vger.kernel.org
References: <20201008144706.8212-1-calvin.johnson@oss.nxp.com>
 <CAL_JsqLf0UJNmx8OgpDye2zfFNZyJJ8gbr3nbmGyiMg81RoHOg@mail.gmail.com>
 <20201009022056.GA17999@lsv03152.swis.in-blr01.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2a0f9055-9110-ecc5-aab2-ff6ec9dc157a@gmail.com>
Date:   Thu, 8 Oct 2020 19:26:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201009022056.GA17999@lsv03152.swis.in-blr01.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/2020 7:20 PM, Calvin Johnson wrote:
> Hi Rob,
> 
> On Thu, Oct 08, 2020 at 11:35:07AM -0500, Rob Herring wrote:
>> On Thu, Oct 8, 2020 at 9:47 AM Calvin Johnson
>> <calvin.johnson@oss.nxp.com> wrote:
>>>
>>> Better place for of_mdio.c is drivers/net/mdio.
>>> Move of_mdio.c from drivers/of to drivers/net/mdio
>>
>> One thing off my todo list. I'd started this ages ago[1].
>>
>>>
>>> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>>> ---
>>>
>>>   MAINTAINERS                        | 2 +-
>>>   drivers/net/mdio/Kconfig           | 8 ++++++++
>>>   drivers/net/mdio/Makefile          | 2 ++
>>>   drivers/{of => net/mdio}/of_mdio.c | 0
>>>   drivers/of/Kconfig                 | 7 -------
>>>   drivers/of/Makefile                | 1 -
>>>   6 files changed, 11 insertions(+), 9 deletions(-)
>>>   rename drivers/{of => net/mdio}/of_mdio.c (100%)
>>
>> of_mdio.c is really a combination of mdio and phylib functions, so it
>> should be split up IMO. With that, I think you can get rid of
>> CONFIG_OF_MDIO. See my branch[1] for what I had in mind. But that can
>> be done after this if the net maintainers prefer.
>>
>> Acked-by: Rob Herring <robh@kernel.org>
>>
>> Rob
>>
>> [1] git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git dt/move-net
> 
> Makes sense to me to split of_mdio.c. I can work on it once my current task
> completes.

If you could take Rob's patches, given then a round of randconfig build 
tests and update the MAINTAINERS file (no more drivers/of/of_mdio.c), 
then this looks like the right approach to me. Thanks!
-- 
Florian
