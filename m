Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369B1565268
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiGDKdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiGDKdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:33:06 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70415DF9D
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 03:33:05 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id fw3so15927457ejc.10
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 03:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=6Wj87YaxYO/pynZWsS9SuS5fRYRtHj/q6P5VHFbekcg=;
        b=hHKaBdrQ6fJzL+ZL80h+cgSUCPd7+qjDIzGZh8ZWXaChkI5ruA0hp/l+FutHmw9JoV
         W0Ju8bPTVp3GHKVT62HFG73xi017s5mw3lBMxF75N78qHcsgGQv2bqrAj2T5IZkuLRs0
         SiZRY1f2gYqNP7Bm0x86EyLaekNUeVbtUK7WX7p46lcGYODJTm7vzvtBgL8sILSDYoU7
         mTBcJDP4eDs4crZZH2zeDnE3W4M6D6uTY/KhJZv/S7ehDHhZMCAokUixesEVWtGT8mps
         F/BE/qrRiaHtdoRFoE4sXEQtWZG2GpR7A59NNr7EhzOE1LlCAOIYGddTa9T9qupo/uu8
         s3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6Wj87YaxYO/pynZWsS9SuS5fRYRtHj/q6P5VHFbekcg=;
        b=k46y71rCzLOGWtJR2Ga6Ana5YOUp/h8eI49dHj9ij+qsJOhXNZMGnBSc6EaLejJ/Ic
         bNq4+ZJ8Oy7aHE703/y0IdG5W/MbhxupET2CnulmYmm25ofgLwA0KmpR2FZ9eZBPqGVI
         V9894jdwhQKjVLAWoSm6HlqQcQ/uEIvc9LZDGc8IFNduDc1RYk8vJUVO8xoLpZ0HpwP4
         L8zxIP2fEKB5spo8R83t9Mz2cQUrYNsrJlmM/KKGCtr4ll3ag4Wbpw7U60S7O7U4Qy7c
         iKLjNDLGFtmzZIraIPleAAF/SB6K2v1NFkT5XQE5XvIiDo0nmSjh+fnX0zIjHGUbmjI8
         A8hw==
X-Gm-Message-State: AJIora8+Gh7th2wCTCvS7I0zaq541wv0QLnegRcWVpiPkn/ylwJJjbPf
        E24BDFbboXcdnI+N/ndpt9/vDg==
X-Google-Smtp-Source: AGRyM1vj6eWksKadqFD0/n9jE3teDazJGledsxiH91AYbeqgMPTaRoHxC9NTg8B8zmoTjCDFh48tJA==
X-Received: by 2002:a17:907:1c18:b0:72a:3945:c1b2 with SMTP id nc24-20020a1709071c1800b0072a3945c1b2mr25693220ejc.604.1656930783896;
        Mon, 04 Jul 2022 03:33:03 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id k13-20020a170906a38d00b006fed787478asm14169345ejz.92.2022.07.04.03.33.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 03:33:03 -0700 (PDT)
Message-ID: <c33c78f8-2be0-07bf-222b-9fae70f9ba32@blackwall.org>
Date:   Mon, 4 Jul 2022 13:33:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] selftest: net: bridge mdb add/del entry to port
 that is down
Content-Language: en-US
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
References: <20220701144350.2034989-1-casper.casan@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220701144350.2034989-1-casper.casan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2022 17:43, Casper Andersson wrote:
> Tests that permanent mdb entries can be added/deleted on ports with state down.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
> This feature was implemented recently and a selftest was suggested:
> https://lore.kernel.org/netdev/20220614063223.zvtrdrh7pbkv3b4v@wse-c0155/
> 

Indeed, please CC the people who have suggested it and the bridge
maintainers next time. :)

That being said, thank you for the selftest!

Cheers,
 Nik


