Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32193635E6
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhDROgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 10:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhDROgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 10:36:37 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBE3C06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 07:36:09 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 5-20020a9d09050000b029029432d8d8c5so4247895otp.11
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 07:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZZv+B7aQGA+3w8K1rGV024P+Fz4xIb0uuOOhqoU3Cus=;
        b=fObLcZcFbCzSz2bnDIUgFF/WLEpBJKVsbmy/2pIkd7UYKAffq6ZepfVN8Ea1j5dqEr
         EfttxiGq9me+cK7N2YVEFX8zo1n7GexpBureFhSg2m5lKw4I5xZE5K2t3UCe8JJU3JYC
         DAFed2RSOQjgLf6AUMGk2hqAW6MhyNtNnDoliWTrj5ywcNecAk/WPgHs25S6rNa+ED7K
         IYeG04YC7d5WLeTie+6ldybtcJOloENP90eyHNIBqqnfYfW8kNwTqv1gwb+BF96CVw2v
         XB7OqNtvgJ4X6MZ9oBBFdrTYBy8rL4PmNzDncJjRFpCgSY+1LV14wMVzjl/u6t7T112W
         fNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZZv+B7aQGA+3w8K1rGV024P+Fz4xIb0uuOOhqoU3Cus=;
        b=P72G/O/qNnMQBP+VAa67OVe3hc0w+Y6O10PGq/UNea+9m76h1JVwcA0C02fkVjbJuG
         CjvpMy9aojtmp/fUNNSOoSUyIAfP9eDl7uoZJqfBNjPwXjTRoLTftp1iMo0hLZJiV9Hp
         K4Lf6nRH3nub9FlBVLaqpkMYXpAFdd3yJS1S9nQ7gDkM0V7bdbT/oA2NZLi64vnwEVy4
         uaav+zoZY5mZ3i9i55R2VjpODVyhAzpuFw4qBVVdsJWJnms3QalTzVj5eWuyl4GUCMQc
         gVSDBF1iHPF8zfcPqMKDjgAzUhAzzuC80ZMUZMCKTbvBu/rE/bpS7ZmhiHFHOUG2Ugc4
         UO9Q==
X-Gm-Message-State: AOAM5338rDmXbXdZzZOHDGhDkahRbp0HS7JoKp2VtgMEB0YNtQgMMfLJ
        2cL/2qGahEkYwo4Tm7dReJ7/0ukRc0x7xI6r6ds=
X-Google-Smtp-Source: ABdhPJzbJtcC2D2l+UfW9it8gjSCY4i3GKHlAZVToINDRzmHEoAn/0yEhB7EXQBgdXrbFKu/uOk+dczqA0V3jqGDQ4E=
X-Received: by 2002:a9d:6846:: with SMTP id c6mr11721538oto.251.1618756569241;
 Sun, 18 Apr 2021 07:36:09 -0700 (PDT)
MIME-Version: 1.0
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Sun, 18 Apr 2021 10:35:43 -0400
Message-ID: <CAPFHKze3+Ar=OEyoLDvHa9ffwEM6xkM2A0YNN3Z3UrW10y=3XQ@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next] net: Make tcp_allowed_congestion_control
 readonly in non-init netns
To:     jonathon.reinhart@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

It looks like this patch is on "net", "net-next", and Linus' tree (as
commit 97684f0970f6). Additionally, gregkh has queued it up for the
5.10 and 5.11 stable trees.

But it still shows up in Patchwork as "Needs ACK". Is there anything I
need to do?

Thanks,
Jonathon
