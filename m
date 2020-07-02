Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7484B21210E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgGBKT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:19:56 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56468 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgGBKTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:19:47 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by linux.microsoft.com (Postfix) with ESMTPSA id 128C620B4908;
        Thu,  2 Jul 2020 03:19:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 128C620B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1593685187;
        bh=ZRE3Um+pEieTG0xQ4M5QSrkZwd1HX5P5rC1a9rLmt4A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dipNb7Qug4jfFGzFeCOIJdI906FopJ4r6tVy0NmSvYNC6do8vxuIl9zHemP36ptex
         DHOULzJARvCOhemO/1rss/0su3tNnNHQZn+KigcFdzsuIxFbacmTUFVBlYGXG7RcLx
         UFTF/wcQ6hhN8drPU4vmUbItLpgSw2xoW6EIJGoc=
Received: by mail-qk1-f169.google.com with SMTP id j80so25096026qke.0;
        Thu, 02 Jul 2020 03:19:46 -0700 (PDT)
X-Gm-Message-State: AOAM530DmTbrh/9HI+BGz4BgIvsnJiyVAfR2FdF7XI0E8WeJ8VYra2di
        7Ecqpk//jTrYYqir/HbyPwHZ3sBWfzKcLLrxavg=
X-Google-Smtp-Source: ABdhPJyaL79MLwN6jUkDoThwrjYPK6m7eQDH1idLQ3gYMwTdWyls/DyyzNAD9JwVI3tIxKdJauDvpIXwdo3vImtofhs=
X-Received: by 2002:a37:9a96:: with SMTP id c144mr29319278qke.207.1593685185937;
 Thu, 02 Jul 2020 03:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200630180930.87506-1-mcroce@linux.microsoft.com>
 <20200630180930.87506-4-mcroce@linux.microsoft.com> <20200702080819.GA499364@apalos.home>
 <20200702090956.GA7682@ranger.igk.intel.com>
In-Reply-To: <20200702090956.GA7682@ranger.igk.intel.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Thu, 2 Jul 2020 12:19:10 +0200
X-Gmail-Original-Message-ID: <CAFnufp1yB8Cqxy=KqWan+E0ukiEDwq=aSWt1hYFYXdqoW9P4Sg@mail.gmail.com>
Message-ID: <CAFnufp1yB8Cqxy=KqWan+E0ukiEDwq=aSWt1hYFYXdqoW9P4Sg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] mvpp2: add basic XDP support
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 11:14 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
> > > +   if (port->dev->mtu > ETH_DATA_LEN) {
> > > +           netdev_err(port->dev, "Jumbo frames are not supported by XDP, current MTU %d.\n",
> > > +                      port->dev->mtu);
> >
> > ditto
>
> Here I agree and for every other netdev_err within mvpp2_xdp_setup().
>

Nice idea, I'll add extack error reporting where possible.

-- 
per aspera ad upstream
