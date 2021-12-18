Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7548647983F
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 03:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhLRCzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 21:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhLRCzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 21:55:08 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE02C061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:55:08 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so5166232otj.7
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 18:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hxHGc3xjh8IALy8syfeZfLZP9o9CpTimRzgD8xgr9WY=;
        b=Oc6aBl7Ui+WvG2fzJoshEDWe6uuKEvZgyvS7MxbReEQHvsdbjaXYq9LQbbmOhF4bJB
         lkoFJJAp/JB5v7ppz9FGVb675mk5bQhnwpF7DkbbPC6B3KklPEpRFysVdoHpQNCBQP7U
         XsOzIP+jeBc8StXD8Dw9eBYJ4yns+uR4KkTQtEO9CEGoukee3M4J9xXvuDnLdTCPfZSw
         R00QxJvQj8d74cJuwyDx72J+/xYBu/XWutWMkfRJSYc7hPjpdXXDtdim4ScJkNtCqgdJ
         XE99jZuoz6JziWlifgz9MiYxUTUUCNnhvrRMYlR2Kk0eccqU3urntmJ5Ma1Y1/5+pkIU
         VeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hxHGc3xjh8IALy8syfeZfLZP9o9CpTimRzgD8xgr9WY=;
        b=S/tQzFE9cNTQlWRpp8RQ7O8M391zjvSHKja5basAgdz3aiGCeDwwIVpTqX0fdPQLsq
         x5TrcQ9dVsa6IpjKWEragGC9gOu6JI3rlS/+GX1ynqFMdGZHDL74mNWXncwLjh5/UzXO
         mXFx6J2nwtae8eokaMGkgmkukNCLyJhHWuF6/eBb2EyywHwUyjcVFY/hYbb+mfk9jthq
         5vPQc/KDx/7Dzos/bW360nS3FaSbr5hhRCBNAK71CrcW09pxCX5tBxk/7ZCytFzYYmxi
         gQG5l39CLOOmmNJQ6ErmX1d0oH5gj9EZPCYhK6ifaBqJPEkNYDgZIK8RaeCcbGGPraUf
         padg==
X-Gm-Message-State: AOAM530mmxgP05O5ZilC2yQkpta1+mYybxsMok03HD8+bjuQN220cnZO
        awK6gzXNRz0AHXzWqSXxp0ng79b2GKaaFR7gXSJT7A==
X-Google-Smtp-Source: ABdhPJyPQrZl1DhkXJL6I/7OahWnwCBrwLN+HUkRBlOhCPqXfmbMeMB1ZSHkcodfzCwa12vu3x930FrTJTiASlziKQ8=
X-Received: by 2002:a9d:74d0:: with SMTP id a16mr4066389otl.237.1639796107748;
 Fri, 17 Dec 2021 18:55:07 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-9-luizluca@gmail.com>
In-Reply-To: <20211216201342.25587-9-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 18 Dec 2021 03:54:56 +0100
Message-ID: <CACRpkdbuDurfS8Pd+K0BgEUO0k8AXuwN1zYpH6TNVXKovggtUA@mail.gmail.com>
Subject: Re: [PATCH net-next 08/13] net: dsa: realtek: add new mdio interface
 for drivers
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 9:14 PM <luizluca@gmail.com> wrote:
> From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
>
> This driver is a mdio_driver instead of a platform driver (like
> realtek-smi).
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Needless to say I'm a big fan of the patch, I'll wait until the next
version and then I'll test it on the actual hardware as well so we
make sure RTL8366RB is still working after all this!

Yours,
Linus Walleij
