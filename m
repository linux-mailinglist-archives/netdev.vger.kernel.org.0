Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C2F531C17
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbiEWS2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245457AbiEWS1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:27:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01552A33B4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:02:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t11-20020a17090a6a0b00b001df6f318a8bso18161288pjj.4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aPCmu/nmh4/34jQRsqZ/S+UicCj4+xChwquCkhBAM0s=;
        b=YvAER/qB3McKn3aWkwxve0Qk0/7gWBqJLBL6MbTVmyJ2g1IwXDT7KWLODgaLQ/utBr
         bt0Z0iGHsFNGoiLYpDZ8yRUNQTObrDpH9l4631FKUuLPg74VEtRnC47S6JoUJRJEzp68
         cFQ8DpGKM6K+oGirFtbI/hINbzrJNxUxW3hLXaHqSStFjLyw2vj51jCUKue1eQm9bXG5
         afiQQjPKKR6vxFVaQj4n6a1i+jOjsszyTwh6gCgsc6F5+1vecFYUlWjRmDDGqKKEe5hG
         +mZeyRdyFo4F9RKoI2LaNXoyZ1Luydgh5Q6YFitgCqMYJVCoEln//T4/kg33O3jxA+ya
         Dqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aPCmu/nmh4/34jQRsqZ/S+UicCj4+xChwquCkhBAM0s=;
        b=RAQQuzsaWkEh2C5PQmQfmDNZvUaAgmN5J2OikLG5r19hz+15syN+9ihnq6TOse9fOR
         5zGDFBJhGZ8PLnR/7IILU+YzfqL3J230YDLpIeTSaERO4gzdRR5j3/Juf5HhtiTZeR7X
         I4kVq2RIZi2mYVtftWRxE/OqcJmH/p1/b2vp5FJVMF+C5DiCgLfVMwdAc8eWD/Dr1DMo
         cLoKZFMOtMhyYUq2chE+BaRMTi5sWKyrvxY+1I4uVw4/awauAijY9kC8QadSsfp9n8QB
         ifrVRWnlpINsyLppXMn1qvEiOtuqB4wl78ovm4wOleMNrI4a0dQR3vYdaAa7FNXkdLJO
         0IAA==
X-Gm-Message-State: AOAM533wMAbcr7Ah7fT86++Pd/4gFRO1GTekPBbhHaNi2ATO2nL33Pra
        4xf6YwyPDtWXv5LmV8H4WBU=
X-Google-Smtp-Source: ABdhPJw17q91Rq1LJrIAc5j8+gvqEgfupBSLkM7giOUg6WXUI2I+iIZ5i5ilV7rTrXxMnoOh/0LycQ==
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id oo14-20020a17090b1c8e00b001bf364cdd7amr192510pjb.103.1653328910226;
        Mon, 23 May 2022 11:01:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m26-20020a63711a000000b003c6a80e54cfsm5089335pgc.75.2022.05.23.11.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:01:48 -0700 (PDT)
Message-ID: <fb014933-75a3-4d52-114a-daa3748f4a4b@gmail.com>
Date:   Mon, 23 May 2022 11:01:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 08/12] net: dsa: use
 dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-9-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> More logic will be added to dsa_tree_setup_master() and
> dsa_tree_teardown_master() in upcoming changes.
> 
> Reduce the indentation by one level in these functions by introducing
> and using a dedicated iterator for CPU ports of a tree.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
