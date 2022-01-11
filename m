Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D9C48AEF1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbiAKNzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239487AbiAKNzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:55:49 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11F8C06173F;
        Tue, 11 Jan 2022 05:55:48 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id w26so5218318wmi.0;
        Tue, 11 Jan 2022 05:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5QHegbcEygh2W5IGA3CayrM6SBPU+A/OGV2FmBEZvB8=;
        b=NulLQl18nPDc0P6PvcEjc+yU1ZTlH2TNAAD2KgB3zQnSoT7QHhhQlsiQ0uWkbDmbJ9
         f5rDKnX44C9aNNl4OWyUfsV4jc2IAOYsUjrlIkN6ZAwCF0cd5nCXAv7+O/qGUcFMRs/P
         v/VEmJjQFbbtcT/3QgmY7DrxaMbMqLVRWvvaV1qemJRUjGthu7l9nxtBdsr1l0gF2MBT
         CCpwHXJV0L4aSkEIR6coC/ViNLTLhPRMyIs2FWV9j+5mSWV1WNjK/0pvJPZQ2/xVgSpa
         EmIgWo6P8FBKvOp6Ed2fHBfxn3yC/h8TjPuH/wY0M3YqYYZr90Y4tSqPgkv6BIaZJStc
         hunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5QHegbcEygh2W5IGA3CayrM6SBPU+A/OGV2FmBEZvB8=;
        b=R428hTtQ8WKW93V0bwzAi44rSQGGyjLO9/5UodglA8/p8uQ5SkuywyMSMB/qGx08br
         tCbz76DF5oI7KlKyFlu+lCEjmPZ5rEOQAQs4lBSuBIZAcg702B+GXVG3p5ZUZcYNBWtI
         1k5qIcj29tHwUZtIJKaVJZ/df1Qb1Mjg7Lxm3xwpEKyrewWhudXH5L0oiFAngNCd6QZq
         +AwTnFqAg2FvMNeC0eqbOy1B/fp/SYkF3Yv446fzcD+B0rVRJii4u+rlTcJ/fi+N3hNU
         mbbWVNvipg+XcDXdd02XNeA8ulWCOQ11tnAiyNCtx8S6gQJpD/zvjZ44W4H36h9+eTa0
         Skvg==
X-Gm-Message-State: AOAM531BXXNfIzowhk1ffGWaGnEQeGDxjGbz5rSuw9k2TuvfqSjAOa9J
        TOUiitl2qyHzpE67/mNoxY8+qhk+StX2bvG7BkM=
X-Google-Smtp-Source: ABdhPJz8QQziEnUftyubzwIgqz2M+dbnbj1BFQWQo81+ecWeHjfvQikJL7IiehweL733BoK4XsFnLW2OWESHx37z1sA=
X-Received: by 2002:a7b:c142:: with SMTP id z2mr2513949wmi.167.1641909347544;
 Tue, 11 Jan 2022 05:55:47 -0800 (PST)
MIME-Version: 1.0
References: <CAKcFiNDyPSx_M9HJNhDJd0Omq4JFLXNjDR_9bxaSjvmPc2bXxQ@mail.gmail.com>
In-Reply-To: <CAKcFiNDyPSx_M9HJNhDJd0Omq4JFLXNjDR_9bxaSjvmPc2bXxQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 11 Jan 2022 08:55:36 -0500
Message-ID: <CAB_54W7d80pgJ-9+0H9Gn6-NO6j+qzKDXVr3p_qYmbTXo2OCRA@mail.gmail.com>
Subject: Re: INFO: task hung in nl802154_pre_doit
To:     cruise k <cruise4k@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Hao Sun <sunhao.th@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 10 Jan 2022 at 22:01, cruise k <cruise4k@gmail.com> wrote:
>
> Hi,
>
> Syzkaller found the following issue:
>
> HEAD commit: 75acfdb Linux 5.16-rc8
> git tree: upstream
> console output: https://pastebin.com/raw/AzAMX5zz
> kernel config: https://pastebin.com/raw/XsnKfdRt
>
> And hope the report log can help you.
>
> [ 1251.721354][   T59] INFO: task syz-executor.0:2134 blocked for more
> than 143 seconds.

any reproducer here?
The console output shows "ieee802154 phy1 wpan1: encryption failed:
-22" so I guess something was configured.

- Alex
