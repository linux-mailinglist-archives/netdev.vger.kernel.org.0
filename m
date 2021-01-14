Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887DF2F5609
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbhANBaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:30:12 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51587 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbhANB2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 20:28:06 -0500
Received: by mail-wm1-f53.google.com with SMTP id h17so2991912wmq.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 17:27:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V4wqRrQDMqpx+zERSu2u4Ej1vEpfmwbS23jyI8NIX9c=;
        b=Hs/GdzEe2jCoEr6PWXxqfG4VaCnW9fm/xU168qU9wqWsOWPMxSUEc87EvbhSO8CMFP
         Rm4WwmNJVd762aM+1bSqXM6c6ONm8EVZ5wa5YiKc8WqzbJ++A7l24zVVGtuYk8YXML4M
         SxyW7FSv4rqVOoGFb5bDyonIS3Q7krn5mVaudfOVJf5bOuNaUsWD/jR84Ue/ktJn+wsE
         uYnd+2n61G219NQDWgTdL+S7KpkIsLGyzFzPT1z8GC7n48HgPD8/OniTbIYCyAhWwzE5
         ZXMw6X4QEDz6zivPQvRSb7Nsxz8YNxGc8ChEixS+J4ZWwZcG0slASihtbOOVsvZrCSug
         Ku7w==
X-Gm-Message-State: AOAM533EjdEcPp+hIsjcPTPG3oI/eSA0v2aIooPxFQ64GQwAD2in57g+
        +gxlR5t7D8vOfTpNBU0pAto=
X-Google-Smtp-Source: ABdhPJw5XViKYvOG6U3VmMSM7YrcwXpi9bp2OpEwMO4JjmkNSGC4jiz0FLlH1sDZ+4ZUvAc16lUc3g==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr1530111wmb.43.1610587643046;
        Wed, 13 Jan 2021 17:27:23 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:e70c:620a:4d8a:b988? ([2601:647:4802:9070:e70c:620a:4d8a:b988])
        by smtp.gmail.com with ESMTPSA id u3sm7664075wre.54.2021.01.13.17.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 17:27:22 -0800 (PST)
Subject: Re: [PATCH v1 net-next 00/15] nvme-tcp receive offloads
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     yorayz@nvidia.com, boris.pismenny@gmail.com, benishay@nvidia.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        ogerlitz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <69f9a7c3-e2ab-454a-2713-2e9c9dea4e47@grimberg.me>
Date:   Wed, 13 Jan 2021 17:27:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207210649.19194-1-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Boris, sorry for some delays on my end...

I saw some long discussions on this set with David, what is
the status here?

I'll take some more look into the patches, but if you
addressed the feedback from the last iteration I don't
expect major issues with this patch set (at least from
nvme-tcp side).

> Changes since RFC v1:
> =========================================
> * Split mlx5 driver patches to several commits
> * Fix nvme-tcp handling of recovery flows. In particular, move queue offlaod
>    init/teardown to the start/stop functions.

I'm assuming that you tested controller resets and network hiccups
during traffic right?
