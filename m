Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5088F529CEB
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243031AbiEQIuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbiEQIuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:50:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DB043AF7
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:50:14 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f2so16722850wrc.0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=D7xA7xmVuUqjudjIYk0zjw6nvG2QtLme021bo4+G01M=;
        b=PsK6zxdWYJT522WT0TFmVULW7T3n1LbvAJ1Lu1v9SEovbdK1epk5mJ5edk+kxtfKod
         xah8ppRXgtqD4ffkkLbNNteZ3WCn2Zv0NhKJuRhaeiVOb2O/3uZx5+A/VNdbbKtzZRc7
         oiNGS0gx1JaO3WZVx/CWhNtrh/TetCREELfAkOod/8SyIC9Xum82azT28mGbzWpogO8R
         rTfTDAywMkfIn3HzjclC7ygZ7rp7Jht2BjIzuk59bMsrKOpYZPVWfVcnTuuTQdUiok16
         cQAjsmSy6Yz2EXpVQlHQaOoeUE0j/P4n8kHjrOPZW+zu+vAKSibA2X7kV9ENXfdrgCeK
         F59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D7xA7xmVuUqjudjIYk0zjw6nvG2QtLme021bo4+G01M=;
        b=VIWrwA85PaNKoN84QKdlUUPcGvEpxd+uj9IsbM5yi2DKKjNwX3ECYgFvloo9WPLHIq
         zo1j6pnPK557AIRB8OZwyzE4aSSLD+gmL1jnRhV+wLHRWgQk0A5+bkHZREX7YIXihiV6
         dy+Kzxmd1m8Ee9lJZjwGwU+mmAgM62mwF8u1bgjbtcNyJFPg3Gi5onICsEJyDl8Ft4Gj
         gj7jrlV4PxilMHUkZaEoQESR7tBciNe9u6hwqDb/4tzEoAFMeJKoWW1bWS3q9XsZZZk1
         enis7mt0LZyx3VsVB5g1gIy397R96jPjoxwnQNe46wt7I01nFd72dAYOsrMiGlngGnrU
         qm8w==
X-Gm-Message-State: AOAM533HGZ2C1sioWPYVRsG6FuG+HL1BXjLwJ9fIYuBWu+54kgeiONok
        3kZKSRF9BW65gy1portWD9afZg==
X-Google-Smtp-Source: ABdhPJzIE3BC1LuwgVGlibxktqUbejcz+lqZWh5gzQppDopSsXQ6h/JHnwlOTcO4UEd9VskrcH7e5g==
X-Received: by 2002:adf:e0c3:0:b0:20c:5672:9577 with SMTP id m3-20020adfe0c3000000b0020c56729577mr17395216wri.466.1652777412964;
        Tue, 17 May 2022 01:50:12 -0700 (PDT)
Received: from [192.168.1.200] (bzq-82-81-54-179.red.bezeqint.net. [82.81.54.179])
        by smtp.gmail.com with ESMTPSA id r14-20020adfa14e000000b0020c5253d8cesm11598680wrr.26.2022.05.17.01.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 01:50:12 -0700 (PDT)
Message-ID: <3f9341de-ae8d-2bc2-a8d0-bda3ec5f91e6@solid-run.com>
Date:   Tue, 17 May 2022 11:50:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v4 1/3] dt-bindings: net: adin: document phy clock
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Walle <michael@walle.cc>, alexandru.ardelean@analog.com,
        alvaro.karsz@solid-run.com, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        michael.hennerich@analog.com, netdev@vger.kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org
References: <20220510133928.6a0710dd@kernel.org>
 <20220511125855.3708961-1-michael@walle.cc>
 <20220511091136.34dade9b@kernel.org>
 <c457047dd2af8fc0db69d815db981d61@walle.cc>
 <20220511124241.7880ef52@kernel.org>
 <bfe71846f940be3c410ae987569ddfbf@walle.cc>
 <20220512154455.31515ead@kernel.org>
 <072a773c-2e42-1b82-9fe7-63c9a3dc9c7d@solid-run.com>
 <20220516104336.3a76579e@kernel.org>
 <ab86220b-f583-4c77-0ddf-a3e25f5bc840@solid-run.com>
 <20220516154044.29361acc@kernel.org>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <20220516154044.29361acc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 17.05.22 um 01:40 schrieb Jakub Kicinski:
> On Mon, 16 May 2022 22:48:20 +0300 Josua Mayer wrote:
>> So I can imagine to change the bindings as follows:
>> 1. remove the -recovered variants
>> 2. add an explicit note in the commit message that the recovered clock
>> is not implemented because we do not have infrastructure for SyncE
>> 3. keep the -free-running suffix, we should imo only hide it on the day
>> SyncE can be toggled by another means.
> 
> SGTM, thanks!

Thank you for your comments, I am sending v5 shortly!
