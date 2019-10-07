Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A56CE46E
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfJGN6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:58:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37668 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbfJGN6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:58:41 -0400
Received: by mail-lf1-f68.google.com with SMTP id w67so9363315lff.4;
        Mon, 07 Oct 2019 06:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rS7GIQjyGvU27vvtTIu1FL1u2XlMjMyFmCXQWbGWBVg=;
        b=NENydgIQlpvB6RuFC5ovZYnM4dtqQuYQYexwXF3dPSTZW3I+95T3AIjzPUDduM3Ba3
         p7CtJmuY3uyQKp2lyiGFqlHKSBmmQoVz/Oyz6wwre0MyqFbSURtN2+h9jicVT/HkHYs8
         NwzkvULuYqam67gC8tsDQfm67MvjzLNCLvIO5MNURthoW725RXJ3Sv+wNTzYHHhTmJ0E
         N/YM3ExlQ7YqSJsDkPSzBti6uQuu3eZyyHji1CJ6iJvsI65gilg3yOAZSOLrMsekhHsa
         U+BBKQLhFbJxePOIpvaPWk8lPymFFuduc0ul7qk4wLVv0zB4hLjTOtwOOKVy11sQeNY7
         Lmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rS7GIQjyGvU27vvtTIu1FL1u2XlMjMyFmCXQWbGWBVg=;
        b=oGfDTdBnkFUKQdR3MHqacyaBWIM8JRogRw2TjPgl+TJu9CVmpQxzttJw752dWQjjVn
         FUzJSmnZAveRT8UxnBf3seCLT8bCaHDN5QbtT8tbY0I5HeE8tKOG+2fSRdpgtTPEf9KA
         vVHW2ItqwS2BrWu+sx4fAu1vTfSyEHZvyz6S48+0syu9CHvAupS3n+VXFpx43k5qtaTO
         ecNfLnWgO2aa0ALt8osp4S0CvxcT+FoULnxDfcj986h7JPBpbepavoqH95QXlTjtw76W
         HprQ+QA7g9G8Sv7CdxvenOREl+1rvtHbWM1GfI//ggGEP1R5pRkIerjqJbswVJfZdEoI
         LO9w==
X-Gm-Message-State: APjAAAWfXuaBkC+YfQGKER6KBnw2rDovRkaQMoFc+fM0bW+fiFrkB1jP
        DpAEyX75HKjay6PHizkrPOR9/bxvxK7e0MXP6TqP4w==
X-Google-Smtp-Source: APXvYqzFIdc+285g5LfTP5zuKMDbwk+7sH1aRaSjQVKC1b77Y+7RLc9W7rTJb0+ANcjYQFVVHpKxrnvXygWfFaP5DrE=
X-Received: by 2002:a19:ca07:: with SMTP id a7mr18279722lfg.181.1570456718836;
 Mon, 07 Oct 2019 06:58:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191006184515.23048-1-jcfaracco@gmail.com> <20191007034208-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191007034208-mutt-send-email-mst@kernel.org>
From:   Julio Faracco <jcfaracco@gmail.com>
Date:   Mon, 7 Oct 2019 10:58:27 -0300
Message-ID: <CAENf94Ky4Hrf+CyCTcKE8KXuVPECHc01OKRpKHGgykfeLe-jEg@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 0/2] drivers: net: virtio_net: Implement
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        davem@davemloft.net, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Daiane Mendes <dnmendes76@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em seg, 7 de out de 2019 =C3=A0s 04:43, Michael S. Tsirkin <mst@redhat.com>=
 escreveu:
>
> On Sun, Oct 06, 2019 at 03:45:13PM -0300, jcfaracco@gmail.com wrote:
> > From: Julio Faracco <jcfaracco@gmail.com>
> >
> > Driver virtio_net is not handling error events for TX provided by
> > dev_watchdog. This event is reached when transmission queue is having
> > problems to transmit packets. To enable it, driver should have
> > .ndo_tx_timeout implemented. This serie has two commits:
> >
> > In the past, we implemented a function to recover driver state when thi=
s
> > kind of event happens, but the structure was to complex for virtio_net
> > that moment.
>
> It's more that it was missing a bunch of locks.

Actually, we submitted this patch as a RFC to understand the community
perspective about this missing feature:
Complexity versus performance versus solution.

>
> > Alternativelly, this skeleton should be enough for now.
> >
> > For further details, see thread:
> > https://lkml.org/lkml/2015/6/23/691
> >
> > Patch 1/2:
> >   Add statistic field for TX timeout events.
> >
> > Patch 2/2:
> >   Implement a skeleton function to debug TX timeout events.
> >
> > Julio Faracco (2):
> >   drivers: net: virtio_net: Add tx_timeout stats field
> >   drivers: net: virtio_net: Add tx_timeout function
> >
> >  drivers/net/virtio_net.c | 33 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 32 insertions(+), 1 deletion(-)
> >
> > --
> > 2.21.0
