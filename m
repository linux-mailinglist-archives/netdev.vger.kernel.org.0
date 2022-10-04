Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156705F4952
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJDSfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiJDSfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:35:19 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55692AE25;
        Tue,  4 Oct 2022 11:35:14 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id r20so8668662qtn.12;
        Tue, 04 Oct 2022 11:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=H4GdClrHvsjvyos0RzMbAPP6/VNtDsrWcC1gWDDZt+4=;
        b=Q+Jdf4LTwInIWOZIOzui61L352WiAkhWcH/cwSpwIx9nepkjJSaOQxdNIRtoixkp3H
         tu+sCwwFDnSq+7h+4traIZAT/7w5qTDT0dpBEsNt4P8JXNWQlBLYQSeurirXX3uM70bl
         GxDIglfkzAPA24o9/D3rhTFesrQnDINoBVdKXN4qKUQYwVroAplzYExUtyxzu2iDgRB/
         8POmIOSbMbuuRp4HJjKKWVaN7i9HhoaKk+kR6RiaYyx9mS+gCk6uimiVs3AS5EH+H4g0
         2+P9gL/eocRyx/cq347v1uRDVh+NILohg/21UvJZXkA8RmzEl3u+MiAkpvPFGwCtOJNN
         rR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=H4GdClrHvsjvyos0RzMbAPP6/VNtDsrWcC1gWDDZt+4=;
        b=NHrNz3pNFf+vWB9iRH1tzGuZVFCdCN+ydHXCYd5E0AksujaYGhFckDKg3+xtE5SezL
         kUO9E10c2VZkqZuL5P+8VeRo7/78DW8gEjIELeBqpkDjFi5X29IvQUeQKQc3pKuBA1YC
         4huLe1nWHao5tNyR0Z5QlYD4TIH+8rKFBY6IC/ueXnxr6xfh0T9H9VUVKBI3ygJhM/Mn
         iQ+xZIwUzcBD5goov3VxllCPWqEtQOrDdwHbbiy1OYHhvkZILWBpkkAcTPK3rweBPeuF
         Uhsl68bq8I+pNHmUfmQMN+XmYhG6wJrQ6B03axoW64pisBC9Sv0OK46y3AijzAIXJqyg
         PQwQ==
X-Gm-Message-State: ACrzQf0e3CpQZpE5q0tiDO6JBejwzw2WDqoNHuur2CfG/GAPZa3fGT7s
        X3HMGfifzd+omSGnkYXh3UeA8Xuz1Uc=
X-Google-Smtp-Source: AMsMyM5ZWjdkkI5t9VHNCznY9xmiz9sIjIamZcqNRl4gpmtRMOxopJhYZBoheCrxPCyfuRS28cZ9nA==
X-Received: by 2002:a05:622a:1046:b0:35c:dde0:6735 with SMTP id f6-20020a05622a104600b0035cdde06735mr20653870qte.689.1664908513575;
        Tue, 04 Oct 2022 11:35:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bq38-20020a05620a46a600b006a6ebde4799sm15218518qkb.90.2022.10.04.11.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 11:35:12 -0700 (PDT)
Message-ID: <a495dd76-060a-210a-1a11-55333d67180c@gmail.com>
Date:   Tue, 4 Oct 2022 11:35:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] docs: networking: phy: add missing space
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Casper Andersson <casper.casan@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20221004073242.304425-1-casper.casan@gmail.com>
 <6645ba3ba389dc6da8d16f063210441337db9249.camel@redhat.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <6645ba3ba389dc6da8d16f063210441337db9249.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 03:30, Paolo Abeni wrote:
> On Tue, 2022-10-04 at 09:32 +0200, Casper Andersson wrote:
>> Missing space between "pins'" and "strength"
>>
>> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
>> ---
> 
> The merge window has now started (after Linus tagged 6.0)
> and will last until he tags 6.1-rc1 (two weeks from now). During this
> time we'll not be taking any patches for net-next so
> please repost in around 2 weeks.

It is a documentation patch, therefore not functionally touching code, 
maybe that could count as an exception?
-- 
Florian
