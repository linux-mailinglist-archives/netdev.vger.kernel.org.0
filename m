Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B69581E57
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbiG0Dmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiG0Dms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:42:48 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D080C3DBE2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:42:47 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c3so12501134qko.1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pgPJ8eMOtii6HPDOXYyIBNayCWz8A4v4gUjlHFL7ZbE=;
        b=PYOwcR/ELe5kyNC70JxjwNNEP3srbg+82OYO5TMi5YnLqqq2opYVXxV1pfmJs6df8M
         ApGyLczB4BKZVtPudVSkBYXLAvpf+EXPSuSolpgkUXzEPu1pgMrpFA7x+enUjJz1mMFg
         dyoprxU9Xu4wCmMfFOy1ksT7HqVRawBM+F1NXPdxfCjLHLm95YoPY0b0K1rMr+NXBcZF
         eR7eCRJWEdA77xoRt32R6dHhzCwad0QAlb6n9KSlgaEFgtyDUSk7VlItymGAvbYN3EAt
         Ds3T7x+FCQ1stI6W2PDVZssIoN/wi2oby/dg8n+O7abhsFKzebuRSXNsPneJu/yBcZEY
         8C5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pgPJ8eMOtii6HPDOXYyIBNayCWz8A4v4gUjlHFL7ZbE=;
        b=viOSgSnolxEvIJXFQVu8/UvQdjmKWc6yrZfEg4jQr8k8vIJbQzZXfQvSVO9iyFBuqi
         41u0gxedTwUajpSM/KHgjVEGuJtMj1lzDNPMqX+c4+RnQ3EPCmTILU2ICS4ADm/B/M/b
         k9+Ueg/CDQbuH/BNwbXP/NNDfqSuybcjOJhlRuYZG6ktUifuORZ0iYyCE0vjc5vxO6PF
         NAbgH3TS2J7B12Zx/uOJumHP5op/KtoT21bh4CMZpiX69wPAVnWFJbtKezsbsG1mpZIG
         o1hzLhM7Sa9WorOq0L2YPUmFTiNvAKyzRyuHkzyHtaShPhlh/yhh9s23k8WeM48iTN4s
         PJXw==
X-Gm-Message-State: AJIora9Ms7DkOBZBXiZ71KU/p+bwzFWa0tcifOUPujwn465Hoh0jPfYj
        kTNyIl/WtTKBxcGlE3iwdSJ5ZixhRXU=
X-Google-Smtp-Source: AGRyM1sRw3OOrfwqY8JWPROixoqaVELKQPUC5YUuQdnZjfi7qS7EvhzQ47Qi8i73WPiwk4zTAforyw==
X-Received: by 2002:a05:620a:438a:b0:6b5:f985:7741 with SMTP id a10-20020a05620a438a00b006b5f9857741mr15382466qkp.605.1658893366104;
        Tue, 26 Jul 2022 20:42:46 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id ey14-20020a05622a4c0e00b0031f0ab4eceasm10378967qtb.7.2022.07.26.20.42.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 20:42:45 -0700 (PDT)
Subject: Re: [PATCH 1/3] sunhme: remove unused tx_dump_ring()
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>, netdev@vger.kernel.org
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <12947229.uLZWGnKmhe@eto.sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
Message-ID: <34c386c9-483a-f2c0-52e0-35dfcd3b03bd@gmail.com>
Date:   Tue, 26 Jul 2022 23:42:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <12947229.uLZWGnKmhe@eto.sf-tec.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 11:21 AM, Rolf Eike Beer wrote:
> I can't find a reference to it in the entire git history.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---

This is probably just there to be enabled for debugging. In any case,

Reviewed-by: Sean Anderson <seanga2@gmail.com>

