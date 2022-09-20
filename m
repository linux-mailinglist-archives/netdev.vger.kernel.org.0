Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F575BDC75
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiITFbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiITFbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:31:00 -0400
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B035809E;
        Mon, 19 Sep 2022 22:30:58 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id n8so1041230wmr.5;
        Mon, 19 Sep 2022 22:30:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Rphv95Xrtt1Zdptx21id0R/NuAYlwKXH7LmqP1unkc4=;
        b=WvI7bEf+Fu6I2pCb9KoVLtIgmTcFbC3vzZBp8MykSnMVaXkWycPuizyehGu0J6y21B
         lMdhnCJhMEt4B5uzYuJ49369RMFeOZkPCm9dde1at3WvgdK3iMKuOXrtWx2BBn7VkLwm
         OdLmc4CgYG0EUxL1IKQ5WVML7amCFgsQiGpYixQ2qEofV37dopAxjaxhDvxX8YT0UT0E
         fLGofd8loL2tu4sIXpMEa33VpXaPiE1N9FzOv83oLfUIq3JEwAKyD5FqNuZSL508agjd
         g4qAG99BjG46CVuL+1ssOoMn/jZxPZXQorFGFQkmx9/nPWC2VDXp8N1hqbk2qk+G7FQP
         xxXA==
X-Gm-Message-State: ACrzQf1z+6wCuRozo+QdfN42u1vuSD68KhdGZltxiPJOo/X1bIGCmwlv
        piwz44KpChdz36SXweWUxRLmAQlleg8FJ2g80Lh9Wbqv
X-Google-Smtp-Source: AMsMyM7+PmuksUrPhv1/Gircj0gzb6uBRMbrVms0Ciyy74VISiwjAGgpGfOYFhLtm2RhJKwiMRURDzdJl7TSG7rubS8=
X-Received: by 2002:a05:600c:41c3:b0:3b4:9668:655a with SMTP id
 t3-20020a05600c41c300b003b49668655amr989157wmh.36.1663651857467; Mon, 19 Sep
 2022 22:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
In-Reply-To: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 20 Sep 2022 11:00:45 +0530
Message-ID: <CAFcVECLTz6K3feNveiYSkrR7A53wntCsOyzzCiNH9h4qG-vuOw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: ll_temac: Cleanup for clearing static warnings
To:     Haoyue Xu <xuhaoyue1@hisilicon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        huangdaode@huawei.com, liyangyang20@huawei.com,
        huangjunxian6@hisilicon.com, linuxarm@huawei.com,
        liangwenpeng@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 17, 2022 at 4:10 PM Haoyue Xu <xuhaoyue1@hisilicon.com> wrote:
>
> Most static warnings are detected by Checkpatch.pl, mainly about:
> (1) #1: About the comments.
> (2) #2: About function name in a string.
> (3) #3: About the open parenthesis.
> (4) #4: About the else branch.
> (6) #6: About trailing statements.
> (7) #5,#7: About blank lines and spaces.

Thank you. For the series:
Reviewed-by: Harini Katakam <harini.katakam@amd.com>

Regards,
Harini
