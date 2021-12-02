Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A8C4662BE
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 12:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357444AbhLBLx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 06:53:29 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:47320 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346623AbhLBLxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 06:53:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UzAd3ah_1638445791;
Received: from 30.43.84.45(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0UzAd3ah_1638445791)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Dec 2021 19:49:53 +0800
Message-ID: <7ef20c24-efcc-2103-0727-3933b0f9b3a3@linux.alibaba.com>
Date:   Thu, 2 Dec 2021 19:49:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.1
Subject: Re: [PATCH -next] mm: delete oversized WARN_ON() in kvmalloc() calls
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, leon@kernel.org, w@1wt.eu,
        keescook@chromium.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <1638410784-48646-1-git-send-email-cuibixuan@linux.alibaba.com>
 <20211201192643.ecb0586e0d53bf8454c93669@linux-foundation.org>
 <10cb0382-012b-5012-b664-c29461ce4de8@linux.alibaba.com>
 <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
In-Reply-To: <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/2 下午12:29, Andrew Morton 写道:
> Thanks, that's helpful.
>
> Let's bring all these to the attention of the relevant developers.
>
> If the consensus is "the code's fine, the warning is bogus" then let's
> consider retiring the warning.
>
> If the consensus is otherwise then hopefully they will fix their stuff!

Ok,thanks for your advice :-)


Thanks,

Bixuan Cui

