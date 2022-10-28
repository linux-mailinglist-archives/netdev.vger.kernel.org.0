Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD561077A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 03:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiJ1BzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 21:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiJ1BzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 21:55:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E090425C4A;
        Thu, 27 Oct 2022 18:55:04 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 192so3597926pfx.5;
        Thu, 27 Oct 2022 18:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=irU9wao3U9xoVcrQJyhza+H5ctRejikSJ6E6Kg/V3MY=;
        b=CWM+n58iZiFaG225OsCmWHZxmK5R48tN5dvlbhaHxGL6zDQz8ikkUPO6pYpORUPjip
         TBwCPWjBSo+lPY8hcQ/r6PO1M8HtjnYaafUDgaIpPXNjtOf7+f/XWawhjEGWj8GlvMmy
         zn3tBnA/O4kiw52fT+8WYh1og+y/20LW2lFhDWakRiTTmRryBaKcOTg68lDo1/Un1KaI
         7+CFmUpqb6N6PcWUBQ+SSXjLkXrxkxEtShz/QWu3xad5yiE+gGtAqQM9DbOVi+hL5mCj
         B+iQApADWVUin1F+MqIVoThiWKPKpsbFJO3Ght1+T6C6/NphYeRpi+D4agCx4Z9saimZ
         jKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=irU9wao3U9xoVcrQJyhza+H5ctRejikSJ6E6Kg/V3MY=;
        b=7pCpKwUXuiwOsMcDx53KeZovs0eGqBS1Gso9olulm6qY7FLhQFtH3864ysE/VUOitB
         E0Fy6tU5uDxV4Xfdc8n6NqxYEAAIAGvz6FRrnHHs8FBdSOmHobtGfL2gBNJuEa0tvyBr
         5o0Hgge09as3ovj1+g+ZA5R6wHgCPzJella6oZjcIAdDxSu8+rkr1Jry13YZgCaukN48
         uKmchWYx+rR1th0voos++teRIY3OyuHmpEPmOGOcVm0t7f/VoCspv8F83PDLIUmrByiT
         KAZ5+hyMVUSkPRJ8BxGuPF+hy5X20yJ8bYmHFz4NFVk3X089ZXxj8AZW3g1W7+ycaC6g
         vGhw==
X-Gm-Message-State: ACrzQf1yQtx1xg9K93bpVRcCMzwt80KPB0bX5PRAv3BmbyWj1GAjBKqA
        VC834pgAk+WDlfc84hTPd98=
X-Google-Smtp-Source: AMsMyM4hVMBb2+2ZWJtSPhm8ookS+OzUjXKv7LWFttXdbfHxCskyQZQlVqr/s11N5B9sTMyIa6ndGQ==
X-Received: by 2002:a05:6a00:10cf:b0:563:34ce:412f with SMTP id d15-20020a056a0010cf00b0056334ce412fmr52875662pfu.67.1666922104148;
        Thu, 27 Oct 2022 18:55:04 -0700 (PDT)
Received: from [192.168.43.80] (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id y189-20020a6264c6000000b005625ef68eecsm1776143pfb.31.2022.10.27.18.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 18:55:03 -0700 (PDT)
Message-ID: <d3be78c5-dbb0-6419-03ad-8337b46f91a0@gmail.com>
Date:   Fri, 28 Oct 2022 08:54:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <20221026183711.342ae914@kernel.org>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221026183711.342ae914@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/22 08:37, Jakub Kicinski wrote:
> On Thu, 27 Oct 2022 00:42:37 +0200 наб wrote:
>> Since defanging in v2.6.12-rc1 it's set exactly once per port on probe
>> and checked exactly once per port on unload: it's useless. Kill it.
>>
>> Notably, magic-number.rst has never had the right value for it with the
>> new-in-2.1.105 network-based driver
>>
>> Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
> 
> Interesting name :S Just to be clear full legal names are required.
> Not saying that's not your name, just saying I haven't heard it before.
> 
> Plus the From line must be the same, legal name.
> 

You mean From header (email).

In this case, she forgot to add From: tag before the patch description
(which could be easily added with --from option to git-format-patch(1)).

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

