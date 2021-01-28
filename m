Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA82307E74
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbhA1SsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbhA1Sph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:45:37 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EA2C06178A;
        Thu, 28 Jan 2021 10:44:56 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id d2so7843018edz.3;
        Thu, 28 Jan 2021 10:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7KqrQELa5Ib7c8yGtm34ctZRTTgOgBVXw/XDTJkuZzM=;
        b=IXUtJ5Szhp/b70fyb4fSpJB8MQDglir6QCQtRcOrmv1bOwcD30SolN6AWHVYYLzuwS
         Ph9uWqoX8bPzCBV5yduoFUKIMf/UTx1rJTaO0PZoaUQLZXV3B5EJcQQxwUEA5XuZ2d3s
         CPYwOuFB3/APwHAQ3lBl+Ic/R+5RplfC+/sBICq2Xs93/BbeEaV7gefkYvgc7UaF9nKw
         pyXGaplyNyZNFjRpLi+t3zesfnHoGqLYcjCKlX9WVN5eFXEW32BbGusLapPR6aRLoKeC
         lzeArUreGdckovm7Dnp8qmYzXUyrLZzgSqhE+N8/+Nx25xagQ7UO5FFCOQIdZfC0vK1X
         vkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7KqrQELa5Ib7c8yGtm34ctZRTTgOgBVXw/XDTJkuZzM=;
        b=ogCpXC1JFrPWlzMro0/tNi/7ppNGLQ12sWKglQh68DwsU4Hwua/wq12JoAVsozlJQ5
         LKnXr4HE61jjgPmCegWsvDcat463jPkB2ZQ7yKPZqLnytQppMDfuFZwAlHNo1bKs/le1
         fJ1ykVjQIZ+WbvWR6J6TAtrNL1X/gl+2N+sl3nB4Q1z4r7rPul7mmZOZ0iXeyhYGdJFR
         ReZ2GnzVYLvRnKP8hxtdzcYfPem4iSrAoZCFaVDR+qgrKcgXPYuHbKGU0aXyEubQnxHy
         C6MJiIKJ7EgZjx568MkP3c0qPhmvXMiHAxh+BHF99JiNf75bLOlyTbW/fQ59GVS+OCuf
         bRnA==
X-Gm-Message-State: AOAM530xWh0hcK+GJSM+lwrOlwFYbX8sPLyn0POZRzGlf70LRQhqYY/l
        X9v7n/5hYb5AWLGVKJkqMVGXaixNpCOxOtek6kg=
X-Google-Smtp-Source: ABdhPJwYXgpelFGaMKtoBoeGm2MCJD/XU+Wcb7Htk7rD2MP9VZhUJRVc4yNmq5clr0JIitmRa50x0bg55Xw+iNAQrBY=
X-Received: by 2002:aa7:d1d7:: with SMTP id g23mr1120272edp.6.1611859495550;
 Thu, 28 Jan 2021 10:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20210128171048.644669-1-colin.king@canonical.com>
In-Reply-To: <20210128171048.644669-1-colin.king@canonical.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 13:44:18 -0500
Message-ID: <CAF=yD-KvXYW-r69k8Mf80uQ5Ww60HEfT+FrxNbu4FCxOF=Xy0Q@mail.gmail.com>
Subject: Re: [PATCH] rtlwifi: rtl8192se: remove redundant initialization of
 variable rtstatus
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:15 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> The variable rtstatu is being initialized with a value that is never
> read and it is being updated later with a new value.  The initialization
> is redundant and can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

(for netdrv)

Acked-by: Willem de Bruijn <willemb@google.com>
