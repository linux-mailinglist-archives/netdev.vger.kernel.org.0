Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E438D1B0
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhEUWxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:53:22 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43804 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEUWxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:53:20 -0400
Received: by mail-wr1-f51.google.com with SMTP id p7so18726433wru.10
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 15:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yvj3eMK+q0AK283Z+clTzeemzC/RTeZ4w+42UHNs4CI=;
        b=oFwsNUmexOM1jwi1HLk9Yf0KQjJtoDwltIv+2ecMyC8BoeIk0RpfVa2fO8UhhidkoW
         ZcVw83x6AosMdmLqK5KzFXU1njZq8iY27xX+EfAK8rIQ+6gXU7V+ctm1KD563wAcjVNx
         65XAxjv3mwZOeP3KlHN9Xk+PWxn8m2Vdbpol63Ll10C1+rmqiZOLrMq+WsCwCz/HqeCt
         eEN5icjPrgREpZARlwES1Un/v/ZABJEZWUi/a5Wmy6XrggJWWh3ZtWfbsyt2NPeYJ+S8
         GxK8aAWB2H/CalQcOrXUkGyw/Bt8htZ644jMcSsZXLRdsBSXYgmxDVmxdNq4QttG7AvN
         s8sA==
X-Gm-Message-State: AOAM530HoPZdYqTTQuL2GYVIYOYUB8Wka+JcDpAX0NVCW1v2BMdKl7Yz
        nyQVSUsyIWF5Mq00OK8fDxs=
X-Google-Smtp-Source: ABdhPJwEbixDJMryHTATmZwjWT5nmeb64WIwTHo06Y4gf4GxbExH2TJom8qu3+3bdWibwW1S6CKCsg==
X-Received: by 2002:adf:b31e:: with SMTP id j30mr11719070wrd.74.1621637514577;
        Fri, 21 May 2021 15:51:54 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:66b2:1988:438b:4253? ([2601:647:4802:9070:66b2:1988:438b:4253])
        by smtp.gmail.com with ESMTPSA id g11sm3461416wri.59.2021.05.21.15.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 15:51:54 -0700 (PDT)
Subject: Re: [RFC PATCH v5 08/27] nvme-tcp-offload: Add Timeout and ASYNC
 Support
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-9-smalin@marvell.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <34e4a50b-4075-2364-d654-4039564f43ff@grimberg.me>
Date:   Fri, 21 May 2021 15:51:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519111340.20613-9-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should be squashed in the I/O patch
