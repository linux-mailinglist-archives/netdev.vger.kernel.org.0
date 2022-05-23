Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B5E531A7D
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiEWSYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244802AbiEWSWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:22:19 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2CE3B3EE
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:57:52 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c14so14381364pfn.2
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j+7dhXfVvjhX8uGEoOhhhickUwEypMlAs/PweuGboy8=;
        b=jIYLN5rTKBzojVvK92O0WiIT5gttMHCULZeydTf1gRNO1R0juDaXLx4Cs5B7SX4+/g
         BbU7KOa5QY8rkJ58gFwfgzJiGzSV9ocx9ocIIMz0PgXPhZB4UVhRAYdus63tDi4nwGNO
         8T0RO2+5smo4hyaHnR38Dw9OPDSz/WyUNL4uRDY38nsq0j2qJ6g7ZdFqi3WDJt8G3Weu
         juJYgLk/GWx66WQvgxrwNlWRQ01As/CdXvk1RoLn7XQPFsk9I6a8SjvmkeqT5KVS9yhR
         Gtf0nzD7O5c5TyKMy53VVsw5F8DYXzxJlKcaysMVP+aqgyfjaEfyFB6Q7PoQi+2pKIaJ
         7gHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j+7dhXfVvjhX8uGEoOhhhickUwEypMlAs/PweuGboy8=;
        b=yRbf+VwQVH0+nric36CsNilgDs4n8rtXGTiVL1DP+aOjGOPYdZjoNlw/8ElouSg5Ve
         MgNiKl/lCmDMjyDKvUSPH6MB5IoFTSrkJlw/I1iHMQYYCK7eQGY8Z5XHFKN4Y77AbwGp
         r33SrVmGxd/SwwXl9UgTeyHVmMJbeKd7pbjW6rpchaoLzHVtro5fiy3oj3O++NQVp7R+
         Fs+9kJBPm8PU+B+yHmNhBXJcLopTziZ+9MqPqw4kH8uLMlkvcUHOB34DAtOK7BVeR2ka
         WGjJAuAfersjQWYOf4DGvI+GXi4EhXF6SB4Iqbl5ZmIs++q96bfvD16z+IygbVUI8xSQ
         +vaw==
X-Gm-Message-State: AOAM531cfUln6FoFlIOA3jNEppT0BHoSwoYwOK1MUziIrk4QARaPtJii
        uCrHIws7M9AnR5K4YtffaHo=
X-Google-Smtp-Source: ABdhPJx/vfKrzFtbmI6EOf7fSVsCmxJROLz2A5/nnIyT6JF9Pyb3THTabAah3NPvJiMPDDjTZ25a4g==
X-Received: by 2002:a62:6410:0:b0:4f3:9654:266d with SMTP id y16-20020a626410000000b004f39654266dmr24386387pfb.59.1653328670923;
        Mon, 23 May 2022 10:57:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o13-20020a17090a4b4d00b001df264610c4sm336314pjl.0.2022.05.23.10.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:57:50 -0700 (PDT)
Message-ID: <8dde51cd-d59a-b55e-2cc1-53aafb1f399a@gmail.com>
Date:   Mon, 23 May 2022 10:57:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 04/12] net: bridge: move DSA master bridging
 restriction to DSA
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
 <20220523104256.3556016-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-5-olteanv@gmail.com>
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
> When DSA gains support for multiple CPU ports in a LAG, it will become
> mandatory to monitor the changeupper events for the DSA master.
> 
> In fact, there are already some restrictions to be imposed in that area,
> namely that a DSA master cannot be a bridge port except in some special
> circumstances.
> 
> Centralize the restrictions at the level of the DSA layer as a
> preliminary step.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
