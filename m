Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE6556A1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfFYSCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:02:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37786 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfFYSCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:02:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so9875798pfa.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0zWzsB9zWBO/0T+5Mjtm94xzsXQ8yDzdQ/Xnq994hZ4=;
        b=D+lld1sYDB02k/yRtyQZXTsvxaaQmGdsOA8LGjxDLTwWNH89o4Rs7a9PVdAWBiq2ld
         XlphJwD9WJ1iMpHIbfpAfk3ql3aV4qMHxhrefUPYpXPd7Ou/G2na6p0pVgj7pipBI98B
         49XQzdg4csBrAADcUQNmHFZYv/49lCtm2hAk4ayWhuDHRX1GgPSP2IkSrM5ETrGYtwlQ
         +S4qb0O6h4DnvzqSS1IzcaUQ7HnewC3tT6j8DnsSCS8bWGP1HP1maAgASZId/f1akWFJ
         AItFy0cWZ6i3UmHZ2ANDyQjNsybUZPsMGWFKIiI7v/MwCp75Q+dQu7SivHVJabO2xKR1
         1YFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0zWzsB9zWBO/0T+5Mjtm94xzsXQ8yDzdQ/Xnq994hZ4=;
        b=V8VgjjyrNkzX2sFqlFeDtC7tfygaRbcVL27RyRbYweYqcJRA4CGfecNy6HqGRBN2rD
         Yt9K1+CDSWlosqKnqFWOb9HY5/zjhxDNz9ea/rvpJmKw/Kdpo349sUMstMcvxMWg+kk/
         GfP/55M3EZVWDLOrc5aXZDv+Oqaqzg9lwkWZGPFiY+KYmffH/9nyb9wxXdKBfsVZ4HNr
         UBaOcl7HUgov0DFLwxMeW685U30P77J9P3PhLF9jLoHR+6FrQXx4oSonrkYJbXzjVaC1
         iu8+6yHfnos/dcRRyFGjx9gczfYWbnkuAPz0m5NtWqzP4DRCV3E700GI5q1n25q3D0R4
         YZKg==
X-Gm-Message-State: APjAAAXMsKMD1SKljg2iqB7F1mj4gCEYVeEwEiJwGqCHpVINhL1m80PO
        ynlGpzXOkKGnbf5FG8/Ex1BAiJA7ZZ0=
X-Google-Smtp-Source: APXvYqztLpO9dUAOYuF+kEekJyHJSyw+qgyrSC34iyIzdJNce+pdk3T6Q7YGDeZqv+8QmQqJ3r4wNw==
X-Received: by 2002:a17:90a:9f0b:: with SMTP id n11mr107356pjp.98.1561485719391;
        Tue, 25 Jun 2019 11:01:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a3:10e0::2ed7? ([2620:10d:c091:500::2:c089])
        by smtp.gmail.com with ESMTPSA id a64sm13592819pgc.53.2019.06.25.11.01.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 11:01:58 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 0/1] Fix broken build of mlx5
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "jsorensen@fb.com" <jsorensen@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190625152708.23729-1-Jes.Sorensen@gmail.com>
 <134e3a684c27fddeeeac111e5b4fac4093473731.camel@mellanox.com>
Message-ID: <74cb713f-ad8c-7f86-c611-9dd4265f1c9b@gmail.com>
Date:   Tue, 25 Jun 2019 14:01:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <134e3a684c27fddeeeac111e5b4fac4093473731.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 1:54 PM, Saeed Mahameed wrote:
> On Tue, 2019-06-25 at 11:27 -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> This fixes an obvious build error that could have been caught by
>> simply building the code before pushing out the patch.
>>
> 
> Hi Jes,
> 
> Just tested again, as I have tested before submitting the blamed patch,
> and as we test on every single new patch in our build automation.
> 
> both combinations CONFIG_MLX5_EN_RXNFC=y/n work on latest net-next,
> what am i missing ?

Linus' tree:

[jes@xpeas linux.git]$ grep mlx5e_get_rxnfc
drivers/net/ethernet/mellanox/mlx5/core/*.c
drivers/net/ethernet/mellanox/mlx5/core/en/*.h
drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:static int
mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32
*rule_locs)
drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:	.get_rxnfc
= mlx5e_get_rxnfc,
drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c:int
mlx5e_get_rxnfc(struct net_device *dev,
drivers/net/ethernet/mellanox/mlx5/core/en/fs.h:int
mlx5e_get_rxnfc(struct net_device *dev,

static vs non static functions, with a prototype that is non static.

Jes
