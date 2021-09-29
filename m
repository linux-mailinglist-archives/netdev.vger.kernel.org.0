Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E4841C233
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245265AbhI2KFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243962AbhI2KFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 06:05:08 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5F7C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 03:03:27 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c73-20020a1c9a4c000000b0030d040bb895so1305111wme.2
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 03:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zRRZyq+Isj97NaLUmilazNyX72THo/jLK0dOBO7bemA=;
        b=BoE4FG3UrOye+158kkGi/BYp+VzyYVuu5a3ZEuAhaPL8I3dvs7aBCmt24Mj4wy8E6W
         ynQqklwru6Yvo96nt3vhhwwNoXUgNsuroSOWqFKwepxegzJouPFFKH/lzLRZuGu5nbGS
         zCHeoMfAYAxHXg6TZG67x4ZmsWceQDKR2nEQlk9qvCVbfLeUgmp9An86X4n3w0/GPoF7
         5jZUc3R5nVmL2HAfH1DVnDsmLs1mkm6ABV/kageImXLET//OAz3a+5HjRYokkiNstvO3
         kDvKT/zW1YBR+0Fj4dawXA17VIODWgCSnjH4I4G5cRO7/klgdCOrZct4CjDE3cwdYUX3
         e/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRRZyq+Isj97NaLUmilazNyX72THo/jLK0dOBO7bemA=;
        b=fnghaxWtfGZggo1cgJEOe25Y5MYdHBV5ST1rsMrLzPqVSZnuO0kprCFV65QNZjB8GN
         2QdoRfyf303Z+rw+1bM1G2WtydymNxRQ0wCzD6xSWSR21qAH1C+00LOZOF2rA2MEKfgd
         ZLVLlguwdn1o8qAIBWXpFdoctUU4sq3tiW7bFdhk841wUga+2qd0FRdsqGJWgl0Pb/ca
         6SNl/tgLizFjIsuDtj/KBXR8cVWZq9edC9gh2uK2SUvp12Fn9bYZs6S3ybm9xS7t05xV
         YT5LRze32RnrNOMEHqODA3PqqQI3nsuu7WSXvmcF2RnscEqrXFgBuUY2nSGpNQSDofuc
         DrYg==
X-Gm-Message-State: AOAM531k3h0rhHb93uUWdGPLNsXR5F7nr/gKVpCTaRPYedGWp63q7iTR
        nULXQ31EnS7lu8uEJgnWf57m9czsUps=
X-Google-Smtp-Source: ABdhPJxrFjXE8Q0oyxPybBq1p/17M/2m19pahqPv0OvbAh7D0yIzob53Zok0w4oXgpoiT/rVqCyiVQ==
X-Received: by 2002:a05:600c:1d16:: with SMTP id l22mr9385529wms.44.1632909805963;
        Wed, 29 Sep 2021 03:03:25 -0700 (PDT)
Received: from [192.168.1.24] ([213.57.138.125])
        by smtp.gmail.com with ESMTPSA id d16sm1088720wmb.2.2021.09.29.03.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 03:03:25 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/3] support "flow-based" datapath in l2tp
To:     Tom Parkin <tparkin@katalix.com>
Cc:     jchapman@katalix.com, netdev@vger.kernel.org
References: <20210929094514.15048-1-tparkin@katalix.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Message-ID: <1fe9bf2a-0650-a9ee-b91d-febcf3d22612@gmail.com>
Date:   Wed, 29 Sep 2021 13:03:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210929094514.15048-1-tparkin@katalix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom,

On 29/09/2021 12:45, Tom Parkin wrote:
...
>        The skb is then redirected to the tunnel virtual netdev: tc rules
>        can then be added to match traffic based on the session ID and
>        redirect it to the correct interface:
> 
>              tc qdisc add dev l2tpt1 handle ffff: ingress
>              tc filter add dev l2tpt1 \
>                      parent ffff: \
>                      flower enc_key_id 1 \
>                      action mirred egress redirect dev eth0
> 
>        In the case that no tc rule matches an incoming packet, the tunnel
>        virtual device implements an rx handler which swallows the packet
>        in order to prevent it continuing through the network stack.

There are other ways to utilize the tunnel key on rx, e.g. in ip rules.

IMHO it'd be nicer if the decision to drop would be an administrator 
decision which they can implement using a designated tc drop rule.

Eyal.
