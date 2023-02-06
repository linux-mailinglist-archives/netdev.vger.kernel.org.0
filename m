Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A500268C5D1
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjBFScJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBFScI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:32:08 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E000A2A16D;
        Mon,  6 Feb 2023 10:31:50 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id x10so6914754qtr.2;
        Mon, 06 Feb 2023 10:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kNo609hNLygRwZAs+RWQ8ZATt1cgXJ3mxrB2KJ875DA=;
        b=pKk/OrVw60njtdSxvCUByq6BEazdtLlnWxvS17pAOH3AU1kd+97JEHtXJnlxNVrdqv
         MRqMrHiEIwOIJexVtZuBKxfsPn0SH9wRwjZJymK+Ek9QKV7+7ddjuRI7VG/QpoEtztna
         r55z6aJmSPPJOg07jEjwGhU54w4Q2Lc+YT17atIOeni5kAeZJGTo2qynVU5OG6r4rcz7
         th7CHxCPnrhqD3TILC6GaaxGpkwT2NEZO8jqck/oVhWUhYOpwMoFgnOgZRfsoFvZKULh
         +hMsKRJ3p4JaBVcRACPnKTA34OtIJuxcnLKcWAhWHRIE+3ilVtRQXOpVO4htCvLv9Z9F
         IDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kNo609hNLygRwZAs+RWQ8ZATt1cgXJ3mxrB2KJ875DA=;
        b=I8Hp5oJttJ7qi02PrfmNCEHNNmcXkcvKHaAnE/TZnGKC9xpdfa5/amuZUL1ckiHDUS
         7H9cRbYJeBj9hQuYBadI6oxh0Danpr6W2PO6Zr4heQETNeOAHVfb7fJMQS/WgCZXDWc0
         mwibx1YTBnjeh6Dy1n/gPP4xW/fQxNfTZkfK8FFZHWUfQlZdmEayP8jLw3514lpVmsfb
         xuQB81hxNPFLSpKF8mQJ3rNSTfy6TairtEW/iSwVaXcvAuzGpIuRQKxOkWTrszemDGYP
         ps6TLjwQ51tKpJPCbAD7KEswsnNHSIV9n/q46qw0HQJ3rFthyl+2ZprE+pZWcAnr6K/t
         PBnA==
X-Gm-Message-State: AO0yUKVD9NtktyLudrzUNXPPf+4/d6/lQswdNsxFvSOiGM6HoAwNv2PJ
        5s35OyASOx8reljr+k0oULw=
X-Google-Smtp-Source: AK7set+VlV4oqHJzTKyy5neUSf+X1hIcxkr2IxC20G/iSn6nGX33kzKFJ0lBudQwsoDbbpqHJQguEQ==
X-Received: by 2002:ac8:5a8a:0:b0:3b9:c0b4:8afe with SMTP id c10-20020ac85a8a000000b003b9c0b48afemr1036410qtc.2.1675708309928;
        Mon, 06 Feb 2023 10:31:49 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k19-20020ac85fd3000000b003b0766cd169sm7977527qta.2.2023.02.06.10.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 10:31:48 -0800 (PST)
Message-ID: <e75577bb-df33-b0dd-42d9-a34e5d65887a@gmail.com>
Date:   Mon, 6 Feb 2023 10:31:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net-next] net: mscc: ocelot: un-export unused regmap
 symbols
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20230204182056.25502-1-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230204182056.25502-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/23 10:20, Colin Foster wrote:
> There are no external users of the vsc7514_*_regmap[] symbols or
> vsc7514_vcap_* functions. They were exported in commit 32ecd22ba60b ("net:
> mscc: ocelot: split register definitions to a separate file") with the
> intention of being used, but the actual structure used in commit
> 2efaca411c96 ("net: mscc: ocelot: expose vsc7514_regmap definition") ended
> up being all that was needed.
> 
> Bury these unnecessary symbols.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

