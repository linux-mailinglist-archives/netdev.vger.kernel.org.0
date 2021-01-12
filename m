Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048642F26B9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 04:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbhALDc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 22:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbhALDcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 22:32:54 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B3FC061575
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 19:32:13 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m25so1163373lfc.11
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 19:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cm5edgh6SZA7skpoEo3WIzg0WCdlk8Ha7BTVolfHsJs=;
        b=siVI7kfRhXJUpHMbND5BYo8Lxmj2pm5IYgz57gGX76UlE5OCNcisCme8Q6wVBbNFQb
         pLXR44dDm1Cw44IHCubEswf1U7IZ9K0+W6qU3hqaeuzVP2SHb2oAQh3VqTgMLgaNJht3
         +nbH1DD+dH7RuMhW3MUU1+zLeacZKvfbq961DOpFxdiBPcsTjqfNeKndPi5D9k3Re/E5
         VzRMqMV3c5T1aKaq/bv45jLBsIOahhJibBl84T93F1wrVfTNSIX/iAS2PfhbbCJmuV5d
         oIeKGKvGrNWm+eiN/P7EPl6dv8v6n1D29jGrc8kejPTCb3e+tvQanY6GqO3+X/l56s0d
         jW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cm5edgh6SZA7skpoEo3WIzg0WCdlk8Ha7BTVolfHsJs=;
        b=COJDxP7QLa7FtH67pMEIXPmqhC9Anjr4mAjLfvOCcLudNAvCI++NZPpKOR7xwyVQrp
         RbeyVTlbt4gsQcmB8T2Tu1CQ375I/YujmnlnLdS4LRDPsJkSKxfm3MGVfxptgZ8+pK7Q
         X0z7CNfsw4RdAaYKaAfj2MD2B0YFdArsD8Vu0TxUCOR7ICk0k64dOzal/CxgSn95yEtV
         mWvkwRecyj7RWplJ1nTL5RSGCuLrm3ZTiIC/iKH+Aduyg4pMWWnaVmuNqAGoWwPEI3aP
         g0pwDqw0g/O4UBarAkME5nb6VzItRH+0/SSM64tpRUOI4ZuqTOWf3sm+PcJYV2H9ZXCQ
         Eu8Q==
X-Gm-Message-State: AOAM530GyPa17qDlIWo6ISiKS9+Pnz3O0XUHJ+yVcvALnD9lR9XtF7Up
        8GagNu30ZrqEs7elQBEyHA92kBNnj28inE6m32A=
X-Google-Smtp-Source: ABdhPJxgO2vfcdGBW/2P3/pbuMG58014o0fhXzlks81d1/sfhdKvxylRfJraBgTidGCf4g13OxiM3wgGHraotNNN/ps=
X-Received: by 2002:ac2:5979:: with SMTP id h25mr1153641lfp.57.1610422331736;
 Mon, 11 Jan 2021 19:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20210111052759.2144758-1-kuba@kernel.org> <20210111052759.2144758-2-kuba@kernel.org>
 <CAMXMK6uWAmghRw-G3P=315iZyQO+HaELUB_hQ1E6rVLGfVG6Hw@mail.gmail.com> <20210111183914.2b18ac82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111183914.2b18ac82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Mon, 11 Jan 2021 19:31:59 -0800
Message-ID: <CAMXMK6s7gczTtmLiKn2E6s766aQqdVBbv=O7wAAJN5zEzg6SEw@mail.gmail.com>
Subject: Re: [PATCH net 1/9] MAINTAINERS: altx: move Jay Cliburn to CREDITS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, corbet@lwn.net,
        Jay Cliburn <jcliburn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 6:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 10 Jan 2021 21:36:24 -0800 Chris Snook wrote:
> > On Sun, Jan 10, 2021 at 9:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Jay was not active in recent years and does not have plans
> > > to return to work on ATLX drivers.
> > >
> > > Subsystem ATLX ETHERNET DRIVERS
> > >   Changes 20 / 116 (17%)
> > >   Last activity: 2020-02-24
> > >   Jay Cliburn <jcliburn@gmail.com>:
> > >   Chris Snook <chris.snook@gmail.com>:
> > >     Tags ea973742140b 2020-02-24 00:00:00 1
> > >   Top reviewers:
> > >     [4]: andrew@lunn.ch
> > >     [2]: kuba@kernel.org
> > >     [2]: o.rempel@pengutronix.de
> > >   INACTIVE MAINTAINER Jay Cliburn <jcliburn@gmail.com>
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >
> > I'm overdue to be moved to CREDITS as well. I never had alx hardware,
> > I no longer have atl1c or atl1e hardware, and I haven't powered on my
> > atl1 or atl2 hardware in years.
>
> Your call, obviously, but having someone familiar with the code and the
> hardware look at the patches and provide Ack or Review tags is in
> itself very, very helpful. There is no requirement to actually test any
> of the changes or develop new features.

In that case, I'm happy to keep reviewing them.

Acked-by: Chris Snook <chris.snook@gmail.com>
