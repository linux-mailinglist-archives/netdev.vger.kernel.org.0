Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D68D203DFD
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgFVRcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgFVRcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:32:15 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EF4C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 10:32:15 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id z17so2340671edr.9
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 10:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gr3GdeWDwLHVskMEGqhIrUT3TuFstT+fPfFCySTNpIE=;
        b=rwPHFJ7mXit9nw8qbcK3Mqw28TiE9PWxlwNxuEg8iierodqPECUKt6M1sdUiSXiHjS
         2lgj5Uo08GLpIv8jr2Q5NOoZp/c6naSLIHFDG5VQXg0h+Kn/wZPIC4x6VVOYpUSMHD3x
         EFN5CzGgRHO9OA9Hy9HrvcYElRrmSN0pI0aYM4OlG8gwyM1CTAIGbXc9Tfq176kFzdJH
         Dxlm219W95l6GPf4u51Auqiz6u+ub1MNtYM9ZM30E1f20ODvsGX5Cmp5Lzh52No8PB3J
         PlR15Rza2ZTjzxCjYnIAeUI75C1yYD2P6m2nWBeaiWiYtI/Kx4OBFZKnP/mi9A1qxQvZ
         ZV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gr3GdeWDwLHVskMEGqhIrUT3TuFstT+fPfFCySTNpIE=;
        b=LiMblJk1W6NplGLBEFVk2d7ewZg4n7qs3j0u6yQvEh1fzYWkGlfxv/pimvUvTvNVGo
         1nrpSQMkW9fVurUd05ZZCvPyOAkvQw+KHGSktI0ZcUQIKqAFhr4VCcs8jFNf1ay9YrMz
         +62lkfIamSfwF5NnHAT6AsLmUW9aPt5VaYlzRQKZagOT7k5yfr1fXvbR0YdnSuq71vTm
         0RQTU3nkvhGChtQipFXcuOzkzq0kF1PmgTSJCuRgUI2xa9jXOkM9Ayh/233O+u5cwf0p
         P2xGVzJXIpCJDD/ajwMi89wyFHTjjxyzG0KvQ44XDwXXJ4AvNMt2f4nD9QGKJZcQghe0
         aYjg==
X-Gm-Message-State: AOAM531fMRgVQphfShAdb4feAfcxZ9cYc3+1TagmXz5TjBjc+66RAkhH
        K05LnuFq1ksCBJnDZLx1fqLiEN7J7c7tJFf0ciLJJ11ajiM=
X-Google-Smtp-Source: ABdhPJxPaJNiORr2o1WWz+ojX1GWmiIKDEt95HPY5N9d0kNXMmMaJrQQVlNekt/7XGsvyqqnrp5SwlPWGVtKjVvV5kQ=
X-Received: by 2002:a50:d790:: with SMTP id w16mr17401224edi.231.1592847134024;
 Mon, 22 Jun 2020 10:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200622163022.53298-1-mika.westerberg@linux.intel.com>
In-Reply-To: <20200622163022.53298-1-mika.westerberg@linux.intel.com>
From:   Yehezkel Bernat <yehezkelshb@gmail.com>
Date:   Mon, 22 Jun 2020 20:31:57 +0300
Message-ID: <CA+CmpXuO_bQbBPE8ERuTihDXi1NkRFDpARfHf71GpQuZthUD_g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: thunderbolt: Add comment clarifying
 prtcstns flags
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Jamet <michael.jamet@intel.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 7:30 PM Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
>
> ThunderboltIP protocol currently has two flags from which we only
> support and set match frags ID. The first flag is reserved for full E2E
> flow control. Add a comment that clarifies them.
>
> Suggested-by: Yehezkel Bernat <yehezkelshb@gmail.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>

Thanks!

Reviewed-by: Yehezkel Bernat <YehezkelShB@gmail.com>
