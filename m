Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF1042008D
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 09:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJCHxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 03:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhJCHxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 03:53:16 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF62BC0613EC
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 00:51:26 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id t36so9994588uad.4
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 00:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=cEG4g1zhUZJ2SrlYwP3CYawU4gm5kFdRjCcGufByoFmzIUQbI05dppeayBi0krYnO+
         iZdXaoQ8C9CMFEslQKctG7Eb0u8AS7Z8niFnUYtTd8uv9OtFUd5At6tKAl4N+PThQvyC
         4Rs5EbNpdHLzTO8CsE42Hkn9PxsQdoUFAMpct9BqIOOBXqsA9RxLiBMtdnyUnGhQwKRG
         wbYCcpwNwlzBZuAcaEcTfmdtPL8r2waBhUsfblZp0ojg5t6S5pv2pcFMWz1VS3VPvMWx
         a2tbBAIqedqpeboJ49Rj15iOlJP/Vitef0ZDaQaOX+0PRHJyjeAcu1UH7oJX4hHATwxW
         jt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=tdyfk0itXsYLMNamfczqXrI7nsB26BOGQgs53B05oWm/NVJJBginpSnW6UuQoCMcgX
         5qa3xkvjdhEzrLb/DfIC7u4fmJXBxjd8vnM1i6h8rvbJp01+BCdXFYxMrg6gCW2saBsu
         Vp6iKdvcNMyNvOzTshamwCWiOtn7czZmIyglf6Byr5u75wg3KHO9EJJmyMGrU4HPcZTl
         XwyzSAU5XwK1HKmF/0lKtKoG0uRbkNaHBsDiUPDrVkKoL94+PQb/ATU6+b74BQFSAuYK
         QLUP0hAn7LcJ8Qi862sLjvOom1XyjmrGwoQeZnMA8ArgFxm42qVZlI4PzNwASVBWU72b
         ibnA==
X-Gm-Message-State: AOAM533Krv79XzgOrVxwu/jQ8NMK4AvuVDfoGeOIhF1lpZ7iN32RsN10
        lZGgfmLQG+beSZrY/MwqLOMo25SvVg05dcRYW1g=
X-Google-Smtp-Source: ABdhPJzp2Vc0jY1mtzLe3GApJPtErgwGn1RDik79Bl4PqGdPQyYavwShlVoKV5uEWzjOjx9B3jpcvsOkA79SkHsjOI8=
X-Received: by 2002:a05:6130:31b:: with SMTP id ay27mr3520594uab.135.1633247485908;
 Sun, 03 Oct 2021 00:51:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:1b5e:0:b0:235:d55c:28d0 with HTTP; Sun, 3 Oct 2021
 00:51:25 -0700 (PDT)
Reply-To: michellebrow93@gmail.com
From:   Michelle Brown <kpogoakouwa@gmail.com>
Date:   Sun, 3 Oct 2021 00:51:25 -0700
Message-ID: <CAPh0_EAiN7YMSb2Xy2Jnw-=it_BjS41taFNd1xT6sFwxrCVKpg@mail.gmail.com>
Subject: Hi, I have something to discuss with you, please reply me
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


