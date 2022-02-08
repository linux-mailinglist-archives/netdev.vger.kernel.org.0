Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129B34AD4A6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 10:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354062AbiBHJUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 04:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354054AbiBHJUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:20:40 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A161C0401F0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 01:20:40 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id g14so47923575ybs.8
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 01:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=8+ccEZW6h0gHAxWu7MVphcttMXtY11bgaT0X0vQUTvw=;
        b=pmfpQjVT+7Ge27xOv93VHhO/QGtpzetTEoGIPrI/v8tn6OO7xRBcPBz08riy8HRVY/
         AG0lY/7yY0aQWif2KdnPzM0IoqLoT5Q3CZdXU8LeQi0qgbHLSg8vGSP1LKGatHRPllD0
         H4irjLPQa0+JClX+7n/D3VGigxM37N+Vk2OwRz4Wl1+nzWrXsYhul2NUwTTlgkm2QJ60
         lGW/IHQ1L2JUv3TjCG9ntYU+SPVsBomLxT/xSYvbSyFPnTxHsz5thY3WGeQ4VIWx8pr6
         J5Y8KqYRHx3Hth0AocdmvGyoSlrU3y9rgU2ksZc9woF5Iyv+GLFN0sGDpHOB8HoyHzaV
         KaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=8+ccEZW6h0gHAxWu7MVphcttMXtY11bgaT0X0vQUTvw=;
        b=hBejSv4x0dlEhBSngeQ8E/vVg02HAfsaPdnlLs+dBZfH5BRf8Bfp8r+JO/3zMQpbYn
         GAVMYdtj7DAebIzxgLWz9CGGcIXHeyI8O5BPe4qHUpHaxJX2DSfUl5fmleqMTVLXI3xM
         bXLswIGoXjxcSRD82oWuf2R8LR3JVV5xGt9LU2ocwjTmmUHWagn64Jw3ftgnjAuoKJL7
         Lff2vVKrAqvZszDyKSXiDq14tmcSX7UHIdf3Hc6wGixeahS7sc66bGt+T5ZfdBbcDwIQ
         M8EZxfjvoqCxiccBixsjbFkYVtBuxPvGBF71QhEdXc5FNAdHuXY39jblLy2vjsO8995l
         xTRw==
X-Gm-Message-State: AOAM531tJliUyGD+8NE29Po/pbzLrsQRSGpvlUhPBUKlZ4cmwEhqdi9D
        CGeDHqihFjZCB/6YkX2zjmJywajTCurU+GXbHaw=
X-Google-Smtp-Source: ABdhPJyX3U0vvHIbYKi5uvroV7pJ1QjWc5OOpJXcVJVcZ1zV5NtKD8bHNu2ncTnS+z1dOCRwbZKXl8qtAaqyCDa2naM=
X-Received: by 2002:a81:c502:: with SMTP id k2mr3871601ywi.424.1644312039814;
 Tue, 08 Feb 2022 01:20:39 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0d:f683:0:0:0:0:0 with HTTP; Tue, 8 Feb 2022 01:20:39 -0800 (PST)
Reply-To: file19713@gmail.com
From:   office <officfilebj@gmail.com>
Date:   Tue, 8 Feb 2022 10:20:39 +0100
Message-ID: <CAKgEHBHvpYtRpKr363pf40D3o9Ltx-Je=ffg2RpeLO3cZGaLZg@mail.gmail.com>
Subject: Good Morning friend.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Morning friend.
Good morning my good friend how are you doing i hope you are doing fine.
I am Rosary Moses i have something important i want to discuss with
you can i tell you.
Waiting for your reply contact me on my private email rosa.moses1@outlook.com
Rosary Moses
