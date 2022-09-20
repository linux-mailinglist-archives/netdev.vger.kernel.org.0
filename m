Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB525BEED2
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiITU5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 16:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiITU5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 16:57:00 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398646C75C;
        Tue, 20 Sep 2022 13:56:59 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id f9so5922277lfr.3;
        Tue, 20 Sep 2022 13:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CEwnZ1/2LNvWmzLbisGcMVe/dQiYd94D6um2cKygATE=;
        b=bfWM67pknq4tUGVy+Yw0bF1HKULYHRgdYL+DETTuRPmYxeaKhs38pixSL153C/3hDd
         aWfsCz8ve1qCKedZiK5QTW32TZwfnktJh85qztTE1UheFGBP7yxM1DGDnP+gGJrz60Rh
         gLQfyWtrjkLzub7/KxdSJxVVOt1vWHUHHAWOguF4CiwOjvJyQrTARsdIx4RhlECzTLPR
         FeEKtc3FAJ+aAYcFJTM51cd81gnzba02e+WjgBrC1F5UJ/mngNpD5UqvoTaMkpICAgMQ
         D5UIzsEw5TmuwwjdSwDhnP7brAZFO/fUtzaW2u6B7xCX09j8Tzm+FgjpsEgo8WNb4W+C
         3ehg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CEwnZ1/2LNvWmzLbisGcMVe/dQiYd94D6um2cKygATE=;
        b=Xji0NfAgXrNW9mOjj0/kbaUIptd8ZJ7NRy2sbE/bgXIEO9rj+Q1dxHE1iBpAtCgfAH
         fhr1QLEzfmk7Y/YIVOm0vBtca9yiE279/ZTcnA9k4bogKqUfgGRm/nrXuL+oTZpZ+ZiL
         BD4gkSPog7dO9APJ6FF8jOHxY5UNe0n3SF02/u5s0iPFd8sbwNe9LmcXNNznYN29V5k+
         8Ra3+ynY1uBV51lTRpHYRs1jBtDKqrAD4KMtY5YQVg8LBwKrt5/ZYFQOH0SUmWYF1NtS
         XwCR+CzfBg2U1ECqMF8MkO5BHNLE6pJHbWtQNGtKmkHMnbq9rZdgt9FtXxAgmqiOzd01
         w5BA==
X-Gm-Message-State: ACrzQf2+57ylaf8yqwxFGuK9TepsWSu7wtHQ2pBBG4TYTJFRMe0q3r0a
        30ouXZeA0N4S0PZ1iKExY5lbI/TsQU6PB1kfQN12X7mhd7I=
X-Google-Smtp-Source: AMsMyM7hHxF0wh26QxvwA7qY9u+SHrKrc8tk76T4fG6XCtAyWFF6qt1NCrsQBGcxlj1dHjoqmy4q0CcZ7Fh+Y5p6Qvc=
X-Received: by 2002:ac2:5cb9:0:b0:498:eb6f:740d with SMTP id
 e25-20020ac25cb9000000b00498eb6f740dmr8364757lfq.106.1663707417525; Tue, 20
 Sep 2022 13:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220909201642.3810565-1-luiz.dentz@gmail.com>
 <CABBYNZKHUbqYyevHRZ=6rLA0GAE20mLRHAj9JnFNuRn7VHrEeA@mail.gmail.com> <20220919180419.0caa435a@kernel.org>
In-Reply-To: <20220919180419.0caa435a@kernel.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 20 Sep 2022 13:56:45 -0700
Message-ID: <CABBYNZLhMRbvhhb-9Ho-qVarC+KLiFyxiaypHWW=NPqHXYTU0w@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-09-09
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Sep 19, 2022 at 6:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 13 Sep 2022 16:35:01 -0700 Luiz Augusto von Dentz wrote:
> > On Fri, Sep 9, 2022 at 1:16 PM Luiz Augusto von Dentz wrote:
> > >
> > > The following changes since commit 64ae13ed478428135cddc2f1113dff162d8112d4:
> > >
> > >   net: core: fix flow symmetric hash (2022-09-09 12:48:00 +0100)
> > >
> > > are available in the Git repository at:
> > >
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-09
> > >
> > > for you to fetch changes up to 35e60f1aadf6c02d77fdf42180fbf205aec7e8fc:
> > >
> > >   Bluetooth: Fix HCIGETDEVINFO regression (2022-09-09 12:25:18 -0700)
> > >
> > > ----------------------------------------------------------------
> > > bluetooth pull request for net:
> > >
> > >  -Fix HCIGETDEVINFO regression
> >
> > Looks like this still hasn't been applied, is there any problem that
> > needs to be fixed?
>
> Sorry about the delay, we were all traveling to Linux Plumbers.
> Pulling now.
>
> Any reason why struct hci_dev_info is not under include/uapi ?

None of Bluetooth APIs are there, at some point I was discussing with
Marcel that we should probably fix that so we can properly expose
headers to userspace as right now this depends on bluez library which
is something we want to deprecate.

-- 
Luiz Augusto von Dentz
