Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7C56BEF30
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjCQRHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCQRHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:07:24 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB52F41B49;
        Fri, 17 Mar 2023 10:07:15 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id hf2so2173117qtb.3;
        Fri, 17 Mar 2023 10:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679072835;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HHDNFKlzPKm41Vj542DcCAfkJZWlbNsqPKCvtIP8vJ4=;
        b=XjNWNomLsD2H+hnsrt5OWjhdG31CzbIN0yVEilGX3mkm+IIp7lZdlxR9lj2NPpcX4c
         64CsyX5wEtZfKM1sv22Y81RJqvBhbcupdafg1QFFA3aB9pRMSXys1Vgvv0oUKPhllIjz
         HQ7cJUJJI/kcOPM5sDWaaMiSebxW+PEkmuLv9TlfSKnpeBiGdLZayZfbFRf9xsHXZNb7
         UKetT6df3G7KZ6Gs7RCb541dXc4LHHFOeV32GscHrU2HBab7yNTYSjKwgMB57XpY0Ra+
         aE8ln2KwzUE7Bz8V5k88EbofuPaL7h6ZR8rTvQ+K7arOrDhQ8yVgrV3aOsHDwHaBadn7
         IaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072835;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HHDNFKlzPKm41Vj542DcCAfkJZWlbNsqPKCvtIP8vJ4=;
        b=emjQlMIyFivfGH/Mm/F9lxTlaY0vBadK43mc825r/CLn/KuvODD+jdZ3F+iN36kNfM
         Efj6dFAQ8iqahYBItHqbtKdypp7K+dLswT9VTdwX8jXfvCBM1AhCVG3rTkby/ZnK/lmp
         fUqDq1P1NVju8XbUvLWinY5RxTHT30SeTCPVSCJZ1fBH8SkyvEIMGyhSKYwRo6LsCFrW
         TrIQxaZlE7/e4T2QMh6Pse3XakpZAXDPI2cp3R3Fca7PrknjjSgmJwe9F+dDf3pZsv7I
         loG47WkKJw/aoAqETkRsvrbjbjC8DAwZkGjHu8bm8bSMk+r9Zqyjj5VHt1r2oykNbDIy
         dbYA==
X-Gm-Message-State: AO0yUKVYnFBLYn+uTgGjcCccC4sVeRznHQ/jYcL6vtJGwxzUwF5XVPPU
        mYDZ7MxsWlx2yyzv2irngPA=
X-Google-Smtp-Source: AK7set+ALfIh/Qn/7aX9J4jJME9Ko4n3WhqcxYipxutkc6Af4Rz57L5Lp69vhBU70yCWkTxjwS3xfw==
X-Received: by 2002:ac8:574e:0:b0:3bf:c69c:e31c with SMTP id 14-20020ac8574e000000b003bfc69ce31cmr14573624qtx.13.1679072835535;
        Fri, 17 Mar 2023 10:07:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i16-20020ac871d0000000b003d9a69b4876sm1817388qtp.11.2023.03.17.10.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 10:07:14 -0700 (PDT)
Message-ID: <9b000248-172a-057c-e2b4-be93d2551dce@gmail.com>
Date:   Fri, 17 Mar 2023 10:07:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4 2/4] net: dsa: mv88e6xxx: re-order functions
Content-Language: en-US
To:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-3-klaus.kudielka@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315163846.3114-3-klaus.kudielka@gmail.com>
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

On 3/15/23 09:38, Klaus Kudielka wrote:
> Move mv88e6xxx_setup() below mv88e6xxx_mdios_register(), so that we are
> able to call the latter one from here. Do the same thing for the
> inverse functions.
> 
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

