Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46954611274
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiJ1NOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiJ1NN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:13:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F981C6BE1;
        Fri, 28 Oct 2022 06:13:57 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v28so4578127pfi.12;
        Fri, 28 Oct 2022 06:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RdwGDChygcbuv7ncAXaIEDQUdOkATGiqCP5G7LmTETU=;
        b=OGV0n8XdxQLrjYQerDgQmrWWTcgpZNfXK7TFxWE2ozN61Bz75q40ALh2STA49sbirq
         ctYJvbNnH1YINiWgvLPazHGs1BE5Y4KbZmFlQaCxw8rQyTALlQjOqXDYgIZIe61yYgey
         2e2vHYXseeNq2Qy06WRpBJ2lxWeNNfGRlsmjHFCoggA01gF2CnCOSGQ+r0PuJ5JNjuDH
         ADd1MuVKCrerCkOC/jUy82iFfRbqbD/0LThpvh/ZmflFcgG1kKCuJj4+8gXhZ+A3q1AJ
         rNlhQi30/Q6TqyPld9jke1/40q5rVTV8xXxTJ0xMXy3RMX64hrfas0M8SusTWD3MD4IH
         hCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RdwGDChygcbuv7ncAXaIEDQUdOkATGiqCP5G7LmTETU=;
        b=N93zDmtjf+1y2cylPrJBlX0wi+mwMOUAXZtUL/w11uF3XDSH73C7Ft51bdQVersbMA
         IyKUllcb/yVq/ZZIP6d6h/NmyM2KT1P93SUUk0sOO//mWSKLD/TO68ixvhG8Fk3DUtJ8
         EzsXVQas0rTUHLJ5i0NWRwtePGlUSbsmtLpdI+cEJvil181dcvW2YfZmjzAzVy6obWwY
         VtI7dzx57E8bmfALUsVYHm1hZoxpy42obX9/unJVdMK1nkrR9Bt84m4Kfl+Lk9mahE1q
         vIX8q45m3tH9GTCatBoiF4VZyaG/sLxKXuzYeopnL7ucqPQRs6nBTU+3/j9NRyLZH1e4
         8E+w==
X-Gm-Message-State: ACrzQf3GC1vuE4Zu4bzAeLj9FHPWS1J326Jab6TpfvLExW1ZTgILyGxS
        Qz33H1kygwjxZ1xkajKff3c=
X-Google-Smtp-Source: AMsMyM6BnZiyO9TCguQ8TZ5hERm14cu4VDLcsD7/eQBL8RQ6bEu8ReapyTTcyaB9+MvZS5OHyb+JIQ==
X-Received: by 2002:a05:6a00:14cc:b0:56b:9969:823 with SMTP id w12-20020a056a0014cc00b0056b99690823mr30912145pfu.36.1666962836924;
        Fri, 28 Oct 2022 06:13:56 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id pj14-20020a17090b4f4e00b00212cf2fe8c3sm12659694pjb.1.2022.10.28.06.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:13:56 -0700 (PDT)
Message-ID: <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com>
Date:   Fri, 28 Oct 2022 20:13:49 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
To:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jakub_Kici=c5=84ski?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/22 05:42, наб wrote:
> Since defanging in v2.6.12-rc1 it's set exactly once per port on probe
> and checked exactly once per port on unload: it's useless. Kill it.
> 

What do you mean by defanging in that release?

Also, s/Kill it/Remove BAYCOM_MAGIC from magic numbers table/ (your
wording is kinda mature).

> Notably, magic-number.rst has never had the right value for it with the
> new-in-2.1.105 network-based driver
> 
> Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
> Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/

Use Link: tag instead.

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

