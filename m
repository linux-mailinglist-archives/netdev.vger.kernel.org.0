Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB815F7D91
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 20:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJGS7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 14:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJGS7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 14:59:41 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39E95B1
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 11:59:40 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g10so1462765qtu.2
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 11:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M1mtKAPPcZg/kGWu5/9mS7PSxVW8IExZ5DLsDPW2Nvw=;
        b=AkIdWNHAOOCyDRBUf7qKK6z5FOEz4NkpwjqHZ3QhXjSENe1feJSvVkf8iHYuTfTyZD
         T9S3n+8FYR5ufQPLXYmY5443L1qovNug+RQwN9fy/j5pxpI+lnnQN2ILz12etFQIH580
         JQz2e/EU7mG3YVFJ+HDKIYyk/jYJE0JZrOm00s2n3yCZBnLIa9oJm7A7/d77m99nRntI
         xPil/Ur3cU0zVRB7YUFA5QVy/OaizONL3wKsRff7WGvKlrmZXunXiGkMiCwh/1868hX+
         hvq3L2zOJuxK/7zJQ0ghKh16Tq1EUeWHrVFpE0D0eWtYzK3nMLOGafj+sktKNjooZ36X
         kOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M1mtKAPPcZg/kGWu5/9mS7PSxVW8IExZ5DLsDPW2Nvw=;
        b=GTsh4jKHmCkmDwgiFMZwuZxOdem8m67gJ1amWclgIfZMUA9tpAGsw1wAr2pCoPBr/B
         GhCNJhD1Cye30EV6GKETh7EunJ5UMd9GVJ/QVZPpthGhgkei94n9DnO16mx/1vJFC3xL
         1yuI1xn+s5YqKyrccwzv6gPUtGA3lRpc24CQTgagJQzHQwyXpJ3Y0LsZqOG6eHJWfNkY
         fEM53p72sSKHs1TFWETofGkb5VxRGwspu20yPwfBt1fL9uJEYegjjcaGz4Mh+Nxisnsp
         FjvgfGU1G9NaH6wIekFG88Pwg2whcFbqyDphYaeckS8kydPNLAL2QIeZzjSv0nochm0E
         //0A==
X-Gm-Message-State: ACrzQf01Uz+rYpVV8urVHROqVGMsvky75r+OxqcVKRHZ8+XwwzhxJnzC
        PDT/4HBhjl5H7PTawnLwnoEq7B7uYn8=
X-Google-Smtp-Source: AMsMyM6ydFfkN/v4pEKKgE5uFODKQbsnLHRey9wBPiwpX0IAz5+CRULzgz9MDcBgZHHnGvsUVvV8LA==
X-Received: by 2002:a05:622a:4cb:b0:388:aaf0:62bd with SMTP id q11-20020a05622a04cb00b00388aaf062bdmr5481244qtx.337.1665169179118;
        Fri, 07 Oct 2022 11:59:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h7-20020ac85687000000b00391766f84a6sm2657426qta.78.2022.10.07.11.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Oct 2022 11:59:38 -0700 (PDT)
Message-ID: <792d59c8-37db-3d2d-47eb-34801aa20ef7@gmail.com>
Date:   Fri, 7 Oct 2022 11:59:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: netdev development stats for 6.1?
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20221004212721.069dd189@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221004212721.069dd189@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/22 21:27, Jakub Kicinski wrote:
> Hi!
> 
> For a while now I had been curious if we can squeeze any interesting
> stats from the ML traffic. In particular I was curious "who is helping",
> who is reviewing the most patches (but based on the emails sent not just
> review tags).
> 
> I quickly wrote a script to scan emails sent to netdev since 5.19 was
> tagged (~14k) and count any message which has subject starting with
> '[' as a patch and anything else as a comment/review. It's not very
> scientific but the result for the most part matches my expectations.
> 
> A disclaimer first - this methodology puts me ahead because I send
> a lot of emails. Most of them are not reviews, so ignore me.
> 
> Second question to address upfront is whether publishing stats is
> useful or mostly risks people treating participation as a competition
> and trying to game the system? Hard to say, but if even a single person
> can point to these stats to help justify more time spent reviewing to
> their management - it's worth it.
> 
> That said feedback is very welcome, public or private.
> 
> 
> The stats are by number of threads and number of messages.
> 
>   Top 10 reviewers (thr):            Top 10 reviewers (msg):
>     1. [320] Jakub Kicinski            1. [538] Jakub Kicinski
>     2. [134] Andrew Lunn               2. [263] Andrew Lunn
>     3. [ 51] Krzysztof Kozlowski       3. [122] Krzysztof Kozlowski
>     4. [ 51] Paolo Abeni               4. [ 80] Rob Herring
>     5. [ 47] Eric Dumazet              5. [ 78] Eric Dumazet
>     6. [ 46] Rob Herring               6. [ 70] Paolo Abeni
>     7. [ 35] Florian Fainelli          7. [ 65] Vladimir Oltean
>     8. [ 35] Kalle Valo                8. [ 58] Ido Schimmel
>     9. [ 32] David Ahern               9. [ 58] Michael S. Tsirkin
>    10. [ 31] Vladimir Oltean          10. [ 57] Russell King
> 
> 
> These seem to make sense, but the volume-centric view shows.
> Note that the numbers are very close so the exact order is
> of little importance. The names should be familiar to everyone,
> I hope :)
> 
> 
>   Top 10 authors (thr):              Top 10 authors (msg):
>     1. [ 84] Zhengchao Shao            1. [287] Zhengchao Shao
>     2. [ 52] Vladimir Oltean           2. [232] Vladimir Oltean
>     3. [ 43] Jakub Kicinski            3. [166] Saeed Mahameed
>     4. [ 28] Tony Nguyen               4. [156] Kuniyuki Iwashima
>     5. [ 28] cgel.zte@gmail.com        5. [134] Sean Anderson
>     6. [ 23] Stephen Rothwell          6. [122] Oleksij Rempel
>     7. [ 23] Hangbin Liu               7. [106] Tony Nguyen
>     8. [ 20] Wolfram Sang              8. [ 93] Mattias Forsblad
>     9. [ 20] Kuniyuki Iwashima         9. [ 93] Jian Shen
>    10. [ 20] Jiri Pirko               10. [ 86] Jakub Kicinski
> 
> 
> Here Stephen is probably by accident as I was counting his merge
> resolutions as patches.
> 
> What is clear tho (with the notable exception of Vladimir)
> - most of the authors are not making the top reviewer list :(
> 
> 
> And here is the part that I was most curious about.
> Calculate a "score" which is roughly:
>     10 * reviews - 3 * authorship,
> to see who is a "good citizen":
> 
>   Top 10 scores (positive):          Top 10 scores (negative):
>     1. [4102] Jakub Kicinski           1. [397] Zhengchao Shao
>     2. [1848] Andrew Lunn              2. [116] Kuniyuki Iwashima
>     3. [737] Krzysztof Kozlowski       3. [105] cgel.zte@gmail.com
>     4. [620] Paolo Abeni               4. [ 93] Mattias Forsblad
>     5. [611] Rob Herring               5. [ 82] Yang Yingliang
>     6. [588] Eric Dumazet              6. [ 82] Sean Anderson
>     7. [429] Florian Fainelli          7. [ 77] Daniel Lezcano
>     8. [418] Kalle Valo                8. [ 68] Stephen Rothwell
>     9. [406] David Ahern               9. [ 67] Arun Ramadoss
>    10. [344] Russell King             10. [ 64] Wang Yufen
> 
> 
> Now looking at companies.
> 
> [Using my very rough mapping of people to company based on email
> domain and manual mapping for major contributors]
> 
>   Top 7 reviewers (thr):     Top 7 reviewers (msg):
>     1. [369] Meta              1. [640] Meta
>     2. [139] Intel             2. [306] RedHat
>     3. [134] Andrew Lunn       3. [263] Andrew Lunn
>     4. [127] RedHat            4. [243] Intel
>     5. [ 80] nVidia            5. [193] nVidia
>     6. [ 71] Google            6. [134] Linaro
>     7. [ 61] Linaro            7. [121] Google
> 
>   Top 8 authors (thr):       Top 7 authors (msg):
>     1. [207] Huawei            1. [640] Huawei
>     2. [103] nVidia            2. [496] nVidia
>     3. [ 96] Intel             3. [342] Intel
>     4. [ 94] RedHat            4. [332] RedHat
>     5. [ 75] Google            5. [263] NXP
>     6. [ 60] Microchip         6. [170] Linaro
>     7. [ 59] NXP               7. [157] Amazon
>     8. [ 51] Meta
> 
> Top 12 scores (positive):     Top 12 scores (negative):
>     1. [4763] Meta               1. [887] Huawei
>     2. [1848] Andrew Lunn        2. [145] Microchip
>     3. [1432] RedHat             3. [105] ZTE
>     4. [1415] Intel              4. [ 95] Amazon
>     5. [ 680] Linaro             5. [ 93] Mattias Forsblad
>     6. [ 652] Google             6. [ 68] Stephen Rothwell
>     7. [ 627] nVidia             7. [ 59] Wolfram Sang
>     8. [ 609] Rob Herring        8. [ 57] wei.fang@nxp.com
>     9. [ 429] Florian Fainelli   9. [ 56] Arınç ÜNAL
>    10. [ 418] Kalle Valo        10. [ 53] Sean Anderson
>    11. [ 368] Russell King      11. [ 48] Maxime Chevallier
>    12. [ 356] David Ahern       12. [ 46] Jianguo Zhang
> 
> 
> The bot operators top the list of "bad citizens" as they do not
> contribute to the review process. Microchip and Amazon also seem
> to send a lot more code than they help to review.
> 
> Huge *thank you* to all the reviewers!

One statistic that I would be curious to have is the ratio of features 
vs. fixes and who fixes bugs from others versus fixing their own bugs.

Interesting stats and thanks for putting those together!
-- 
Florian
