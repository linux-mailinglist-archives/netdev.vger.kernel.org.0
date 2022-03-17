Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88004DC800
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbiCQN4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiCQN4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:56:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA091EEA62
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:54:47 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dr20so10642376ejc.6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 06:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Auj42wKcECcnklt6KoxYruKINeN/YRt0HTEgWQUvSbk=;
        b=trKaLQcY0Yt+MaFoeQX72QMgkuS5ppCOlNREaVS7jA73fXvLoyc7ULKKjY4nZXSvpb
         PAWHAjW2yBatHxPF21LM40sYwNnc0oT01X7OtZhPA65Blrr4xDZrt3YVuLS6rl3lkgGG
         qGdKrKHFuXoeQQ9/dhxBX4+2e5JzFER+NnKiU5FFpm/LZucICodXrX4AZJNcOwQFs4by
         1HZEjYX5Ev2wrsD8Z6/cy8LNMwZrr5UseaxFnzXb3tEajr3lPLnCMXJwpnSk3XJxpJto
         02FW+5u8/k7oc1hck+7sNYGTQV+G61KbOnMiUm6QlFH2vykPa7I8ht0+WeQS09VSChWa
         5omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Auj42wKcECcnklt6KoxYruKINeN/YRt0HTEgWQUvSbk=;
        b=XK7Lu0xIJ0bbgVk2d2Whs3fwLsllOWZoViLV0yp4TKjDn1KjLMdqcGNZgGQjnZlada
         6KK87s2Gna30jyZ30FMIH7uUmyK8h9wgdICc69AOOZf/B5PAnIFKC0HSR0a7bUme7cA9
         Q/ImtxHmhEnnEo/HnYcwXvLQ9uPnX/N2r7mHyqnY6R19rpxb+ixZ4L5P/+S2zaYxIyD8
         N5hpkCEARHr45+8cKmOq02LArNkBoGFqZrxzkyQ9OfeaOWMXZBQnhX+SEqk56p9bKylE
         ugDMw94S7QWIlT98XXU1/l3BsfHPu/2+2jaLnkKlE1Mxxp3Rd6Ty1uhpUNKwfuTKVuzU
         I4Lg==
X-Gm-Message-State: AOAM531+SPtt/GjIr9Nl0b5jTOC79QeH0r1n449M0+XSPI8/sEbbDQ62
        oq1ndfNgVNdFSov7vYaMcRNy1g==
X-Google-Smtp-Source: ABdhPJy3LJaMR48aHk4Bgx3rzdJbmiM4BhtwzVOo5DCk6QRrRA0jhiASRLbf5YA+rewzYYnz+t/WAQ==
X-Received: by 2002:a17:907:c05:b0:6db:f118:8834 with SMTP id ga5-20020a1709070c0500b006dbf1188834mr4594601ejc.536.1647525286282;
        Thu, 17 Mar 2022 06:54:46 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id t19-20020a1709060c5300b006d582121f99sm2376864ejf.36.2022.03.17.06.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 06:54:45 -0700 (PDT)
Message-ID: <24add056-e0d2-bf4b-9d56-04289bedbf15@blackwall.org>
Date:   Thu, 17 Mar 2022 15:54:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
 <YjM7Iwx4MDdGEHFA@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YjM7Iwx4MDdGEHFA@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 15:44, Ido Schimmel wrote:
> On Thu, Mar 17, 2022 at 10:38:59AM +0100, Hans Schultz wrote:
>> Add an intermediate state for clients behind a locked port to allow for
>> possible opening of the port for said clients. This feature corresponds
>> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
>> latter defined by Cisco.
>> Only the kernel can set this FDB entry flag, while userspace can read
>> the flag and remove it by deleting the FDB entry.
> 
> Can you explain where this flag is rejected by the kernel?
> 
> Nik, it seems the bridge ignores 'NDA_FLAGS_EXT', but I think that for
> new flags we should do a better job and reject unsupported
> configurations. WDYT?
> 

Definitely, I agree.

> The neighbour code will correctly reject the new flag due to
> 'NTF_EXT_MASK'.


