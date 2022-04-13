Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFB54FF08B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiDMH3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbiDMH3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:29:46 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB303CA76
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 00:27:26 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c6so1274512edn.8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 00:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qs/d6eRMsE3W5PauvBIvDHu7IP681Nr7sUF8OehanNA=;
        b=AY5+QQmby5D8nvGvA7iUqTaPU5tTPAIrk1g+XO3Z8dXZ4ra0Zjjmw42wd+4nTl01h9
         aEpnG+VL5SOMivcSneQAYKHQ8COdjSl6fATqvWjadCiAjnLjdpfgjeCi8CBouEMXlcUr
         CI9Adk9z6cLmT5DJ5L2UEd/XnDliz1O0xXDdbFjYSj7v1Ixz/ZjBQlUQyiKC3/d49ZtE
         bmmzQ0LExw2KPzX5dAJtHi1kBjtR23us4tKUujOnDgwWPQl0DfAMZjuIJXPvPXcwCJBA
         swWvDoSO8HSEi0y9hI2k5s1shuEG4WvCnDMn2x4KmQ2zxiOgjavZSXaALtTq51jowkTt
         lW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qs/d6eRMsE3W5PauvBIvDHu7IP681Nr7sUF8OehanNA=;
        b=qKvLaSMLSoXNE1aYBLamTHu4BSbhOS/E9arcHM9cLin/soDLa7rxso+4mSJn+CMNTF
         0AFkRvH6/D5IcdLl8nyYNw6QIFTDMDNNObue8lciP2rjq/nGTxp3zqkUChZcmzicz7Ea
         +oWDxZ5oMeddkIz6LCvttBg5J8Xl3Ymnp+Md79vMcnfzj1ZiMkE9jNieJ4eCMSb558j1
         IRx8rU4dcppLkg5pAl8nn/FKSCeWR+5+VvMSD/cyHmABzFhjgJxyakJfdFdV9VY3cneU
         4KKuGc1w2d2hQkQJnalBBKFkTAkgX0ycxmBon+R/IYQQtLOx/UCEI6Ri1jGPOHUU2jEJ
         KCyQ==
X-Gm-Message-State: AOAM531yXYaglgdaGwfnkz1Ntz+qix41RVYzow+LVfgT440BOJCBxa7G
        iG3Ifr9iYgAd77NAPnGX4aKnRg==
X-Google-Smtp-Source: ABdhPJxxBelGL9yLtiPd2tUkQahvRnMC7+6ddweJr5oxgAC1w1X4b7KtEQgCuSF01Q3H9tE8ruY9vg==
X-Received: by 2002:a05:6402:1941:b0:413:2b7e:676e with SMTP id f1-20020a056402194100b004132b7e676emr43135760edz.114.1649834844592;
        Wed, 13 Apr 2022 00:27:24 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id a13-20020a50858d000000b0041d71502d2dsm834520edh.13.2022.04.13.00.27.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 00:27:24 -0700 (PDT)
Message-ID: <b9059a6e-353d-dea0-0d55-27829c8f51ae@blackwall.org>
Date:   Wed, 13 Apr 2022 10:27:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 0/8] net: bridge: add flush filtering support
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220412132245.2148794-1-razor@blackwall.org>
 <c418e95e-440e-0502-58f2-63179f370a98@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <c418e95e-440e-0502-58f2-63179f370a98@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2022 05:04, David Ahern wrote:
> On 4/12/22 7:22 AM, Nikolay Aleksandrov wrote:
>> Hi,
>> This patch-set adds support to specify filtering conditions for a bulk
>> delete (flush) operation. This version uses a new nlmsghdr delete flag
>> called NLM_F_BULK in combination with a new ndo_fdb_del_bulk op which is
>> used to signal that the driver supports bulk deletes (that avoids
>> pushing common mac address checks to ndo_fdb_del implementations and
>> also has a different prototype and parsed attribute expectations, more
>> info in patch 03). The new delete flag can be used for any RTM_DEL*
>> type, implementations just need to be careful with older kernels which
>> are doing non-strict attribute parses. Here I use the fact that mac
> 
> overall it looks fine to me. The rollout of BULK delete for other
> commands will be slow so we need a way to reject the BULK flag if the
> handler does not support it. One thought is to add another flag to
> rtnl_link_flags (e.g., RTNL_FLAG_BULK_DEL_SUPPORTED) and pass that flag
> in for handlers that handle bulk delete and reject it for others in core
> rtnetlink code.

Good point, it will be nice to error out with something meaningful if
bulk delete isn't supported. I'll look into it.

Thanks,
 Nik

