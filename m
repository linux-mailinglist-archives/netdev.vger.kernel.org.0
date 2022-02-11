Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A994B1B2C
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343913AbiBKBYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:24:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbiBKBYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:24:31 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFBE1120
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:24:31 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id m185so9641805iof.10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3/vP8H6zpQ6L96zf+xvIhHoT5mY8Lm2AN+u5z4k1QLM=;
        b=cnaS2dkL2QubxiW3uGPDOnHb5Vyk49nyhYtZJU2MXg43vS33pCsAi8E/n6/s7Kby/8
         r067eCxJJRfmyETFF7/Y30zBkn7+6whyqVB9qGUUyhSPP8zggpAt9Rcsu7SRqjCcpcjC
         m2fkmawLqi5MBYXuK2p8VdH8epx//hErZkHcQ3oBhg3Vehkj5A3RoqgQBbpV79PgLFys
         WjIRof/9o/YSAckIZX9YrSSxEh/Zql0kkyKbiRG3gziu8frCB+inxK0Z15od/7PI3ghT
         Mqt9/cEKCZ69M58TN+7K2PVDksEP2jUHOBBphMDqa8H6r9b0yYADLkNWLbQk/ji4yx09
         USMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3/vP8H6zpQ6L96zf+xvIhHoT5mY8Lm2AN+u5z4k1QLM=;
        b=gWmPPHWa/gIga68RZh5z2EeoIGXq6wRpeVBov1lhN76vlZ26pdSmM2feWDFzyMQw2o
         VRpwuOdccrXd7YKOeBcvsGjqkfhkelr4KEaU0+hPMdD4wN5gitwiKAIcNd8w2B2p1CTu
         DBl6zT2wfCG/+TxwRf0sOq8IEX4MGrsVW7qA5eEU74Oa3rtyhvZsnXyeW5NX5wc9Wa9h
         jjdkAxyK7EKjyDAtWLeoOoQ6q9Vwk+Ou8oNq4uA6/HjKnfowmh56kLqUec4wOw8k3VQv
         o9BMcEX4+mNGABOXGVxEYncQ9hFb+ypwNrrPHqQcz7mzYVS0a2nFy05xug9xZulRe+uj
         YaoQ==
X-Gm-Message-State: AOAM530NcL4/2sbUTkKke+kfu7TwayGO0YKOkhUg+BOt9Y/lHABWmJp1
        j2JW60gOXprHCVm8WEzpaAWAGzdFzsgzm8svBMpiDdNFBpE=
X-Google-Smtp-Source: ABdhPJyq9PzTVDrKKUMGWo4S+OJU8iVZzzgxoDhtgRHDN9LScbPDqpI1lWHo3VbKFSzs9VFnFOgfmRWkm7fboxICRA4=
X-Received: by 2002:a05:6602:1507:: with SMTP id g7mr5086434iow.7.1644542670889;
 Thu, 10 Feb 2022 17:24:30 -0800 (PST)
MIME-Version: 1.0
References: <20220209143948.445823-1-dqfext@gmail.com> <YgPjgvlVkykx1e1G@lunn.ch>
In-Reply-To: <YgPjgvlVkykx1e1G@lunn.ch>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 11 Feb 2022 09:24:20 +0800
Message-ID: <CALW65jY4g1pVxE9hBDNrBtpxgsVXOjQ5HMK_5j1w9c291kqPmQ@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: mediatek: remove PHY mode check on MT7531
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 11:53 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Is the PHY actually internal? If so PHY_INTERFACE_MODE_INTERNAL would
> be correct.

I have no idea. Maybe it internally connects to the MAC with GMII.
Add CC to mt7530 maintainers.

>
> Are you fixing the wrong thing here?
>
>     Andrew
