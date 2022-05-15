Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472FD527A50
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiEOVQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 17:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiEOVQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 17:16:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788C5BE30;
        Sun, 15 May 2022 14:16:29 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i24so12373375pfa.7;
        Sun, 15 May 2022 14:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MF3ww9WqyFLZs80BbLjzJynm/63WVfRXoNS9SF4RNm0=;
        b=dnnGZbfmQHP0/AIys9QQSIFsd/cTrURdK7dwcAgwLwIBRoAVi9XzjRszs6XzAUUdpy
         P2p+NmZu2dTOQhvEYpd2J230zPw0D8/Wz5htXbWWBOIZjLaj+kt4f/KGWBE/l2SCtHUZ
         eIWNlkr/N2n33l4US6knormnyIkL0pSGFINxX5lK/jUNwUFquyz0SWAaPO8ogmVbVRpw
         NLO7EvG/h4D5bOEr8jqJuAnjVTtvxO9FVIultFShLcPRHCv9pgOlO6y6TTtUBphkiHTl
         casVFSfXeF6wB9+FinfWoYrr0VhJcgJdCQ2GgSZg7V8xplAWc00GDUawPgr1UsqsS2/R
         fgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MF3ww9WqyFLZs80BbLjzJynm/63WVfRXoNS9SF4RNm0=;
        b=evQw3S5H+O1cAqotNrIDjQcyNem1GooRTSdPNgr3tAvjZ3M1wXL4UBjHp5t5nMQsQ+
         /rWqKHPW/kQwSX9vYHR/PbADr4UOsF+WyWliEq76yNaVH2NbzycEQsFGX1x3J5BU+AHS
         4nwUzxtqXvxaNFUfsykmcj5G9gHxMeCJgOioJMnOpOGTkCoAYJ0LYwSOMknmREq87JSM
         yJAE6WcSNKkcoMTXR2WPHfk660TcFu1MuKpbGvdpgAKlkGMZcku5CXDGojk8qJCVcMC4
         FoS8xf2Tn2yXvdoM3R2pU9xbHgXwne/L8NRE2WNiOAwHDWcsyYdnwwg/8TakKH8giqi3
         RqJA==
X-Gm-Message-State: AOAM533FRW8tU5ZpeFSXImHQm6o0l+yLPyY6bFg9v+EM9gSgEXeEBHh9
        nv8fDu1oztD9EbY/I1IWSLk=
X-Google-Smtp-Source: ABdhPJxJUBms7ljkBc7EgrqPwogtghHGVmFUXmTXV/GwAbmTXnn46iKEZkifyboul35QOYJ0VzcYng==
X-Received: by 2002:a63:85c8:0:b0:3da:eb5d:6def with SMTP id u191-20020a6385c8000000b003daeb5d6defmr12677081pgd.96.1652649389339;
        Sun, 15 May 2022 14:16:29 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:cca8:f194:3bcd:331c? ([2600:8802:b00:4a48:cca8:f194:3bcd:331c])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902654500b0015e8d4eb1besm2914292pln.8.2022.05.15.14.16.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 May 2022 14:16:28 -0700 (PDT)
Message-ID: <86c9e526-c4e6-d549-14cb-1495895279d0@gmail.com>
Date:   Sun, 15 May 2022 14:16:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] net: systemport: Fix an error handling path in
 bcm_sysport_probe()
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <99d70634a81c229885ae9e4ee69b2035749f7edc.1652634040.git.christophe.jaillet@wanadoo.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <99d70634a81c229885ae9e4ee69b2035749f7edc.1652634040.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2022 10:01 AM, Christophe JAILLET wrote:
> if devm_clk_get_optional() fails, we still need to go through the error
> handling path.
> 
> Add the missing goto.
> 
> Fixes: 6328a126896ea ("net: systemport: Manage Wake-on-LAN clock")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
