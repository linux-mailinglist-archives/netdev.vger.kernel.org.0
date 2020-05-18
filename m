Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24711D8808
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgERTOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgERTOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:14:40 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA39CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 12:14:39 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y85so5241890oie.11
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 12:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y3ebyzb9bg00IZ18QhDqa9e3YFIlts3auBakKof7kfs=;
        b=sZ9zPdzZeIuq/kVBU9mIbnLymKrf2J+SjAsxvidGrsugrRzEk/oKEiQroSVxeAfkNH
         TYMSlepWCgDHxJn9sLVww4fZ0PHJMH1MsZWPX//T3JKHrijTdV3OP1IDBmkPvgWyuOAP
         1PR3nPXBM4XgkDhCzX8E8aJilXa+KlL+2NGH11RN6vVjuW8j0ZIkALZOYjO4tIxAswJn
         lY9UheoHK4vfclwCCTi9KA4F07+HEA1PyGhlykh44NbOBm4AyWd4QfnTfol+ucSNcu5P
         +GXXPziAB3C0Jt2HC9IM24bEB/01/bBD5Sx7/v44+enwT5fn8Ctuo49IGUYuGYI9L9bG
         619A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y3ebyzb9bg00IZ18QhDqa9e3YFIlts3auBakKof7kfs=;
        b=Vr+wuqh782HGs89Dn3YCkIyT8kMQAx/2o6BMhcgVtYEUT9xmTW1NOJk9i3wJCIkNYv
         5rYm4KogvCMzT8aI3dknfD1EiFYCUta61PSY5aYbYVCwGMdBkkJC1+5+7P7wsM6F+VNw
         1EdAPDDtBEReYxQIQ6hGIMOxJP3ltnZ/OATqeDy2zD7I9wrPx0eV6FmDFajKDTZ+r1PM
         od0dOwmyNQs5bBG06bJ/L8GZoCLkB4K3oOCOpsdFkbCyR9ly+19e4S2/U8d9h5JrMDOZ
         g0OIuSfE3egO4WQI/aBcihX/VAyC9l1pNSMwc/32FjL1kb+OZAXd7gUJRdw1s2rZj1gM
         tboQ==
X-Gm-Message-State: AOAM5322KEJn9p+UOim/R/xMf5Cvbz3yZFxZhDWWJi5rtyiBSGP0oTUB
        fB+Rt30Pdn46KYdSt6mWDnENfXrwDidNKJ49Oy41iY3Q
X-Google-Smtp-Source: ABdhPJxzmNspJNM8Y8/dCURyZBJdmhTx7KEfynoD56dSL1rNkVC9xjVUnZY68lvJVW3fcibZDMPeddUN2yZMcWEXbUI=
X-Received: by 2002:aca:d496:: with SMTP id l144mr660599oig.72.1589829279181;
 Mon, 18 May 2020 12:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200518083239.GA28855@qmqm.qmqm.pl>
In-Reply-To: <20200518083239.GA28855@qmqm.qmqm.pl>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 18 May 2020 12:14:28 -0700
Message-ID: <CAM_iQpVgo3Few=uxVtHw4if30EveXzJ+j7jwiB0RZhT_HfiNPg@mail.gmail.com>
Subject: Re: net: netdev_sync_lower_features()
To:     =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Jarod Wilson <jarod@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 1:32 AM Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.=
qmqm.pl> wrote:
>
> Hi!
>
> I just saw commit dd912306ff008 ("net: fix a potential recursive
> NETDEV_FEAT_CHANGE") landing in Linux master. The problem with it (or
> rather: with the netdev_sync_lower_features() function) is that
> netdev_update_features() is allowed to change more than one feature
> at a time, including force-enabling other feature than one that is
> being disabled. I think that a better fix would be to trigger
> notification only after all features are updated (outside of the loop).

Sounds reasonable. But I don't think this problem is introduced by
my commit, my commit merely skips the notification for the
failure.

> When you consider net effect of the function, the loop's added value
> is only to print debug messages. Other than that it's equivalent to:
>
> lower->wanted_features &=3D ~upper_disables;
> netdev_update_features(lower);
>
> The problem of spurious notification can be fixed in
> __netdev_update_features() by saving dev->features at the start and
> only return -1 when it really changed.

Please send a patch.

Thanks.
