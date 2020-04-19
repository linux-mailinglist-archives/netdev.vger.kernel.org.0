Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844C91AF8DD
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgDSJF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 05:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSJF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 05:05:58 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7A6C061A0C;
        Sun, 19 Apr 2020 02:05:57 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e17so3636378ybq.0;
        Sun, 19 Apr 2020 02:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FD01YorMYVTZiQnYiKnJ80JyviEzcASthTcRsKe5I14=;
        b=FmKGLhVZ4DGB8jkfKU3Iz2wIFKGRJ5RrhZEUdCqhy5Tw2rSCS4pjsaP3MwpfZAz3I9
         bhj1LM1o938G7Klc5IDKGJNo1E8FqLSMyQAG6gf69grWKfToF4usdCLlEb11g+UcEfZt
         CrH7x9xAUIMqI0z51hwAKt8LWA9ZTBiKtjjuyEjDjlAkdvvrcTZrmTzEcyvRSVqmFOyS
         s6EAzmKZE4kURBxNopBE1JbNDJ1Ec5bXEXE+Br3SYgN6SnFUEsBjgtbVc1mmsZGyyB7V
         NvIRDyLcbuXjKugM58ueaSnge+k3e9f9OL0XzD9VxSFDqtU02yL3+ePBNTuPLvstkAk4
         hqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FD01YorMYVTZiQnYiKnJ80JyviEzcASthTcRsKe5I14=;
        b=MFtM/2cRmDeYPmfc0TUmvhcwF8puNtpz/NsztRsCZReTcpwbz7AHFva5C7/zsz7a7p
         XO1EwRsihZW8Ep0lELIgeIiJWkfGiz+qwsi0uRvrD+5RAGAelJqnP9S6QAiKHzou/W6B
         MdcbBzp96Ol1eurimxiVqcuELnCOyA+Ov/I5IeDsaJ5F9bKXfLJRDwGVZI361sLrd3Oo
         iaOCjL09mEoR/KNvhfwZ6v+lTbLPwyl/7LLT9X5ksd9fPY5iUOgXn0d0DZaqMLZspacm
         jKz607CfLBhBlr+wyc1skz+tiaxmvSBXQT1NkIQT2IG3KIgZP0E6FK6hcSiUL9ChV3bv
         FpMg==
X-Gm-Message-State: AGi0PubPQqgwj3dia1CqsLbelEumcT0XEf+OtbCv+d56Of0tCvOqBUPq
        Fv5i5E4c7qCl/fwtw2i0eMHVnczphrozAsscq1Y4cfAE
X-Google-Smtp-Source: APiQypKM10LjWSZNLeUzjklh/pveekQFVs3Wl7r2SqgyCwtfzkq09oM/1yNVol5k2rfz4ibi0s9eZZ5m10e+J+Zrchg=
X-Received: by 2002:a25:23d4:: with SMTP id j203mr841916ybj.97.1587287157194;
 Sun, 19 Apr 2020 02:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200415114226.13103-1-sashal@kernel.org> <20200415114226.13103-6-sashal@kernel.org>
 <CAJ3xEMjKozXW1h8Dwv96VzCegOsyvyyeZ4hapWzwStirLGnAqg@mail.gmail.com> <20200418212044.GE1809@sasha-vm>
In-Reply-To: <20200418212044.GE1809@sasha-vm>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 19 Apr 2020 12:05:45 +0300
Message-ID: <CAJ3xEMjuhjfvEs57HaA=tQH_ccTqEdRkmJ7gFUH-3bvK3BTvtw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 006/106] net/mlx5e: Enforce setting of a
 single FEC mode
To:     Sasha Levin <sashal@kernel.org>
Cc:     Stable <stable@vger.kernel.org>, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 12:20 AM Sasha Levin <sashal@kernel.org> wrote:
> On Sat, Apr 18, 2020 at 10:52:59PM +0300, Or Gerlitz wrote:
> >On Thu, Apr 16, 2020 at 2:56 AM Sasha Levin <sashal@kernel.org> wrote:
> >> From: Aya Levin <ayal@mellanox.com>
> >> [ Upstream commit 4bd9d5070b92da012f2715cf8e4859acb78b8f35 ]
> >>
> >> Ethtool command allow setting of several FEC modes in a single set
> >> command. The driver can only set a single FEC mode at a time. With this
> >> patch driver will reply not-supported on setting several FEC modes.
> >>
> >> Signed-off-by: Aya Levin <ayal@mellanox.com>
> >> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >>  drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
> >
> >Haven't we agreed that drivers/net/ethernet/mellanox/mlx5 is not
> >subject to autosel anymore?!
>
> On Thu, Apr 16, 2020 at 09:08:06PM +0000, Saeed Mahameed wrote:
> >Please don't opt mlx5 out just yet ;-), i need to do some more research
> >and make up my mind..
>
> It would be awesome if the Mellanox folks could agree between
> themselves whether they want it or not and let us know which option they
> pick.

My reply did had a question mark. I missed remembering this response
from Saeed over the other thread and remembered your "no problem opting
it out" response.

> Again, I really don't care whether mlx5 is opted out or not, I'm not
> going to argue with anyone if you want to opt out, I just want to know
> whether you're out or not :)

let us continue on the other thread, I think whole netdev (net + drivers)
should be opted out by default and only on those folders you get ack
from the subsystem maintainer and driver maintainer you can opt in.
