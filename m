Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB45B7D8D
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 01:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiIMXfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 19:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiIMXfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 19:35:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C4E248CC;
        Tue, 13 Sep 2022 16:35:15 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id q21so22595901lfo.0;
        Tue, 13 Sep 2022 16:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bVO5S1zqxCUqEffUTNU9S9hb7fEK6sMCdeDDGuu+tF4=;
        b=LLIi2I6hGcC1og6iBhKeCPdObNijf2mtxrvlHGUtk5kkENdn5W40sZo3L1OUbgwNRC
         N6xTVIHWe8v1/kVgOlzZTeh75XFxGK3+5O8MES7PUd561EjnipbQkTS2ZABO4YAMYevc
         A8JfD/jpYpG5PFg1YH6yywv4atNiwMyJORaTRaD2/QMF1rfokygCEZsn/1acanRK8aBa
         xgplgm/gBT7rlOwElBcqttKrUibV9vxvdbRYZvk5MKCGhQJglwGpG9hjbpWjyOks9rDW
         nZjnlr6/lreUfkloJom+fAu/0uDi88VzCIIYj2W/1YES2Az7lUHfv8TjV/WQjUfpLz2B
         dIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bVO5S1zqxCUqEffUTNU9S9hb7fEK6sMCdeDDGuu+tF4=;
        b=7XWIGYM/qf/7PaKJr7duuHZpE3bfUXxMZTLAgYWYhkvORFQDkZr348+yBOxfuOFmqq
         yaSXa8NXMBjbvr9MklxPWg1OWUchmsSiTDts583BIrerpWdvHmvp03MVaJ9jI49wd76M
         QymjlA+4vMT7Cq/wzTyJcFYuGNG9R5rcp/2BFMum2TppIv+NZWynaSc2qEw2wCr2p+Xz
         X1K56paQb0FZTlfLitZSc5AICMnaHfy573mcxa8SLG+yIK9Mj16CDWWhGG14++/fQKl5
         KPkYnwQnkSDZVQFIU1GAL0DyqsSwLeiPIdmQBLzt0tAaQIvNNgsopWQfkqX9depZ169P
         fR/A==
X-Gm-Message-State: ACgBeo1ebuie5ofOJRgDTgRpGVLgfYOJnLaYAh3LcNAnGekzocF2XNmc
        /fhRgsCin5P9hcJBmcWuQwSbw/RVwSCSdubD11X5xrJc3xorDQ==
X-Google-Smtp-Source: AA6agR7DM93EKmXg5btQfskEOqxJWN4grRXJjLusdHfbZ7eBUCBF/vWHr0IwRClqz+sx5WNL1PXyUrNLvbGZf2jjbVQ=
X-Received: by 2002:ac2:5cb9:0:b0:498:eb6f:740d with SMTP id
 e25-20020ac25cb9000000b00498eb6f740dmr8791526lfq.106.1663112113269; Tue, 13
 Sep 2022 16:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220909201642.3810565-1-luiz.dentz@gmail.com>
In-Reply-To: <20220909201642.3810565-1-luiz.dentz@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 13 Sep 2022 16:35:01 -0700
Message-ID: <CABBYNZKHUbqYyevHRZ=6rLA0GAE20mLRHAj9JnFNuRn7VHrEeA@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-09-09
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

Hi Jakub,

On Fri, Sep 9, 2022 at 1:16 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> The following changes since commit 64ae13ed478428135cddc2f1113dff162d8112d4:
>
>   net: core: fix flow symmetric hash (2022-09-09 12:48:00 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-09
>
> for you to fetch changes up to 35e60f1aadf6c02d77fdf42180fbf205aec7e8fc:
>
>   Bluetooth: Fix HCIGETDEVINFO regression (2022-09-09 12:25:18 -0700)
>
> ----------------------------------------------------------------
> bluetooth pull request for net:
>
>  -Fix HCIGETDEVINFO regression
>
> ----------------------------------------------------------------
> Luiz Augusto von Dentz (1):
>       Bluetooth: Fix HCIGETDEVINFO regression
>
>  include/net/bluetooth/hci_sock.h | 2 --
>  1 file changed, 2 deletions(-)

Looks like this still hasn't been applied, is there any problem that
needs to be fixed?



-- 
Luiz Augusto von Dentz
