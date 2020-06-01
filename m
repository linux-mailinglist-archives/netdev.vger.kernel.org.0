Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F3E1EB1B1
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgFAW17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:27:59 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57525 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgFAW16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 18:27:58 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0ce7a44f
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 22:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=PKIaTJ99jKq0Wr71JDkLG3FOc24=; b=Oy247X
        uGrbZ74gxiWUni8fFanoD90DSCZH9JZFsRpoH7yaaGLMmsr3UV1ah5f9E//vtyDI
        3FPEQipWCHvUkr4a450rCkgE/7MV+3m3Oft1hcrsN/fjPQzd/zrcwgCT85MLKcqa
        VRRw/lGRW++gWxdidG/59T6ppfLykWfHHTwMPaT2cvO85Qaydo9mt99LFP6PVWG0
        5ZUKD0fxDjwBwYoINCZV8u8mYKDxcF940bKbGpoQnGyI6EiNhAtDdPrLTjMMPANu
        ZTwrktkqy87AZpelXBR28ZWIyZRZUweMEML+FcjrAJ7XicAzZFP+UHFK6j0NsZP4
        QPBtQjejoO6go47A==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e984af9a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 22:11:52 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id 9so10961929ilg.12
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 15:27:57 -0700 (PDT)
X-Gm-Message-State: AOAM533f0eRldS7rREn9eRdZ/OkF2LQXmCqanmNm0FiIQf8B0gyznKxc
        iu0rxdghPFVsmqt4JuuhqjmNRBzHGw1FFbAeqdY=
X-Google-Smtp-Source: ABdhPJwHQRSUsnU5g7Tb78l3OTbwG6g/f+uokyQ2/LPEN6e5dQ7VtoSg9+WuGpthAWjnyRGP0ylIh6JKRNCzZbtyJJI=
X-Received: by 2002:a05:6e02:130e:: with SMTP id g14mr23711407ilr.38.1591050476629;
 Mon, 01 Jun 2020 15:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200601.110044.945252928135960732.davem@davemloft.net>
 <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com>
 <20200601211307.qj27qx5rnjxdm3zi@lion.mk-sys.cz> <20200601.144008.2114976182852633034.davem@davemloft.net>
In-Reply-To: <20200601.144008.2114976182852633034.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 1 Jun 2020 16:27:45 -0600
X-Gmail-Original-Message-ID: <CAHmME9orPzKJf7LhbJpU6HXki7twbPV0Z7m8vpVwBO6vCU7kaw@mail.gmail.com>
Message-ID: <CAHmME9orPzKJf7LhbJpU6HXki7twbPV0Z7m8vpVwBO6vCU7kaw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of cycle
To:     David Miller <davem@davemloft.net>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 3:40 PM David Miller <davem@davemloft.net> wrote:
>
> From: Michal Kubecek <mkubecek@suse.cz>
> Date: Mon, 1 Jun 2020 23:13:07 +0200
>
> > On Mon, Jun 01, 2020 at 01:33:46PM -0600, Jason A. Donenfeld wrote:
> >> This possibility had occurred to me too, which is why I mentioned the
> >> project being sufficiently young that this can work out. It's not
> >> actually in any LTS yet, which means at the worst, this will apply
> >> temporarily for 5.6,
> >
> > It's not only about stable. The code has been backported e.g. into SLE15
> > SP2 and openSUSE Leap 15.2 kernels which which are deep in RC phase so
> > that we would face the choice between backporting this huge patch in
> > a maintenance update and keeping to stumble over it in most of future
> > backports (for years). Neither is very appealing (to put it mildly).
> > I have no idea how many other distributions would be affected or for how
> > long but I doubt we are the only ones.
>
> And google and Facebook and twitter and Amazon and whatever else major
> infrastructure provider decides to pull Wireguard into their tree.
>
> Jason, I bet you're pretty happy about the uptake of Wireguard but
> that popularity and distribution has consequences.  Small things have
> huge ramifications for developers all over the place who now have to
> keep up with your work and do backports of your fixes.

You're right, a fair point. Folks are indeed backporting this with
their own processes. I'm maintaining a 5.4.y backport, but it'd be
foolish to assume that's the only one.

Jason
