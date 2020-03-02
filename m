Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F381175607
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgCBIde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:33:34 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39927 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCBIde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:33:34 -0500
Received: by mail-lj1-f193.google.com with SMTP id o15so10723268ljg.6
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 00:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jj+czksnzcihibM/pJBiF9v6X/Oa3Q1y37ZDoMAoK3o=;
        b=KA2FPLTuZNTxG20mxJ670x5Q/MkTw3ryqi/YArF+IRLfOztsEKPS06DLOlYST++Wj9
         XXJ2cA0S1U+mMv7ZYlyuFDuERuA26Jp1mvf7Y9nTgvQHHGsQp5y93Lh4cCfvMLECLvzK
         3pxLld28nS5OyXbz6rwuLCGHcLdG3OIJW5n9rufMbMdWXwB7ywukNvHX1+OwEA5pzTf5
         nLaVjcUVyRNNlxwMr+g+XR6oBkbLmSqKGBPwM1eUr6FjWj1HCwUJynABGruQ46nlPbxY
         eiKiTKA/g7VvG+8GATHTnVprC/YhnJHlqbajXwenVgqtDTnxIRi22TX3kUIE2XLDZ2C8
         NkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jj+czksnzcihibM/pJBiF9v6X/Oa3Q1y37ZDoMAoK3o=;
        b=neQ5szjfeWMzp6b/bDWVAfTEK3M90Q3t7+9lHkWvD8rncmy9wTBAhrVe1HHtNUoUFC
         83sUt1qfHnTz1QYpZQ0if6pNBfw33PNxIuDZjUfHt4anyIR/pM98TOi+WLjGuxpE6k7N
         UHeAUBynxAKrIRCGFUpl0msjhEqt4E7ZmHI4e62c/qpndZUXiM4Kn5UXuRYJplpY1iyp
         /aZlWTcC8Po4VLiiIhXvzvaBJbDyVh0Qaid/mCUorCjIS16bADsPnOYVZBh5096KxIRq
         Q1CD5Z0svx+oXH9ZVPs5ILc67cg8I++LFvIbQSLl6Nox2XyJco6WUMch9RY7rT2rOeRR
         jdow==
X-Gm-Message-State: ANhLgQ1uWmDH0SYrxNkwr0XuXg0wVLn23knaTv5uXvb8x1yC3FElyu8O
        GpU5SWdlshqTdkz0UqfBXtb86TCPohQXZs3cr6b2YSEX
X-Google-Smtp-Source: ADFU+vvAO7sF6dKvlWn3obeb7QSbc1SMheAH40VPLq5/KZEo7Jd4FUF6JbB7CSybojasouDEtJcwB1bX4ZBlKwmnK8k=
X-Received: by 2002:a05:651c:2049:: with SMTP id t9mr10756201ljo.39.1583138011527;
 Mon, 02 Mar 2020 00:33:31 -0800 (PST)
MIME-Version: 1.0
References: <20200301144457.119795-1-leon@kernel.org> <20200301144457.119795-13-leon@kernel.org>
In-Reply-To: <20200301144457.119795-13-leon@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 2 Mar 2020 09:33:20 +0100
Message-ID: <CACRpkdY+e4ZoOFk_+MnPC_JrcxETWJ+75PUD3Db+=N65S-NRbg@mail.gmail.com>
Subject: Re: [PATCH net-next 12/23] net/cortina: Delete driver version from
 ethtool output
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 1, 2020 at 3:45 PM Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@mellanox.com>
>
> Use default ethtool version instead of static variant.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

These are good changes.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
