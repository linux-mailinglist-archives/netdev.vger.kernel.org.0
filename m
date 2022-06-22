Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFCA5550E1
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358174AbiFVQJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356191AbiFVQJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:09:35 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C902F67B;
        Wed, 22 Jun 2022 09:09:35 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h192so16515045pgc.4;
        Wed, 22 Jun 2022 09:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+EtFsQ/IG9t0+cLITLCHnL4ghtintXW+5tTxWND0qNQ=;
        b=nS9MBb0mf3J1Md+n4WUmnLL0sqW/cE20D9BDwR9GPY3NTaYFWz6KcdQSuIBIUaTRAo
         PKo4BxPSJgSFxY7EXnbAQoG8VR+smz7V/dY1Kz7nKY6lBoJ5cWsrSq9YMdaa49Jgnqn5
         Q/cZ/v5g31Kgxh7gR+awBPVAyx+ADvhg0Gqm2zb1n7OrrfO0ivJQ1/3SgyYq5k462qQi
         HBwNlg+WBBZL/evQewje+xFHBTRDZo1PaAYeSCIvZ8vH3hdX9UX/bPRREHTLV9Vz68b1
         iDlJiKo43whqkEN7Q3+nF5l1Tvddc00SCFHJ0ToyFwDZJ4nLiq2JK1JG5xB545LKuTpl
         qgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+EtFsQ/IG9t0+cLITLCHnL4ghtintXW+5tTxWND0qNQ=;
        b=PChUhyjPNQDGHr4rglH6loohU271iFq/leof8tzHnG8ld8vnzUq2tkyM6KdYzQpWjg
         0rzDD/w84/j0dHOHn6gchf/IhcBcP3PPAEkUaFh2ZhOFMNUV5tDNtnUkCNTbfWNa7n+v
         Z9vGyjip6cwx3aOYierZq7WEQuNnBPzLRB6AC0sPrMXlchzaJvGjrryTov/lM58TCXC8
         iCeE3dX4IcTtWLs5dPCv0nqxaWNGlBhtaW7hlC0qpvZVuav9ddkCr9DwshF449VSs5nW
         Q75eQoL0AaIiYHXlnyK5l7LgjIxtMKeYsU6GFGcwlWOB6c7CGDtbD3enaQ/ctRp9JGJK
         OfdA==
X-Gm-Message-State: AJIora+qMbvS4LnLa1wmNGjs1mQ5EcSIKZZXcU1E8Xrc4sqK2f7Zstf0
        4e6YdxD4nW95BoFnL6tzdr4=
X-Google-Smtp-Source: AGRyM1u98/UE1tJiYVIQsQR1MDaAB0odjiS6/pGRy2RXg1Ew1iAotj2Q1jberv8Tc9N1x36fT/DqDg==
X-Received: by 2002:a63:5424:0:b0:405:230e:3d9f with SMTP id i36-20020a635424000000b00405230e3d9fmr3483868pgb.271.1655914174579;
        Wed, 22 Jun 2022 09:09:34 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b9-20020a17090a550900b001eaec814132sm3080205pji.3.2022.06.22.09.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 09:09:33 -0700 (PDT)
Message-ID: <041a526e-2ecf-878a-e36c-d704e4b55e97@gmail.com>
Date:   Wed, 22 Jun 2022 09:09:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [net-next: PATCH 03/12] net: dsa: switch to device_/fwnode_ APIs
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-4-mw@semihalf.com>
 <YrCxUfTDmvm9zLXq@smile.fi.intel.com>
 <CAPv3WKch9hC3ZjZE0f4JntqFDY04PUpQ1yzsgShThmhkqV01-g@mail.gmail.com>
 <YrGlUPxrK4XeaT5h@smile.fi.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YrGlUPxrK4XeaT5h@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/22 04:02, Andy Shevchenko wrote:
> On Tue, Jun 21, 2022 at 11:27:43AM +0200, Marcin Wojtas wrote:
>> pon., 20 cze 2022 o 19:41 Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> napisał(a):
>>> On Mon, Jun 20, 2022 at 05:02:16PM +0200, Marcin Wojtas wrote:
> 
> ...
> 
>>>>        struct device_node      *dn;
>>>
>>> What prevents us from removing this?
>>
>> I left it to satisfy possible issues with backward compatibility - I
>> migrated mv88e6xxx, other DSA drivers still rely on of_* and may use
>> this field.
> 
> If it is so, it's a way to get into troubles of desynchronized dn and fwnode.

Agreed, we can take it in baby steps if you prefer, but ultimately we 
should move to using a fwnode reference rather than a device_node 
reference and if there are drivers needing the device_node we can always 
extract it from the fwnode.
-- 
Florian
