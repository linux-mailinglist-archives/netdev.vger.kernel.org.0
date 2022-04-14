Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C253500CD7
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbiDNMPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiDNMPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:15:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE061F61E
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:12:42 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b15so6086717edn.4
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 05:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rhRwaWht/J6fvPbw/1zwrOPPkEZ7TQU79YfUwkCsdwM=;
        b=2qTh20UMAp/GP2n+qZcbQWlYkPs1azsU6UR5GYW6VdsAjSxmrQ75uUH7H2Lw9QbrN1
         Lwr3IvYBW7za1efKzTQvINSSddtVlY0r1GTFVpJdXVi+i5zZtiKyWFGxBn+/Qm2LR0P2
         AmTpDMMu5ivj6qpEgDmkjzqMklIIImpzeh6a3U5Mjg3gzAKR2rAE4tS8jdgXD91oLb41
         lF1RlUhUMqZ478oQ3/K/cdSUagRx2cFF0aftkGEYNYIJnqvxu8Djbrq7EUjnUDGN2pFw
         133rmeMs0dYFDqkJsZ5SAycFFwiJA8UouRP3M7IKCYufbJfdbCGFU5XgBA86HYk0vhXj
         S13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rhRwaWht/J6fvPbw/1zwrOPPkEZ7TQU79YfUwkCsdwM=;
        b=SxHqQwMrYrmbZki/EL7T6C28NKwtpCakU5tSO5hlX2Cy6wPyUHpK8Ohu2TuJe3G1dE
         WqUn4REGrfrA5ppysl1Iy/UW/8E/EAZ+WZS7IRJL7tLtdBiz6dInQcoHwfBgnJ4ENs8o
         FnG6DK9rpd/3JExsZkD1SJAYRdCUwnbHTsOmBa7W1P2Xenu1QZHRspfnl/NNDVXMofH3
         mF/2YLy6KWHp50MJyLwgEoyew0zb3ikB2RNsq37Q6097P58vYdM2DAvSwQaNQ1CJaOif
         081ot7H4kyGeq8z4kPTAUZAwWsO5NQpJBkgsXUnGztiDKTWO5NjPjJLUBsZZvsrLFm/S
         HIEA==
X-Gm-Message-State: AOAM531TC3KQmlUjAJ1FB+MsrG26SgK4DqS0DC2TRpPkWRUkucDXgDwA
        g8mD2RosSDLRYNam2FbquFxOQw==
X-Google-Smtp-Source: ABdhPJzF41g9n4BhcFyZM2BPEmqtGuuWJKd9rk9+VVAeWFIhL/Lm0cfv8vDLahOPrEt1FcCnaexnwQ==
X-Received: by 2002:a05:6402:1385:b0:413:2bc6:4400 with SMTP id b5-20020a056402138500b004132bc64400mr2694016edv.94.1649938361247;
        Thu, 14 Apr 2022 05:12:41 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id e26-20020a1709067e1a00b006e8cb5c173bsm585527ejr.13.2022.04.14.05.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 05:12:40 -0700 (PDT)
Message-ID: <2607574b-6726-6772-7921-84156393df95@blackwall.org>
Date:   Thu, 14 Apr 2022 15:12:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net 2/2] wireguard: selftests: add metadata_dst xmit
 selftest
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martynas Pumputis <m@lambda.lt>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220414104458.3097244-1-razor@blackwall.org>
 <20220414104458.3097244-3-razor@blackwall.org>
 <CAHmME9ouN0O-mfi4d_xVon_SxzE4hbzdD0Zm8hRLS4k5C3dPFw@mail.gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <CAHmME9ouN0O-mfi4d_xVon_SxzE4hbzdD0Zm8hRLS4k5C3dPFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2022 15:06, Jason A. Donenfeld wrote:
> Hi Nikolay,
> 
> These tests need to run in the minimal fast-to-compile test harness
> inside of tools/testing/selftests/wireguard/qemu, which you can try
> out with:
> 
> $ make -C tools/testing/selftests/wireguard/qemu -j$(nproc)
> 
> Currently iproute2 is built, but only ip(8) is used in the image, so
> you'll need to add tc(8) to there. Clang, however, seems a bit
> heavyweight. I suspect it'd make more sense to just base64 up that
> object file and include it as a string in the file? Or, alternatively,
> we could just not move ahead with this rather niche test, and revisit
> the issue if we wind up wanting to test for lots of bpf things.
> Thoughts on that?
> 
> Jason

Hi Jason,
My bad, I completely missed the qemu part. I'll look into including the
ready object file. If it works out, looks compact and well
I'll post v2.

Thanks,
 Nik
