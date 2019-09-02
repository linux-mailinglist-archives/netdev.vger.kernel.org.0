Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BE1A5BF7
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 19:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfIBRyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 13:54:07 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:44423 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfIBRyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 13:54:07 -0400
Received: by mail-lj1-f172.google.com with SMTP id u14so7007618ljj.11
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 10:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vx4HaqK6AE1z6LgryEVwhVJxZoS5P56Z5PixfIIvqCU=;
        b=aGvSePxHgUIq4RRBmtGloVUytzJDaUApsvvS8wzuNLHp1FutXRz9a8s/vxDbcHLQfI
         duRlSpjdFux4HkIPS5LlMxLMfv+oyr7OJczjBRNTIzoHsyz9RNxWlcnchV2La05Jg3XO
         g0YLv1hHNXX1ZDJr0K27w0VNJ5cL2t6TpgXN7AQC5gm7pyJnw+vVcd/Ae4r1I6lfms/w
         0NFL01ppc0ORKkNytFjPkf32MO9tvuLOEyjHuz7Sfp9X4BjMPLjSOIT/a9gL5NceAOuC
         XgqeVI2tupMoBffNsMx7par+iuk++ZymHk5bsmNeNPuJfdkUrLA9pVVoLOn4wCeItoJ2
         FNWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vx4HaqK6AE1z6LgryEVwhVJxZoS5P56Z5PixfIIvqCU=;
        b=rQSqO2MA2P8vPz0tmMGXE2ErtmGoe16W1kObsDejZ8GZBpin9zpgt5qXQXRNCWrVJA
         XmGPbLf9qKY0fBvEIt/gAWKYrUeaas7/GVwkRDyFe8x+b5EDydAWBsxtzTlp8vyeR3OO
         j/bj7C1PRXbI/ITJYtMRUZVVyLC2en+EZv2fpHgvLbCcU17mIHH6KVNnfs6b6YZWAmr+
         RYxtauMC8qhm2IpEGKUsLrwxUJfJ9qAgQofFygcUHwFSv0YowRX1ZT9VGc9w8i5VtSp2
         YjJJEdM8UWTHorlNzZCjDhlWei0OyaKt+OocGA4rCNnaAjes6cWgtNENvtkHfbOwjp9h
         Bpag==
X-Gm-Message-State: APjAAAVkuOkggr6n/g1ob1aDHeXtHcGEbpJdm46i4+aFlOtEyHPc4be5
        X2z5uRkWgNn/jLgFhl0KCy9lk/fHNRk=
X-Google-Smtp-Source: APXvYqzC7ogYgiubFvtvgCNUw75+FdS8toV/0HR5eOMyyv0G/FyTSo1BOJj9Sufy62Bebq89rccAvw==
X-Received: by 2002:a2e:7613:: with SMTP id r19mr5108148ljc.216.1567446845504;
        Mon, 02 Sep 2019 10:54:05 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:272:5afe:be7d:d15f:cff2:c9cf])
        by smtp.gmail.com with ESMTPSA id v7sm32528lfd.55.2019.09.02.10.54.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 10:54:04 -0700 (PDT)
Subject: Re: [net-next 3/3] ravb: TROCR register is only present on R-Car Gen3
To:     Simon Horman <horms+renesas@verge.net.au>,
        David Miller <davem@davemloft.net>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-4-horms+renesas@verge.net.au>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <92f5fa81-39c9-4d98-539b-bb6ea7374472@cogentembedded.com>
Date:   Mon, 2 Sep 2019 20:54:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190902080603.5636-4-horms+renesas@verge.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2019 11:06 AM, Simon Horman wrote:

> Only use the TROCR register on R-Car Gen3.
> It is not present on other SoCs.
> 
> Offsets used for the undocumented registers are also considered reserved
> and should not be written to.
> 
> After some internal investigation with Renesas it remains unclear why this
> driver accesses these fields on R-Car Gen2 but regardless of what the
> historical reasons are the current code is considered incorrect.

  Most probably copy&paste from sh_eth.c...

> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
[...]

Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

MBR, Sergei
