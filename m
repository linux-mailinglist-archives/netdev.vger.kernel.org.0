Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A101D3D7826
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhG0OIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbhG0OHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:07:50 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CBBC0617BF;
        Tue, 27 Jul 2021 07:07:40 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id F3F9DC01F; Tue, 27 Jul 2021 16:07:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1627394858; bh=QI9NM+ntTRyETfWyMRmRllPOnsq2Qxq/y2QwpHonQpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OUeCMFppUuAhM4vHcwEr5QY6aCxKhRg6OQ9Ww+oT0eyH1lCSWCwbdahQH7JNps5Jk
         3B1e8XHBzLQLz5bj6WNwCZCrCS0nSEkWg+M2gSQ00hi2FQylEFD/hZxJQN2cVowH0I
         Wr2baxlbIQLo/lgZEoa2MXuckCZsAmEzQtlS8hRToiyel9DwWw6wEVboRPM+jMZDdC
         GxdwXPU6+DLfzciU3EaIxNN0wPuy4A4sqZCK5C7jHM9iXz5lUiPDfAinlpD7VIgG2z
         akXn1UVHVTeJJMkl7ml2UBKfXgejQdN8BtzKHvwByFvIEpmlcZEaPGpGnpUoxzcis0
         X84XWEhCV+6ZQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id EB9A7C009;
        Tue, 27 Jul 2021 16:07:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1627394856; bh=QI9NM+ntTRyETfWyMRmRllPOnsq2Qxq/y2QwpHonQpc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pn05Bq1fkIQ5dMWWMMhjFU61rkNfdRvNZ+9xveK8HyiHwQfk4ASNjfg27JEONO2QG
         TUXgeU7ZgPP8Vb4GCcyoXRrJlTcgdaykkuLMUwcbs+70Mk8Pk5lfqxb4ChNuw8i5GG
         ZTmWvOM3kZN5x0BdrIHc3Hu7obCOTOHtcAKrFK2Rw8Kyx2VqmBb8/ZkurUREZuNutl
         YV+RnVQLTtemm99ui7jjZLNu2fgmsEf3+wnACbaEL4ZyqHg3QPsO5MIcwLvlYUGV20
         RgXsVQiQrnZ2iAjrByQ9VFYGEeCFetSuMQA5S0rkNBWdoXCr7/4ihXjlwZXhg+FxLc
         Bf3Gq1KcBGtcg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f1d2c809;
        Tue, 27 Jul 2021 14:07:29 +0000 (UTC)
Date:   Tue, 27 Jul 2021 23:07:14 +0900
From:   asmadeus@codewreck.org
To:     Harshvardhan Jha <harshvardhan.jha@oracle.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p/xen: Fix end of loop tests for list_for_each_entry
Message-ID: <YQATEmmSsYABH/cu@codewreck.org>
References: <alpine.DEB.2.21.2107261654130.10122@sstabellini-ThinkPad-T480s>
 <20210727000709.225032-1-harshvardhan.jha@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210727000709.225032-1-harshvardhan.jha@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Harshvardhan Jha wrote on Tue, Jul 27, 2021 at 05:37:10AM +0530:
> This patch addresses the following problems:
>  - priv can never be NULL, so this part of the check is useless
>  - if the loop ran through the whole list, priv->client is invalid and
> it is more appropriate and sufficient to check for the end of
> list_for_each_entry loop condition.
> 
> Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>

Alright, taken and pushed to linux-next.
I'll send it to Linus next week-ish

FWIW, this isn't a merge so messing with the commit message is fine and
you didn't really need to resend (either is fine), but if you do for
next time please tag in the subject it's a v2 (e.g. [PATCH v2]),
optionally with a changelog below the three dashes that won't be
included in the final commit message (not really useful here as we discussed
the change just before, but for bigger subsystems it can help)

-- 
Dominique
