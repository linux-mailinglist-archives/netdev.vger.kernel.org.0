Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D702521F77E
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgGNQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgGNQkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 12:40:15 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62680C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 09:40:14 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so6051928pls.5
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 09:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xcBF3TZiTELqAntxQXk8vGwemZhZ/3OxCckkhVW5VVA=;
        b=hitfTZBByu+7nit/ZTxMYMSzlIPDww596xI7A3fAjDwlVnTlobBgIMtb+o0myBKFTG
         j0Cwg/JzOgH+9dvFf68RA2kAbuiaxdwRqH3AXfjFZvuJ2wlNX+9TFKoi75q1mHDs2N4h
         Ldc12VkclDRtMCzxeWZEWWiwJBQfuBavgTdLxv+SfPVEuvv7uSVnTohKSv+g3OUc5q0x
         WDmePToBSbSXjCi2ql3T1ntoVWe7KC8jtuVqchUI9PZSaXO+15LkyCSvgjNIDJvEsYr6
         85H+pmo1Ce3LpvDTi/cvec4jOp7TySmU+fyYwR77lbPywlm9b+ggVNa1FDqPhdJpbJJN
         hpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xcBF3TZiTELqAntxQXk8vGwemZhZ/3OxCckkhVW5VVA=;
        b=hSPNVAkAiPa21DzdpG2lb5rSWaxsgdC5eXDEGZCOBuWtl9EzkVZEYiTNK9usXIBjGi
         zHmutG3rmEJxuTxWvGOjuQGKeP7XC1VotbQWnRg8PMqRmoZZGF1dL5IAo+knhBN/9uPq
         CSPEn0PV0ewVXmRTs3gAeckbDAgNHtEpvOwr9DtTp241/YHZ8NkOlVi/U3ea9/wunNZd
         qC9KrgVwdLWV7oPdjmZ5Z+2E7xi0ALIXGiQcwKK/KGW81lVhBWGEVCNHn/UdgV7h+vc6
         uRqY2EDNlAGp0fRlR1OwyijsojMyw3N2KL1NTrZPzFJp+CQze+fNmB0khsgeCCaU22yA
         rUng==
X-Gm-Message-State: AOAM531X6iojiDjPfULsKoAEAXNSGhxHEVhAQKD6epjXct2/ibtwkegV
        PmLQUQdb/umGAZcbhtZoE4E=
X-Google-Smtp-Source: ABdhPJy18MYgw1uGavhVi9NOL2GaSVqsXiHpBZfvpIDHJBabJ3DxLMYn1PECZz17fDfo80kzamch9g==
X-Received: by 2002:a17:90a:ba92:: with SMTP id t18mr5558218pjr.121.1594744814015;
        Tue, 14 Jul 2020 09:40:14 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n9sm3014125pjo.53.2020.07.14.09.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 09:40:13 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] Revert "net: sched: Pass root lock to
 Qdisc_ops.enqueue"
To:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
References: <cover.1594743981.git.petrm@mellanox.com>
 <32c55df4e3926b646ae2e818ed741b1b130d3b43.1594743981.git.petrm@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <caadc097-5ca0-00db-da7b-0a653fdeaab0@gmail.com>
Date:   Tue, 14 Jul 2020 09:40:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <32c55df4e3926b646ae2e818ed741b1b130d3b43.1594743981.git.petrm@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/20 9:34 AM, Petr Machata wrote:
> This reverts commit aebe4426ccaa4838f36ea805cdf7d76503e65117.
> ---
>

Ah, you still need to amend the patch, to add a Signed-off-by: 




