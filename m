Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A21047A29D
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 23:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhLSWYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 17:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhLSWYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 17:24:37 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE07C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:24:37 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so10389207otj.7
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 14:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ds5rFsKht1xQDYUI6HGC0/XFRQOPgkw8sDLMRpYt1eQ=;
        b=DvGNof6KFC/ZGT48ydWF3gEh4dxBttFzg1yEVGwUeiu7q2uV7inLtvyBy19Pg/1LcK
         d412JgSbZRcZprYpgVcUB94NdUghN4WgawWOc5LP2fTpAkvabModYSwUpmpHRTGOGPZ6
         +UxlDBZX07dEwhxWVOlH54YSJsucxlG+kh1FgQ1Knvw74DR9zQ+iW/eGa8jx4ybLESq8
         dEK8C3bcYftZDiZH1/0XjCH465hEGqhvlvD4E08QaUx3TiV8Mg5fj72G6R1Qgmj1/AqR
         aGo9A1rXzQjQTagvhua4B/WhUkCWRPLb0XY19UtnvzKIYQHIgHtlcSsq8mOUPfyegPbu
         jk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ds5rFsKht1xQDYUI6HGC0/XFRQOPgkw8sDLMRpYt1eQ=;
        b=l/hZXKiioizCuLbaHXC/rHxQnqKSxEQb9fC0kiOSlRP7QvOo5W7l1fRaiqrbrUKbpU
         zaEOA9oAZlJaz3VSNBKtHnBUwycmCnhYoWUmifpNsH9CxwSevfleFedndZJshW0tqIyV
         8NYviakTibV4cAjCGug2oycw0Sg8LmnvjfoquPQSa+8AKG8j0jIprhuoMPcDC8lKG3qg
         ece9Fhj7bZBuqsWOHIlPxdiMOptcO0nhC7QLkIGOo2KRWX6lwi+IsGzfA39uPtPZnVQq
         +EptZXWvtt1vDLG+1pXpAFFawVtk1PTtXof6ep+VzHl9cHs/SZ5dN2cLXUjOkZ1ZnFmu
         S6nA==
X-Gm-Message-State: AOAM530X7w9M6B+UBkhtzBgzgm02qxS8eXuOntwgRfG6khRMICCPiC0Q
        M0OlUTR9ohYkQPiWznFy9nYAjslFcpcHVLNAl9Tjtw==
X-Google-Smtp-Source: ABdhPJyY0QKZs4ZdlL752Z6FaZ5Ifczaq9QKwIXZbOQVWQHLTWPLUpUYYrRn22vIih+Z6bfAHfMIbUe0SYfkcokhNTo=
X-Received: by 2002:a9d:a42:: with SMTP id 60mr9708819otg.179.1639952676455;
 Sun, 19 Dec 2021 14:24:36 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-4-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-4-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 19 Dec 2021 23:24:24 +0100
Message-ID: <CACRpkdZzvnb6++GWxTHgXJP+NfGMSxKzsUtzesBfgea0pDsZUg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 03/13] net: dsa: realtek: rename realtek_smi
 to realtek_priv
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, ALSI@bang-olufsen.dk,
        arinc.unal@arinc9.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 9:15 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> In preparation to adding other interfaces, the private data structure
> was renamed to priv.
>
> Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
