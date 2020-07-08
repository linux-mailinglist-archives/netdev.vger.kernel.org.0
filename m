Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A70219024
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgGHTEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGHTEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:04:38 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A9C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 12:04:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i4so48132128iov.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 12:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/GnEDsTEui6RtiKtXZLF8+1Cpdjnr4z2NpMZ4oWWUZQ=;
        b=X41V64M53ND62ZvjIeHgrr6FdHeXQJwpC2a7IPHIsJA+3jFua7SFMDkfuTtGDFYVNd
         NVmqMIHvxVDhBpncxPSLS8sWsPn2a/SHxq2gKGpeQXuIjpB/cA7+GbM9LCzcUEI8aI7v
         Py9jFvGCqMPgsn9lwGf7YEs6Rd7sJYP31woeFBax5gjTnDpBYej0O3UW4hDgE1v4siDB
         4nrmAXdtuFpNE+yMi3mZuQXztoZqJw2Ig4GbcF/cnzVEYdoMl+QVbR+Yqwk+prN9OTMA
         RBP3mRFhjGgu2tLydhw7AUgyWOKkD/GSvf74XRJk5MZC4uZRVhVD8RX3dq2TVNg3TqiG
         IuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/GnEDsTEui6RtiKtXZLF8+1Cpdjnr4z2NpMZ4oWWUZQ=;
        b=HJUCvKz41rLyelXJUagRjFnKCwRNHUmjJgmREAknzBnBo59pi4f4+7D4+uLyocXn7M
         G5QgaNa1IybnUkJCQv2u0BXLidNQDzl2vNFq+ORuZiT8Ia0xEbg6j5NcCXtVPivirKlJ
         64TToGmNKgZFZ7K87oy5YKlELgUiAfs8b5s7LdeHLcbM0cCqy6OubnO/8uxcFLuHWVF9
         0zeP5g+MH4qJsUsHl2DWlUGfFJOwL0B4jGG80VoAzuDm+78A04Id7zD6J7bQLdBh8Ed6
         W5mJnU0zDDYzjYnJ1P6ZLakICZkTzgO1nZah2but/2b5eqTBnpJpmbiDLP57is/aBSwN
         C7GQ==
X-Gm-Message-State: AOAM531ZOizyTOEKVLzt0uh/D2fIBbiVEUkhrNeT/iPvnTmPi3wKSkd0
        WD0cnmB6EsNbkaZ88HQevzIKIwEqXczBRcbVlp8=
X-Google-Smtp-Source: ABdhPJzUSDoEv9OlwmobsRzu22w4VV7iMmCoVrLSQIsAm6V3UgS+ieMtj1gC+XWe7e6mGA1jiMjXrxzT6RqS+CZwLKg=
X-Received: by 2002:a5d:9819:: with SMTP id a25mr37050073iol.85.1594235077953;
 Wed, 08 Jul 2020 12:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com>
 <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
 <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
 <873662i3rc.fsf@mellanox.com>
In-Reply-To: <873662i3rc.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 8 Jul 2020 12:04:26 -0700
Message-ID: <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 5:35 AM Petr Machata <petrm@mellanox.com> wrote:
> Do you have another solution in mind here? I think the deadlock (in both
> classification and qevents) is an issue, but really don't know how to
> avoid it except by dropping the lock.

Ideally we should only take the lock once, but it clearly requires some
work to teach the dev_queue_xmit() in act_mirred not to acquire it again.

Thanks.
