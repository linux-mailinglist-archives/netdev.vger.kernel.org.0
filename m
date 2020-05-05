Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F521C6386
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgEEV4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgEEV4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:56:16 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9310DC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 14:56:16 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i19so3638048ioh.12
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 14:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6QCNUI4uAjwww79M1bcuR1zaMsxOZpR0pStHjtQsoJc=;
        b=V9PeneSKTcI7Xr7jzFMcbGXb2YB1GEgHput1sYq81iw46zEzfjJ8J9UVbqOkNPLKcC
         h3IY7dwaTB/ianf7DMYyr8IAntVlIXlrDMVUz7AzdogXr20yQPO8MGdcts9+Q+QYACuT
         83Nn1pSJja4iX34eKrfpmB82tE+VnqPh0OGTX40Uq90jZbShi6S6gnO4HUNyZMmLuOPX
         jxDiiKntpbq/YZ7e3M86dQtlhKInComhu6wtgX2tT7aU1yZ6bugMnoQk/kqdRca8aQfn
         seB1dlpfXFiugiAu2y/fXmV9g56naQ6RkriP0YK8zyPb/Pe73o3fQhIiaJzJhBCyUqIw
         Ip3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6QCNUI4uAjwww79M1bcuR1zaMsxOZpR0pStHjtQsoJc=;
        b=INHA6pDN5FuPgEMps+w2/gHL98DCdkc1Cnpvt+xL+KptgRAQEymS0Z2CcFp5OV9N5c
         FY5myGnXmNAnl+TrwjwqJuuiAK9KiiiYtrwT7aeFZOxqjWxNDrJnoFV5Fctg828H9tKO
         9MRL9Taq6S+mVdlREk4lOjjkv9/CH2pAx7pu0ne7P8roUE6rK6m90xVEiW+cD4ZBtcdy
         aqlrXngZSmTDFcoq3MY/q5GS3jgeFEyf/BN0bXyzF9hXxQdkCKRiMRNOKIRDXizbww2p
         jLgXsOYpnftRSX6rwRwxl+MN7jJRWKji3kqMApkzU2aXsR41y6xZozwiyEW43xPgsgdC
         aaUw==
X-Gm-Message-State: AGi0Pua3MnBfbXe8ZHMMF2njQJqMIkyjggQ1ux1gSIHewEFP7hl2Vczn
        3t5e+4U6Yr4pppsHHGZh9EavTqxB979JAh58la0Adg==
X-Google-Smtp-Source: APiQypJEQoJT3t8V7yngFS3uGekbo9+BGWP29cP3GRdH7RfSN/HW3eQoWV2dnQAAlSOFe6lNNw2A8UNKRzklZZtaBGg=
X-Received: by 2002:a6b:d219:: with SMTP id q25mr5572179iob.202.1588715775539;
 Tue, 05 May 2020 14:56:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200505185723.191944-1-zenczykowski@gmail.com> <20200505.142322.2185521151586528997.davem@davemloft.net>
In-Reply-To: <20200505.142322.2185521151586528997.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 5 May 2020 14:56:03 -0700
Message-ID: <CANP3RGfVbvSRath6Ajd6_xzVrcK1dci=fFLMAGEogrT54fuudw@mail.gmail.com>
Subject: Re: [PATCH] Revert "ipv6: add mtu lock check in __ip6_rt_update_pmtu"
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem Bruijn <willemb@google.com>, lucien.xin@gmail.com,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't buy your argument at all.
There's *lots* of places where internet standards prevent Linux from
doing various things.
Trying to prevent users from shooting themselves in the foot, or
trying to be a good netizen.

If users require their computers to be broken, they can patch and
build their own kernels.

Indeed, the entire point of internet standards is interoperability and
specifying things that must or must not be done.

To quote from https://tools.ietf.org/html/rfc8201

Nodes not implementing Path MTU Discovery must use the IPv6 minimum
   link MTU defined in [RFC8200] as the maximum packet size.

(my comment: ie. 1280)

...

Note that Path MTU Discovery must be performed even in cases where a
   node "thinks" a destination is attached to the same link as itself,
   as it might have a PMTU lower than the link MTU.  In a situation such
   as when a neighboring router acts as proxy [ND] for some destination,
   the destination can appear to be directly connected, but it is in
   fact more than one hop away.

...

When a node receives a Packet Too Big message, it must reduce its
   estimate of the PMTU for the relevant path, based on the value of the
   MTU field in the message.

...

After receiving a Packet Too Big message, a node must attempt to
   avoid eliciting more such messages in the near future.  The node must
   reduce the size of the packets it is sending along the path

...

Because each of these messages (and
   the dropped packets they respond to) consume network resources, nodes
   using Path MTU Discovery must detect decreases in PMTU as fast as
   possible.

--

Furthermore, as we're finally upgrading to 4.9+ kernels, we now have
customers complaining about broken ipv6 pmtud.
This is a userspace visible regression in previously correct behaviour.

And we do have a reason for locking the mtu with the old pre-4.9 behaviour:
So we can change the mtu of the interfaces without it affecting the
mtu of the routes through those interfaces.
