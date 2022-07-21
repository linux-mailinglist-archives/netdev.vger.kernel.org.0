Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050C357CA91
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbiGUMVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGUMVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:21:05 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311DE255A7
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 05:21:04 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r24so1080464qtx.6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 05:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2pZy5DJQjBfgyMg1vqhhNn+qOuUh3IaBzqXLYMB5SKI=;
        b=Fc3OJcOy8nRjI7VAwpkOSxkNq5K87Jm3nCNuroG2LSWGh0pBMti8ASr+fRWEGRS4Mn
         O9Qhhwd8oacuapkwdxDWenbihDNXOH/zn69OMyFm71Eit61UpvIpfFfVS0nipFSPCxR3
         12ZS/cl22pOzq+mgGGaTB0tN2Lf9CKeEC3I6sfWNFIDclSp9R2s9yScEnlU726zInt+K
         tKzkP4parvU0JRRe+1R+2ZBR5Mq76dCpoGVZ+lj4D+raT4YFAK0v/d4unzYrGC+jLXMF
         CCPz/mI7KjqT03JzqseO4HlSKp4WgXALMqZAWaeC1zVRHKFkfeO//jx2U1zMFFRis6dl
         3X+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2pZy5DJQjBfgyMg1vqhhNn+qOuUh3IaBzqXLYMB5SKI=;
        b=VfHWnnvJHnbQ0Y9cpj3ltdp2PE1Qb94e6YK1PBPfaXn6y+Hx0kLccp4Nbecl8cRsvF
         /NOhCedwJCoNjTxtNmECxsOa4/d6WPlBtIPWIlDwwZL0LedPrJiGgyqkmOwOgaVpETfs
         MkJgs4yxXIEpszvwTxf6iBLi5Se5XfA6gMWvarnTI7bFnuFFhVm1L6FtJZ8qsNnu29wd
         AURnM/P5JcgthzEAzDfpNjmSqfN0++ibLtgC8gh0+oJ2eQCNs2d2ztCjf4nDmCiJ5XdK
         +hOm/p2xhCLg0RjqoDjbxspCVJif/dOEnzeRDjoUh7IV7wTdUCh/0Kfk8kUU9mAcSCfO
         ARBQ==
X-Gm-Message-State: AJIora/sMACd2aVufUcyLBBMLFkrX12ECo6PpZJzyo95QtXdfjLe6eUb
        82YXVEdEFzFzMTiWuhA56+qXaKQ2FdMpi3wQLuM45g==
X-Google-Smtp-Source: AGRyM1sxu3tEGD4A8fQmsFw01GLD5ZnR+fPAn+bO5sxvmIabJUo4yWtpVPaKAHmCldk49uDzk4OdQiuj+igBCpk/Suk=
X-Received: by 2002:a05:622a:1490:b0:31e:f0eb:23f8 with SMTP id
 t16-20020a05622a149000b0031ef0eb23f8mr15367383qtx.560.1658406063041; Thu, 21
 Jul 2022 05:21:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220720233156.295074-1-weiwan@google.com>
In-Reply-To: <20220720233156.295074-1-weiwan@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 21 Jul 2022 08:20:46 -0400
Message-ID: <CADVnQymFw+kPVz_LmEGakJDoCY3EFiu=LXZrnV3ea9NkW=bTBw@mail.gmail.com>
Subject: Re: [PATCH net] Revert "tcp: change pingpong threshold to 3"
To:     Wei Wang <weiwan@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LemmyHuang <hlm3280@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 7:32 PM Wei Wang <weiwan@google.com> wrote:
>
> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
>
> This to-be-reverted commit was meant to apply a stricter rule for the
> stack to enter pingpong mode. However, the condition used to check for
> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> jiffy based and might be too coarse, which delays the stack entering
> pingpong mode.
> We revert this patch so that we no longer use the above condition to
> determine interactive session, and also reduce pingpong threshold to 1.
>
> Reported-by: LemmyHuang <hlm3280@163.com>
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---

Thanks, Wei. The substance of the change looks good to me. I would
suggest adding a Fixes: tag as the first footer in the commit message
to make sure this gets backported to the appropriate stable branches.
Otherwise this looks great.

Thanks!
neal
