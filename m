Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C8960D7A2
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiJYXE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232159AbiJYXE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:04:58 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB137E816;
        Tue, 25 Oct 2022 16:04:56 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id x3so1766518qtj.12;
        Tue, 25 Oct 2022 16:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ClspvyXTECiETgdUQTzdfSfb1fdhiX3Hnq3vM9YFJKg=;
        b=OGVQx/2jN+RSO85l2tT+FBBLDTg3+Zwd7kPErhrGyLOvARiBsC6CG7mlS5qehrVYjz
         ihtrkFKVyhxJhSYcMvV5NWm9PskAi/kmNQQmlfOa/Atw95eHt5E/xoWUmo4sZqo3vl6j
         CFQyTygR+2sMm/0/KV7GFc4CoMhIlc5XmYa/1tJQAXFJdrhS0cF3+wNUENeelrFXVU52
         B+fJaSn+KrN1P/cNjmuab6WTcWn/9XgYj18k3hKTDHoKhxqIHLAQQtgY7Ei3jjIvIsAG
         fcVYL7OzlTbJRpGXtu8aguc9N1G0gMaX45lDxLj2aL/avr2nXoN6LoTK0/S4kgTRI4RP
         T+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClspvyXTECiETgdUQTzdfSfb1fdhiX3Hnq3vM9YFJKg=;
        b=1i0pCUbOOCEWr1gEWbeLZ7P6Lf2gdqw0OiD+1JTDp6LcWwq7lsHR/pVTe01WFnCpj1
         hzPbrrX2IOlJg8Tandm0c3ExOrUkkmb0NDANJdKYIWIt0F56Urj/ZpNinlFoTDUEVqUS
         RkIe92JKk/TLTH6ZxrLvI5h+F1aMYyXyv7m4erNfEz0wSDOfRTKwyqHAizH0OCUuq5m/
         Wzam9XNWr9QrboOyxdyLU5+0xdgl/lFyVkhnmsHGizHM673yBPDHYiMdEVWa2Rn0I981
         ImEx4RnCNzcvjX76DbnFj8OLiuw6eInUIAG9JhZNPEPdhDiik8HfwH23kQQccKtKIV31
         j3hA==
X-Gm-Message-State: ACrzQf2BHdn0Vt8HCsT4CTKkbW47UkC0lofwKdtmlrZ7NgOXxX8BymPz
        c6qyi53s55684AfsO0KU/BQ=
X-Google-Smtp-Source: AMsMyM7rTVsA7B/1nr6n/+LBGSf6vGViUcnpSdM2UVcJd2IwE+vvSTBrnUYbSAFzBatpLBuidNMdkw==
X-Received: by 2002:ac8:7d0f:0:b0:398:3029:3328 with SMTP id g15-20020ac87d0f000000b0039830293328mr34625420qtb.99.1666739095917;
        Tue, 25 Oct 2022 16:04:55 -0700 (PDT)
Received: from [10.69.53.73] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t18-20020a05620a451200b006cfc7f9eea0sm2913312qkp.122.2022.10.25.16.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 16:04:55 -0700 (PDT)
Message-ID: <8fbc9d02-3c73-5990-85af-82eecb6d64e3@gmail.com>
Date:   Tue, 25 Oct 2022 16:04:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [linux-next:master] BUILD REGRESSION
 89bf6e28373beef9577fa71f996a5f73a569617c
To:     Jakub Kicinski <kuba@kernel.org>, kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>
References: <63581a3c.U6bx8B6mFoRe2pWN%lkp@intel.com>
 <20221025154150.729bbbd0@kernel.org>
Content-Language: en-US
From:   Doug Berger <opendmb@gmail.com>
In-Reply-To: <20221025154150.729bbbd0@kernel.org>
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

On 10/25/2022 3:41 PM, Jakub Kicinski wrote:
> On Wed, 26 Oct 2022 01:17:48 +0800 kernel test robot wrote:
>> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1497:5-13: ERROR: invalid reference to the index variable of the iterator on line 1475
> 
> CC Doug
Thanks for highlighting this for me, but I happened to catch it from the 
linux-mm list and was just looking into it.

It looks to me like a false positive since I am initializing the 
loc_rule variable in all paths outside of the list_for_each_entry() loop 
prior to its use on line 1497.

If desired I can submit a new patch to make coccinelle happy.
-Doug
