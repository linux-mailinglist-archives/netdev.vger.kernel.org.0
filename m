Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBC28343F
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgJEKzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJEKzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:55:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44DBC0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 03:55:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id y15so8302215wmi.0
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 03:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=GGoqp+OlZu/zVvDYZz82pzyaI6QZPQJZBVTcZS6ccdw=;
        b=hanVs+a40yCeiiCQicH+PyVwlezxKb4JPcYr9u5Lxs3PY0TM763R5p8ZkD4INAQql1
         W/IKGvV91ysNQ1BW7IJjD/U6sPfQbVcIJfq4flxFg1+GrBZRGzAWaMRLhV2zvnY4Jl5x
         CyEOg9T4VAzuVjY8VSuN+49MHnurFLtVKbbM9rKQKvql9LTPe9/kjv9tM7EF7Lmw36B7
         zcvs0Wj5p9LVe2HHWXrJCUlk52bcsYBy/6JrgN30kZSJwUamTlyjUuhpJhqtvfULh36D
         w0tLw3NaPgbYJgAJZZ5yC/hL486aF84OwmS1Sv/GyJEPdNK93aDAaXD61lxQYcPt6anj
         Y2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=GGoqp+OlZu/zVvDYZz82pzyaI6QZPQJZBVTcZS6ccdw=;
        b=iSDbpM95jUS1lTDv/zOxNwv/Z3NgFgGi51tU4hfNZOIN3yGfhmII8w3LgGFhhkNhVo
         DORCNHfcz0r4y7bIhoOePEgXk0BdRU1RQDf7LLhVysYEopyT65sQhNJ5S1xzZ+RIpZHk
         FGa0FBE0bnaLhOWCGu+XEXEW7JdeqOsL8dflZz3Z3U0l/FvgHfP/9Hasyy3dEE5FYPqa
         gdqSAqU8vgTmf7gcyFC9L//uzt1OlQX9NZNHr+9ag4JdHWqV0Prs3cGBa+H033kxIjei
         ZkzqUeqpNUi8hHFB2BXltBQ0ivS5wLG8Ct0R4zmV2lzLqPIekoRxNahTUfI5hng27C8x
         FTTw==
X-Gm-Message-State: AOAM531YUzhi1op6RThBcCrawmMZVDc1kPZMQ7yOf0yLJ3TwXfxfhP/J
        f37FtqUN8aY0/u2jQ7SbT/jB++VyRwhfZIFw9pnQWyrwwfo=
X-Google-Smtp-Source: ABdhPJyCK7cA6D65hdiRN5DA+qvRnq4SoIP06UTlnAXaVokM9rugkuuYxtMelvlIq3Y8mMejUiD5U+nsnBil39JMcg8=
X-Received: by 2002:a1c:9894:: with SMTP id a142mr15818686wme.167.1601895344362;
 Mon, 05 Oct 2020 03:55:44 -0700 (PDT)
MIME-Version: 1.0
From:   Mohsin Kazmi <mohsin.kazmi14@gmail.com>
Date:   Mon, 5 Oct 2020 12:55:33 +0200
Message-ID: <CAKkt9+JK2GwWjb0kcC0RASNyW=sVtdXc23UkRNHomRxPoDoUHQ@mail.gmail.com>
Subject: TUN/TAP with virtio-1.1 (packed rings)
To:     netdev@vger.kernel.org
Cc:     Mohsin Kazmi <mohsin.kazmi14@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Does TUN/TAP device support virtio-1.1 packed rings?

Thanks,
Mohsin
