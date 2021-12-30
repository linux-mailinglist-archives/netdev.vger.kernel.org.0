Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28382482063
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 22:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242155AbhL3VQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 16:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbhL3VQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 16:16:30 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA7DC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 13:16:29 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id x6so3954558lfa.5
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 13:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BHJndwMMxR0TkItjvoEvbP+JN6AdaC0FvsaEpR7Zur8=;
        b=jNo59XDFaII/EnzBhQFQ2eVqB3FIRgHEpYTeQR13gf57V8Xv81z4JxC0Vvq+iucoFv
         OuEl8mqJTpkxOmXb42DwykwsGk47hLerC1HLncwfokH97cJkfVKum7BK/VLD1/wbjW1Y
         3X3i8DbYLN1urUOzNd/xhoBm65iV4pr9TITXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHJndwMMxR0TkItjvoEvbP+JN6AdaC0FvsaEpR7Zur8=;
        b=lziCUM6tRxSHMRf4MeCzkEyy/I9T/dYKoaj4VM0qBVc5w3B68+eWO4Z1MylRJQLg8g
         QzeecV0a0Mt0iGhvebgvicnkAEdB0NYaJCP5CnmggqebBOi5tbKtr0RwVeAW3eO6luvW
         PG2cWS8SyNQUXNIMT0l7dZ7zIstu/TbMYXHKKnzenGEFJWP5+oF3OJjt/Y3y2fL/0eBo
         pPdHcQ1NqUhBaXxeGdonzYNpOdNVdCSLDPtTwXEDDYIrnpL2LXHbEHlL0v5v4RpIRE7w
         3KFeja0W34sqZ0PQbq6iaUcElDkc5AuHB0eFTfyeEJENjSQjwqe+9nsYppbuBV0hs8fx
         W/dQ==
X-Gm-Message-State: AOAM532EwkkLYI3+7RCbqx99f4aeppppuzD9hvRVVV2JC5etin4ngkmR
        iiny9QVxxG6SRXOs1c4J7jqTB8/g7qrG3aBJdsw2tZVHr9SFbw==
X-Google-Smtp-Source: ABdhPJwKkPkvtsLxdolT+yjxtZmNxg+qQMatgKEspstNs/XcvsB6D4cHU5Epyv6SVjvYgMhOejG9CoRGbozpcUsipFQ=
X-Received: by 2002:a05:6512:2292:: with SMTP id f18mr26375861lfu.51.1640898988156;
 Thu, 30 Dec 2021 13:16:28 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-9-dmichail@fungible.com> <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com>
In-Reply-To: <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 13:16:16 -0800
Message-ID: <CAOkoqZny2=S-+sApOn7pKroYoB8HVS3XCCFRmB5DB7k3B0THjA@mail.gmail.com>
Subject: Re: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and MAINTAINERS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:54 PM Dimitris Michailidis
<d.michailidis@fungible.com> wrote:
>
> On Thu, Dec 30, 2021 at 9:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 30 Dec 2021 08:39:09 -0800 Dimitris Michailidis wrote:
> > > Hook up the new driver to configuration and build.
> > >
> > > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> >
> > New drivers must build cleanly with W=1 C=1. This one doesn't build at all:
> >
> > drivers/net/ethernet/fungible/funeth/funeth.h:10:10: fatal error: fun_dev.h: No such file or directory
> >    10 | #include "fun_dev.h"
> >       |          ^~~~~~~~~~~
>
> Hmm, I don't get this error. What I run is
>
> make W=1 C=1 drivers/net/ethernet/fungible/
>
> and it goes through. Tried it also on net-next as of a few minutes ago.
> Any ideas what may be different?

Never mind, I see what happened. One of the patches is bad and is not
adding the paths correctly.

Do let me know if I should address the header 'static const' warnings
from -Wunused-const-variable.

>
> I do get a number of warnings because there are constants in one of
> the headers defined
> as 'static const' and they get flagged when a .c doesn't use them.
> This looks like a tool
> shortcoming to me. Do you want me to try to redo them as defines or enum?
