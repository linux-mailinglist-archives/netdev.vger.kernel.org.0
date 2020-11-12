Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142C22B00F7
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgKLIPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLIPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:15:06 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9A8C0613D1;
        Thu, 12 Nov 2020 00:15:06 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 34so265537pgp.10;
        Thu, 12 Nov 2020 00:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lzSBKIfQ7GPpk/XHMAOzG2gIUmm0ThvwybixqBcJdVc=;
        b=pDKEGhIOFHS8tr6Pqfo/zYZQkCAev0rZOTu+FzVzCU2vvA2BBb7rlTMO4oLd0PahZS
         QclIUIDlZjtQUx0QnLF9UsPGFnLj98xOxcOvpKktwV2O1IruWtKxyljamhO6pW2G/W0x
         tTmTzAhz3RWTTDCWvSY1WfmColQy5VGD7hsXY8HjwVhhpmIUEXAYeavJAdPO3EPHPu5q
         2BNPMuWYltwXG419ZM64Jpb4lsiK8x7klXWckj13GGwZak1W49nwSwzMsTiHS53LrGs5
         sk7dQ4slZ/4mmlrOiAKy6oKsVshR6uLAKrFRt+hsgkJApUp/6M1RRQz2Lfa7BO1Q/e1h
         9BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lzSBKIfQ7GPpk/XHMAOzG2gIUmm0ThvwybixqBcJdVc=;
        b=rTgHBjs3Opg+A1W9IbuaT5RlqUN7EdH8abW4lqmzCTarjMh215kyNnoVvu3W/wZiBn
         oHp4Zo+saMYFRiCMLFm5vWr/D/K4GWh4AepPjasFodlaBqfXHlCRaEiw3zTBJI4ylC5J
         ZTlyMyvZC74NxFQmFJvmp3/gjSo9WMm4e2sasr+GV2b/eNC83tX9H84nseVuDjl40W8K
         ghZP37d+IQG4ZtfHqQzlJJfsgwhHQMpC4FOkrdJyxCvU8zFTG04yRBBnAdImpLHHcvcP
         aPo4FFniQm8COs6wftGTqPZdAyCHZuWFHU3BfI6wnbzatdArvWmD24CpltVOKQ/2CNHo
         VgCA==
X-Gm-Message-State: AOAM531MIBk1q9/qZXvSQonvBfNg+45a3VmGT1Zh8VH7KtUi1jEOSw2W
        K5N0xo+TbuERzDmDArOxZjPz3kwkLJ8GJeEs6kM=
X-Google-Smtp-Source: ABdhPJyaYUTaaupLGvZokLMr5vzt4g14NVtSANn+FadNW1e47xX6B5HNQ+Ky0by89ooWPbNl/qSwefZlXT0CFqdB4eU=
X-Received: by 2002:a65:52cb:: with SMTP id z11mr24621154pgp.368.1605168906228;
 Thu, 12 Nov 2020 00:15:06 -0800 (PST)
MIME-Version: 1.0
References: <20201111213608.27846-1-xie.he.0141@gmail.com> <7baa879ed48465e7af27d4cbbe41c3e6@dev.tdt.de>
In-Reply-To: <7baa879ed48465e7af27d4cbbe41c3e6@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 12 Nov 2020 00:14:55 -0800
Message-ID: <CAJht_EOU+=nwJ5qqPHozqqvUn9dkrN37WnPk6p3hxdJDhHTAHA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] MAINTAINERS: Add Martin Schiller as a
 maintainer for the X.25 stack
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:06 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> About 1 year ago I was asked by Arnd Bergmann if I would like to become
> the maintainer for the X.25 stack:
>
> https://patchwork.ozlabs.org/project/netdev/patch/20191209151256.2497534-4-arnd@arndb.de/#2320767
>
> Yes, I would agree to be listed as a maintainer.

Thank you!!

> But I still think it is important that we either repair or delete the
> linux-x25 mailing list. The current state that the messages are going
> into nirvana is very unpleasant.

Yes, I agree.

Willem de Bruijn <willemdebruijn.kernel@gmail.com> sent an email to
<postmaster@vger.kernel.org> for this issue on Aug 9th, 2020, but got
no reply.

Maybe we need to ask Jakub or David for help.
