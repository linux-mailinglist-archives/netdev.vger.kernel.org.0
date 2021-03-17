Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912B133EFB3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCQLiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhCQLiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:38:00 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D855C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:38:00 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id u3so40161462ybk.6
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6IYAqtf/GuQy4I9i5Gkv7icNrqTsQ1XwKALFq9KoyrI=;
        b=m0BPuaH4mAottICM6KZG7M+GwUz7LDgGdBjnWGgvRCWM7eLRdre10Gmhrw4F5sRhFJ
         5nGpHj5/tT8hSaNN6HAVg57UeKc1GSB6Tl9CkcvFEEMBZjdpJvTR4u6JJ7wFIE2sbH5+
         Wx7QkcL4OODk1TWkZmv8NxoZSWiSh+sQHTU4FctGeCOlLAGug6JNdDhFUwDmQfj6ToyV
         Im+haxghaFTItOayX/m6RX2J/sFn5fKxtqwpqJ0e34JHIEB2iXnrPj3LaBCvy2iCdNYV
         nQkqoQOI0N5PnwjBk4dJJdwR7kv8KTWut0HocgyUk0eKauxiutZnhnJOVJn8760uzgOq
         ImTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6IYAqtf/GuQy4I9i5Gkv7icNrqTsQ1XwKALFq9KoyrI=;
        b=I1XGccgqATndyBkCC3VaCSb5EIdV6UtlbQqIfYQhhKKGpY6zijttJZ5NiEbqQQtRfH
         lBKiIJhz2OvWgbNVDdAvxF4asT0mC4h2vHCPHYugpDVVcEhKHGjppIQdZ81XYtbYqLNO
         oDEvK21DYFAYyUJewsoO53D3n0Wp0A3U56pEE9urkXwuz3GzL4SM+QB562teY/ZJwuvf
         TXRNmyJxIZg2bld3o92/8e//rhGdc+prbYsM8OJe03IWh5MMvi5Eh40Xi2K0VIannJOB
         LWp2dlWfpkWqL/3h6AHdUrszzHjOfdBQytEJLdB1gFZoLL60/XCHzwGhPtu4cBm9ZZsv
         vM5w==
X-Gm-Message-State: AOAM5325sgTj6nybpRT/c5rXiT3IqeF+0Cre2QtlO9MuLIdazlqSawNT
        7wsCmAdvD+CelrwAkN7+vdFWhbUOislHlW/cG1c=
X-Google-Smtp-Source: ABdhPJyo877zcZTeLhGCs0cB93l1aLa8rdtWziCsetJrx0KB5fwrMPsIgmzj3N4sqo0me5oT57AlqEUpXrJgjdUUHRk=
X-Received: by 2002:a25:d642:: with SMTP id n63mr3631263ybg.390.1615981079527;
 Wed, 17 Mar 2021 04:37:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAAfyv37z0ny=JGsRrVwkzoOd3RNb_j-rQii65a0e2+KMt-YM3A@mail.gmail.com>
 <YFHpGmgOV/O+6lTZ@Red>
In-Reply-To: <YFHpGmgOV/O+6lTZ@Red>
From:   Belisko Marek <marek.belisko@gmail.com>
Date:   Wed, 17 Mar 2021 12:37:48 +0100
Message-ID: <CAAfyv37JbPtV3uUzc0ZUHNMCh+_y1XOH-auGWYJSzy4id07VCw@mail.gmail.com>
Subject: Re: set mtu size broken for dwmac-sun8i
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 12:33 PM Corentin Labbe
<clabbe.montjoie@gmail.com> wrote:
>
> Le Wed, Mar 17, 2021 at 10:19:26AM +0100, Belisko Marek a =C3=A9crit :
> > Hi,
> >
> > I'm hunting an issue when setting mtu failed for dwmac-sun8i driver.
> > Basically adding more debug shows that in stmmac_change_mtu
> > tx_fifo_size is 0 and in this case EINVAL is reported. Isaw there was
> > fix for similar driver dwmac-sunxi driver by:
> > 806fd188ce2a4f8b587e83e73c478e6484fbfa55
> >
> > IIRC dwmac-sun8i should get tx and rx fifo size from dma but seems
> > it's not the case. I'm using 5.4 kernel LTS release. Any ideas?
> >
> > Thanks and BR,
> >
> > marek
> >
>
> Hello
>
> Could you provide exact command line you tried to change mtu ?
> Along with all MTU values you tried.
I tried with ifconfig eth0 down && ifconfig eth0 mtu 1400 return:
ifconfig: SIOCSIFMTU: Invalid argument

btw board is orange-pi-pc-plus
>
> Thanks
> Regards

BR,

marek
