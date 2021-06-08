Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59A439F0DC
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFHI2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 04:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhFHI2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 04:28:01 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3146C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 01:25:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g6so15161940pfq.1
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 01:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=00PfNRcZcqMBfYq8HarCC1wcOInvFG5JKiJ94/fmwE4=;
        b=khshN8CeOIcR9fydB9VBOieeel753hRUU5Z1lxzC65HJwwqUCzOSCeEw/MP7xanU0c
         Rex/PGIE+Opf52At/T/L11iFMU4NZ8cv/OsL5RNhVe0v+5VYjowkjVJvQdCsM4XzdWSQ
         5S08lmKrfGRWeV2JsBDJtlYW5P34WHWpJrOrUvsHy9TH1dtU6lgWq2ZNajiHFiW6+EQ9
         U3Llp+ECgx/Qhdg+v8JQzD/UrPiVpueUFuKQn6EAjvxaoV3B+jVZH72qbwiXxfVJgz08
         /yhj8Vn8mWu9NE417tspWHN1iluQayEVikUhbcdHhM+1p0yPpTz5qZuiXvD7Y8Q59KO1
         jSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=00PfNRcZcqMBfYq8HarCC1wcOInvFG5JKiJ94/fmwE4=;
        b=nZcgxCwyq370yuP0Pa/Jk2qdOeEx8KcVVANFMyBe3QM6KJXj3lEtyVVqHicxuIkHNK
         HLZ7XioDOHFgBXXoDFDeQ2PVUYrnpMF/5HcIqJ+RhWMIHoWifl1I4upVuDo6Phr0Q7k4
         tAKOnDy4b75Pco6Iywgwl7Uokrd9C2A99dv62bx8jSkZbZQPa5IcWc4Zc9qxUNyOU9rZ
         GtI44fNVPr29WqArH6d6QsWovDqNM593Z8jLsRWDc8xo4TEwpYL4TVct4UGRZP0pHvHl
         kvVVYv1JG5tWfa0REJ6071AX61QbVwHqeJ4ahGa9TinQg6iJeuyb0/fSj+PJtI8ecM9v
         8olQ==
X-Gm-Message-State: AOAM533kxSl31CCkd8QZKCsQ61CefTyrqpA/UOHEITBqlXhyAmQYahVu
        Qr27Kn+dV1RVP75slbkYyKQQpwCUOvOMUvf3Fm6TPw==
X-Google-Smtp-Source: ABdhPJwrN6I54ad7/gEccK2yJkwCbDOypZowDEBHw7TqVb8ydJoZjeDKK/L0RP4RGL5oDnwgCS9FZCR67Gm2/unxOXc=
X-Received: by 2002:a63:1906:: with SMTP id z6mr21306328pgl.173.1623140752278;
 Tue, 08 Jun 2021 01:25:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com> <20210608040241.10658-4-ryazanov.s.a@gmail.com>
In-Reply-To: <20210608040241.10658-4-ryazanov.s.a@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 8 Jun 2021 10:35:02 +0200
Message-ID: <CAMZdPi9y=LXp0XVFR_+Wfnxt83tXfMcdR9MjQkcaXpZb7=Le5w@mail.gmail.com>
Subject: Re: [PATCH 03/10] net: wwan: make WWAN_PORT_MAX meaning less surprised
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Jun 2021 at 06:02, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> It is quite unusual when some value can not be equal to a defined range
> max value. Also most subsystems defines FOO_TYPE_MAX as a maximum valid
> value. So turn the WAN_PORT_MAX meaning from the number of supported
> port types to the maximum valid port type.
>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
