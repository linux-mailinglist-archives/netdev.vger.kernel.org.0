Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA80410DCC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 01:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhISX0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 19:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhISX0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 19:26:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15F7C061574;
        Sun, 19 Sep 2021 16:25:11 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j14so2716493plx.4;
        Sun, 19 Sep 2021 16:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yin/S3VnBhXJwbuiHwBbDtGIK384IhbkkFiimFmIrQg=;
        b=LgCfeCgJSH5k0Qd85yVE0x4aRWMMZyMLP6BSTNLpLJiPZQ/wbnH6b9B8SaOwW9LqSN
         39CXPvaimQKn2EBSKsBlJERtXFd/1HdproYFldojH+vuiiA/BeG6cPKboe66AXZKLLWH
         0OXemyQEXq47A10CSOG3imq/WAB7NJE4HKp0USSlb0KTWnMNRV/bD1GAwt3JxBRxNXVJ
         cvyCWdQVV6XEJ+DmUBIIB0D238/tvEHPGUcpHMQt6nxc1AzXBSY0yrSCg3ayHPADSPjo
         OcQsCvSvIglTBfJ+q0UeYqRNKoBuKweO6I7Wy/91LtQtrDlGs1gjF4tPnPOjzs2rZ0T5
         YpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yin/S3VnBhXJwbuiHwBbDtGIK384IhbkkFiimFmIrQg=;
        b=0dYC8ScghTay6D1cL6HmTfwtqW0m37LFQ9wRtAPUNrchcpGPxvkouc8rGVAv9hpTxA
         21BOHw5Bq9lS+rnK9zVOdCWY3ID+KFexOjdSi/54b/xYzgRo2/DDuSDTLlzgfSxXmg+7
         Gp5krkOw/ugdcVyKj1W66JPXB41yvQEhPrRTDqcdcHTSbapvaCeLAsF7rY5rnrEQ61JH
         9G5bAJAwd1Kt4SbTCRZV7BwXz6mIKv2UaowIldkpH+qWubpRnUruKAJpipqELhUdNQDo
         0H639PLD0x49XoCoriLHKJ5TYWiiKwhgVJxxRs8R6VBnCE+ziV1ON8G5pbCe15jGjD2w
         9Jug==
X-Gm-Message-State: AOAM533nboUI4FzHpyynCWRY2OEXd2blu6sXfwEyql5WDa46dU/a/3wA
        KiTfP+mKdfM1vls8e5qe25fw5S2bX/coOYvqi1o=
X-Google-Smtp-Source: ABdhPJw0Rc7Q899Vn7ztSMMZ6orHOKLDl2jdJCCIMUiLdUMO0kVfU7NAwb8l5ZImbM2bkv1iCGawKHnG5bg183XfXDs=
X-Received: by 2002:a17:902:e282:b0:13a:45b7:d2cd with SMTP id
 o2-20020a170902e28200b0013a45b7d2cdmr20167229plc.86.1632093911157; Sun, 19
 Sep 2021 16:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210918090410.29772-1-yajun.deng@linux.dev>
In-Reply-To: <20210918090410.29772-1-yajun.deng@linux.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 19 Sep 2021 16:25:00 -0700
Message-ID: <CAM_iQpW8hGBinQKTqKidYfn5sJjAYMUMHyr4U-=dn_CfWVLtMQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: net_namespace: Fix undefined member in key_remove_domain()
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 7:28 AM Yajun Deng <yajun.deng@linux.dev> wrote:
>
> The key_domain member in struct net only exists if we define CONFIG_KEYS.
> So we should add the define when we used key_domain.

But key_remove_domain() is just a nop if !CONFIG_KEYS:

#else /* CONFIG_KEYS */
...
#define key_remove_domain(d)            do { } while(0)

So what exactly are you fixing?

Thanks.
