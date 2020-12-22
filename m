Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787062E0C3C
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgLVO4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgLVO4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:56:34 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5D3C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:55:53 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c7so13161232edv.6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9h/KkQElsEegosmLGqsjOSdH+E/iRHvuJ77iESbkm0Y=;
        b=rlBg+BhWjCazSLcAq96vRwli0L908Uspz5iI4bi4NZDIJk+0WRAbP3aX2QDBwxC/HY
         Wj1BsGKGXUXkkLwWK9xqArHM58WCRAajSj9y2TmqEIvHhDs3Uy9/zf1ZpWLZzoiYnguy
         UqPBFRz4FOfJgU5AkaHyVxp2Dre7f84yFirRXBe8/SE6lBWXsSfikGb2XwSo/1Zv+p7s
         Hkcp18ifujSW0GoToj3eL7HH4+D2nSsUGPKgU+Avr9J/WHARGeTfno0wgvnboFfFVAj9
         QkUj7aWSPm7OF0IYNrKUxMETJzcnogecUtbRH8kzK7ubzBgoWdUMXWYYBDTOvqogbOm0
         831A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9h/KkQElsEegosmLGqsjOSdH+E/iRHvuJ77iESbkm0Y=;
        b=fxeIAvxZCDfo853t5JX72KdwfmecB/2VCw7nC1HNeOLLHtGxyWtIrdMaYGF7Z9sjSp
         FSKVI4snre/fY9u6jKRtuYxkOLtLgwK0E/PGnNiJ2Ui5jImMv1jx1Xslw2qgfc+r/xEF
         oNKkFWKdEMo9KywSfi7yS8Kz1LczBLRv505vQ8y72h3e7Vq12TPECwuD+JNHUbqyAB9d
         kYtCPADn6hF9DFWZ1N1WBOPBnQbULkiHV41I0sff6w1U7f1FoQueeR4GliepXj5Dd7CJ
         S9gi72gwOrsgdiCP2XiTsL1D1YmWE0ohzhz1t6Cy/Ww2PzRdGzGuTc4RwK+ALj/5ae9J
         vtog==
X-Gm-Message-State: AOAM531S/enhaGR7B0PFZbqcilMcn3XyTFp6Scw/V5Ybtvy+RCGA3thR
        slbutEVhrI8kWsL+w4wP7z0q4afbG+dbsq+t0nU=
X-Google-Smtp-Source: ABdhPJzLd5mtMkOuyR9r0OJC2gmF2s73c6KZ6jVcCz2Cnkgk+3XUFkEwgsSwOr90Bd3fzX/gND6vFjtwONeDE6Ry3RI=
X-Received: by 2002:aa7:c603:: with SMTP id h3mr16081321edq.254.1608648952783;
 Tue, 22 Dec 2020 06:55:52 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-13-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-13-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 09:55:17 -0500
Message-ID: <CAF=yD-L3pL7gX7=M0GiAnBB_2AB=4JDwGRmQ4o9ZzBp-WSE5fw@mail.gmail.com>
Subject: Re: [PATCH 12/12 v2 RFC] skbuff: rename sock_zerocopy_* to msg_zerocopy_*
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> At Willem's suggestion, rename the sock_zerocopy_* functions
> so that they match the MSG_ZEROCOPY flag, which makes it clear
> they are specific to this zerocopy implementation.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>
