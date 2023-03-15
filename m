Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC45F6BBDEE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjCOUXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbjCOUX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:23:26 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FF130297;
        Wed, 15 Mar 2023 13:23:02 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id n2so1473121qtp.0;
        Wed, 15 Mar 2023 13:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678911773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y43CrMv3dCSNBBE2E2eEHGKf53+TmHrc0+8s4oLsAXo=;
        b=lLoIaKJm1TtKhZ7/NSQSJmB4jhXyXOJjfgR+50ODM4mSJDYGYldMVIRyFSkKmjjiol
         +d1JqcnckKJyn41TB4llhYtdH6hbHNUKvOauwlPumnMP2H0ZaqOlwWZ7xe2chmMgXZxx
         kmvksecIXMcGuLSsmyU9UuVUb5ZDyBsHhHOkVz/cWfqL1X9KU/tRji9A17A4UZCIHNAk
         a2/HfXV67lAnWRRsxwwGCtDjcEOLZmMJOyEX3r/5sO2vIWRKqKORPT6IpDNUh5HR86wq
         i6XERKREHaDY5lPJ9u21jtvgpHb9dEjlcdsdIJdZ4LdWWU/k/9GEi/KlTzS0gbmADB3a
         73+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678911773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y43CrMv3dCSNBBE2E2eEHGKf53+TmHrc0+8s4oLsAXo=;
        b=SmFpgPSJN4zhwbL1I1AJhXGYjJMnwTcN6m+drlIbyO6C9ayfd+1QHoIo1ZJzSXOoKO
         JtOWJzxKg2GAELnytdOBoegTj+eonIw3DMh+/GSlHQ8y+A6eL9ZgqZQ+qET4KY9sUDzC
         cF/RsGF3FhG7RHLGZ0hAJ7EJm7Y8zliQu0lOKpCEeIK6GfUurXsEIMFwzg4ueUfzOOQZ
         j5PM21CLoJcij8cUkMbzLFBkvinCJPgh61lNwjXfrqOz42utHyPbbpW3FsNwwdmPfi97
         9hpPnNX2auQ1CrB6+4uN66n3g2qw8JEo/4s6QTzRnRqJcLrZ+mohyy82c/1p6tBJeEK2
         wLmQ==
X-Gm-Message-State: AO0yUKX5ysYCTvSWbESkQJSdo2GP6UuuxNrds0V/cgLo1EUbOu+M/3Lb
        2PNP1xLT9IcSLC17n6veG+U=
X-Google-Smtp-Source: AK7set8abR2Om4fKPuZzWPOkoX8yChmo9SqQJi5RAQvipP/EqqS6FVMpYcKGMy4R9Z8nyu4z/NkpGg==
X-Received: by 2002:a05:622a:110c:b0:3bd:1bbc:8d8e with SMTP id e12-20020a05622a110c00b003bd1bbc8d8emr2311755qty.0.1678911773337;
        Wed, 15 Mar 2023 13:22:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b8-20020ac812c8000000b003b68d445654sm4284238qtj.91.2023.03.15.13.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 13:22:52 -0700 (PDT)
Message-ID: <191e9cbe-8997-c6c5-f418-092fc0af7266@gmail.com>
Date:   Wed, 15 Mar 2023 13:22:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in error
 messages
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     kernel@pengutronix.de, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <20230315130917.3633491-2-a.fatoum@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315130917.3633491-2-a.fatoum@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 06:09, Ahmad Fatoum wrote:
> Some error messages lack a new line, add them.
> 
> Fixes: d40f607c181f ("net: dsa: realtek: rtl8365mb: add RTL8367S support")
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Not sure this deserves a fixes tag, but I guess why not.
-- 
Florian

