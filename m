Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D41AFC44
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgDSQ7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725932AbgDSQ7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:59:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC7C061A0C;
        Sun, 19 Apr 2020 09:59:04 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id x1so5888880ejd.8;
        Sun, 19 Apr 2020 09:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yaz56HMp/S89gaKfJpEhbFFnazFPo/RmIrwLmVduCoI=;
        b=GSVsDoWNqHMk1a/muWiXRDv5VANp+vqo4c08fPkDbG9pNXGJRYCfhBZv19nTVghEV/
         rR1emnmvALzm3mBWNYCb0tCXhj/GfMY3BYzeoBauJhrrRlhcvWODFDzalNcgQiZnlPhB
         ZDPKvd6TuNENzsUlt/+aJ2D4KeYw7DbL1Xu9ryn67NfucngIFG5j7z0q7ocNEJzbJmUx
         SRU25/mNFOHWOVjhmQajYOOgAngNAQCBuYtLc56flZ0Z6Bgu4BqB/z/zgXf0Kl/Ks4k6
         ymF3jNCnP0eu5hL1crG77BCfqeE3R/o0nZR2x4u83cHj1p0GHFmOpVOfyN+/sztPbXWj
         vM/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yaz56HMp/S89gaKfJpEhbFFnazFPo/RmIrwLmVduCoI=;
        b=jX7BFkqFG6HCm/0BEAdHy9BHUx1xpD76V5CBDyFW7kjg8pDLEWYtBdwFGhTivQEKpY
         8M0+r2qBp9Xu1+Fw7aYybZLy1Ze+vMMlaEegnOAyD7wrZjFtZkrpTNugjLBJJ8LWJtDC
         NdROxFBsiMoRcYF6B6GxXgbXIKRjddWAV1pr5mifampVr4FTqLVUKiZE+kE0u8HJbBtO
         QYOBbl3YT7ltLttrKH7INlPfHvuAl+0RUJqfoNNEFiF45o8FqCj5ScvVWoamVesuUTcb
         b9SOxByxA1ZLs2KB26jqQ9Hm7fVY7/KnIWA8yOW1i5szFvGaimF4HbBnelhttZXyU+is
         nxKg==
X-Gm-Message-State: AGi0PuYFgCbyLmqwFFzqTK3xiFoT+t9FbaWWGNqW1Ww0NwJtz7AVscvC
        549zmcQz8ekGep7ZhPiAVrVo3hV31pH2KzyT/PE=
X-Google-Smtp-Source: APiQypInUWs4bxD4QvtZtJ/yVZmP+/efzMlqnIUknrqdkFj4i6HrJej16oCfUeGD8zDR58ToIyQMVGpbDdwIYRbGjLs=
X-Received: by 2002:a17:906:4048:: with SMTP id y8mr12436425ejj.258.1587315543506;
 Sun, 19 Apr 2020 09:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200418181457.3193175-1-maz@kernel.org>
In-Reply-To: <20200418181457.3193175-1-maz@kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 19 Apr 2020 18:58:52 +0200
Message-ID: <CAFBinCDOw07_MHa=EBiLZsw24z3x5ngcW8_xmN6fJ8SqPmyyqg@mail.gmail.com>
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: Add missing boundary to RGMII
 TX clock array
To:     Marc Zyngier <maz@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Sat, Apr 18, 2020 at 8:15 PM Marc Zyngier <maz@kernel.org> wrote:
[...]
> Digging into this indeed shows that the clock divider array is
> lacking a final fence, and that the clock subsystems goes in the
> weeds. Oh well.
>
> Let's add the empty structure that indicates the end of the array.
oh. Thank you for fixing this!

> Fixes: bd6f48546b9c ("net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
