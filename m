Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093B657A02A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237683AbiGSNze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiGSNzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:55:15 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3657B118BE0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:07:37 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o18so13410322pgu.9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7OeyhKy33tjaQjUvxDWPrUFGdB2XFzU6lajnqJi6xk=;
        b=CMUudVKyLmEeRR1g0fwUj0mviEc/DIgU7vno9MKbpIyvk3OEzozlmEenkXoqbjML8B
         BduU/dcfleC1Bl0cwanVmxhd0XlkOP/+1xVVfEb3G1jMaJDyqsVL22qDYN6ygDKh/eGr
         1NYhuYvnntnW/uOOwPMHWTt9oUeBqeLQuTjMqtlvjE6u+9CV2ZSiSMbvuCswE9I3nZtv
         VMTeqS8LhHitlk+t4LK6O/DUDXCGu97bPyYb59wjhl78vQfEY5x1yVmOpph7t0M688zt
         6v0tLKRqXyFdH96JFujGTo7plvw8QFJTG4hutR3/wlqOLJh2o72/2Pp2RHHQiXzLzHKE
         BzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7OeyhKy33tjaQjUvxDWPrUFGdB2XFzU6lajnqJi6xk=;
        b=Qw5WvPUGJVBKA/uGqmGoj+6blHRt0CWG4ICpuJ5P0W2jErsikA8J1OHwfHci+wZz7I
         y6ajaEr+iCeUZps+AvOtv0BGwbNb3bIQe/6qka9yH4wB8WaHAeqnGP1jYLXpoDe+xMI7
         7t2eAxhCOS01uENJORxjxu8Z8zkL+78ZavSU8kdn3vnWx+J15gNf4CpiuOLEE4nUFRYp
         WuZQTrtK5IyTQXQthWzfi8+35tpb7XjGQHajH/CKotMMzz26xfkEKRT8m2Bxs73qhHwB
         2AxNNPjhDiXcVtXb0tIIKtFO5rTila/wowDXhbCOSSzhy1T7BLMXdkW5V6tj+54j5gvK
         faIw==
X-Gm-Message-State: AJIora+P+1fdQSviRSQqHbNyE2VG9jP675pTwx6nGcuazLnOQsZbVK9H
        hAlvMiy5we1MCfoGewFYifvfcJX44eH24CuufM4fuw==
X-Google-Smtp-Source: AGRyM1tNdcc7kvbuniu51mt7jC4y1M85Cy5fR54aLpXr3/darOHYg2KksIbENKLcQL1/x1IOFT9zRBGVj6XAwf0phI8=
X-Received: by 2002:a63:494a:0:b0:41a:56e8:62e2 with SMTP id
 y10-20020a63494a000000b0041a56e862e2mr692074pgk.586.1658236041667; Tue, 19
 Jul 2022 06:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
In-Reply-To: <20220719121600.1847440-1-bryan.odonoghue@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 19 Jul 2022 15:06:45 +0200
Message-ID: <CAMZdPi-TUafosjJ_pwQ4F-N3WnnM5_0P7snB1qmgmzBeqkZu3A@mail.gmail.com>
Subject: Re: [PATCH 0/4] wcn36xx: Add in debugfs export of firmware feature bits
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 at 14:16, Bryan O'Donoghue
<bryan.odonoghue@linaro.org> wrote:
>
> This series tidies up the code to get/set/clear discovered firmware feature
> bits and adds a new debugfs entry to read the feature bits as strings.
>
> cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps
>
> wcn3680b:
> FW Cap = MCC

Nice, but why prepending with 'FW Cap = ' string, we already know it's
a list of firmware features.


> FW Cap = P2P
> FW Cap = DOT11AC
> FW Cap = SLM_SESSIONIZATION
> FW Cap = DOT11AC_OPMODE
> FW Cap = SAP32STA
> FW Cap = TDLS
