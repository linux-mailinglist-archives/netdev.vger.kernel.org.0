Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816173EA5BA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 15:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbhHLNcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 09:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234975AbhHLNco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 09:32:44 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BC7C0613D9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 06:32:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nt11so9581398pjb.2
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 06:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=pN8gn6XDJx8X4O5FCMjgKbbXidE6R/vdaeWWGFTiI50=;
        b=W8YI8H/hnSbUW8vndQz73VUJvpgzszAc7mMX59M0eDUBjXJsQAeT/cIpJ3nJxn/Hsb
         QEGacGy3Z0qUIn/tdG8zmV847TXoBhK8VjH9xhUk8OEqcAvoQw2HwQeVKf0rk3O9EJ4O
         edW4zXX3oAgqRRraXbpWn1x3A6QTqIsWUxCwXNpyPbuiY8R3hSWe3YzDnBTDpoTKDjHy
         iFvVAYFk3kDynXbIjBhIY7qapDVc8f5oLfn5Nnz9q5TyesEiGL220EeS31RaqtqlmbHC
         SS/Os6bJCZDd53Jxsmx6Nr/AQhxqEToW6DFPjkkqEHD+hdAYeOs385Iu4wv9UCzT43V9
         phrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=pN8gn6XDJx8X4O5FCMjgKbbXidE6R/vdaeWWGFTiI50=;
        b=kv0bv+qfCJ/MWyHDEIM58+jx6jJEyKorcvLJT2OQOi8HbCxLUAfBaoxHA/LWSVD1kp
         wN1od/cv6bG536NaXalp+PN8TzMwcpHJxE6u0yKhkMawwoX+c9BiDxf70WvvFcFYmh/j
         /zPzLDvLYGM+uSVfh+BHfQvZsojxHo/lLl3u2zXJQner0wR+W6LD84Sz2I/3t2R0bGjH
         8fyvMEC5U8FSKyzdmyBiQLUlzImHn0anZyggeyl668YIGGwV7UN08wZu7/EY8Z2hN+V7
         xl3zgZQNQifHtAvjChmy4yKN/Pb86lnQ+WCiwLNvGxl1JIlMEIjIiII6DBRiP+y6jvs0
         utKg==
X-Gm-Message-State: AOAM5329q5mRUc2Bq3FPlTGgrRjtp5BjES0ecld9ByfZtfVALh0uqVXM
        RifhemMbl6qaPjJGSbfcSaEN
X-Google-Smtp-Source: ABdhPJwLPHcmKKCvzEOp8J0CQ2RxkJ31f47XgenwLO2Jq4zYxBMA8pGHIGfgky6xC9N/7X6hkeJ4FA==
X-Received: by 2002:a17:90a:3fcc:: with SMTP id u12mr15580048pjm.5.1628775139259;
        Thu, 12 Aug 2021 06:32:19 -0700 (PDT)
Received: from workstation ([120.138.12.52])
        by smtp.gmail.com with ESMTPSA id j19sm3468141pfr.82.2021.08.12.06.32.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Aug 2021 06:32:18 -0700 (PDT)
Date:   Thu, 12 Aug 2021 19:02:15 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, richard.laing@alliedtelesis.co.nz,
        linux-arm-msm@vger.kernel.org
Subject: [RESEND] Conflict between char-misc and netdev
Message-ID: <20210812133215.GB7897@workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

Due to the below commit in netdev there is a conflict between char-misc
and netdev trees:

5c2c85315948 ("bus: mhi: pci-generic: configurable network interface MRU")

Jakub, I noticed that you fixed the conflict locally in netdev:

d2e11fd2b7fc ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")

But the commit touches the MHI bus and it should've been merged into mhi
tree then it goes via char-misc. It was unfortunate that neither
linux-arm-msm nor me were CCed to the patch :/

Could you please revert the commit?

Thanks,
Mani
