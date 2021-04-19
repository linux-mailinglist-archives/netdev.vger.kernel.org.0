Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A54363F38
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhDSJzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhDSJzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:55:10 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1F4C06174A;
        Mon, 19 Apr 2021 02:54:39 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id u20so38590060lja.13;
        Mon, 19 Apr 2021 02:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSlXDJl/uFE9GGsWvDZ6f7hycw1cx6e2NNtbcpc1FAw=;
        b=SNIPOyx5VPBKa6HME69dVlvKxHs134C1Tv/LPj+zrr8ueHCt6zp1ViGgvmPX4BMfcU
         7P9awRRnwkto65fDpPlbI6TCcx/88VkSOCwCeDkI87jaK7toRXoSH/Sh/wEhFe+LVciI
         7rSetlBeJzWAay8WzatKuqvrpWP489VFEFeP2KcKZlL//PzC/uDgxiIiXod/GHmliAnb
         diF0Aiwk0jKoXAKmRgbnrHwPJ4SlmDRqV6a9PCREWdlUpzIWH/5lB1mbEx5LnOs1jDEz
         02mHA07hSn1H05OdGQAIHVLHKwj7uoUIIIguyG3YS4EG8fka4h4qXaLWktd6zhrw2l3V
         aKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSlXDJl/uFE9GGsWvDZ6f7hycw1cx6e2NNtbcpc1FAw=;
        b=kToxDSuRN9G7OUHedGGRygq0aauyptxAjvpNFHNQ1IHESWg7IA/hX8Q69lb6GOBok8
         yHKkEA6n7hMUt+WlL9sh+n2paaEAEXrB3cmjlzg51G8n8LHyMFRgUk0qhoxamM2cV/WD
         Oq+Z99RU8pXSgR/uPtuuXSknpayViIqb5V0la/63koUd7BvjG+Q02lsBP6Gao7WXQ1sr
         7qyR1gnnD1M6Ic/hbu2tUZjiinjDFn0dk9AWqXcD0VSuR3RelBleJPS00ENcVxNCyKVw
         +F8QumnctUGHATtCNcqxuRov8IFphCEpYAXMM6p2D8nqVwxaOJgjFW3B3Bj0nkb5l0Y2
         da5A==
X-Gm-Message-State: AOAM531rvuDwwUQqTtEtbVinceFErWjyhwN+0kkjLIDjwQcbCu6J2uzM
        ywUSmIe7UEcdt9wTy/mD31z7ukY3pCER2kQ7367rPGr2Eg0=
X-Google-Smtp-Source: ABdhPJydUVVNiEfXN1M2hrXYbDIqXYVUtCiMvSydUrz+5nOKO5Ulc3VVljLLRGBVG/+9hsNDgOtSRp+47FQs9ImZ/d4=
X-Received: by 2002:a2e:8346:: with SMTP id l6mr1411074ljh.418.1618826077385;
 Mon, 19 Apr 2021 02:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210419090800.GA52493@limone.gonsolo.de> <12e0173e43391fa70b9c199c31522b44a42ca03a.camel@sipsolutions.net>
In-Reply-To: <12e0173e43391fa70b9c199c31522b44a42ca03a.camel@sipsolutions.net>
From:   Gonsolo <gonsolo@gmail.com>
Date:   Mon, 19 Apr 2021 11:54:26 +0200
Message-ID: <CANL0fFTree1UQugYMHtO3S9ktPCP85J_wm-hMqwT3MQBZ-yHKg@mail.gmail.com>
Subject: Re: iwlwifi: Microcode SW error
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you use MFP?

I don't think so. I'm running unmodified kernels from Ubuntu PPA and
don't meddle with WIFI configs.
How can I find out?

> Could be related to
> https://patchwork.kernel.org/project/linux-wireless/patch/20210416134702.ef8486a64293.If0a9025b39c71bb91b11dd6ac45547aba682df34@changeid/
> I saw similar issues internally without that fix.

A quick "git grep" didn't show any of these two patches in the 5.12-rc7 kernel.

-- 
g
