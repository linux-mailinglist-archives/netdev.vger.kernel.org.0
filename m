Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892D41EB0C7
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgFAVOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:14:42 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:40963 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbgFAVOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 17:14:41 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c2df3418
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 20:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=FVgcshJCng7ZMXCI42ZFMPgATQU=; b=d5+0OQ
        tHw2ckb9qxTsoMYI3kRFNFITMiq8isdfC31YDVemccmLqSzsjhsLonDNjIy7w94I
        Fg2Vzr+JT6CxjEmlnYfWSqzai13w4BHBQhNBR48JmmV77o8e34rUI+ga9l+w/Cnr
        Lu5zVZ3Kn/j+KEXYNfN8gLQ706GtYqU0JEzyCCp0VZrDKg74UrNPqdW8aqeSrlMM
        qtJnKj6mTfqvqw0svxzY58Iip85SZIlZp6F3IhUGiCyhsLiMZJ+L9jzpJgkmun9J
        vlwbUlvFYB+w/zfINmJyjr3N354CV38fjr0cp4LMCouXAj1tnOt9t3M6uyfDd8Ms
        wHL8k9I/iqmBberg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9ecb50da (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 1 Jun 2020 20:58:34 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id h3so10806983ilh.13
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 14:14:39 -0700 (PDT)
X-Gm-Message-State: AOAM530DGiEhUTwphWvvZqou2Jqa0vjPntJb0aOJMorq7o7s4VrudILn
        Kf7S9L0aVs2ikNb3a9Dr/ebwnoV8Kn9LuevYcpY=
X-Google-Smtp-Source: ABdhPJwY1lSyHqfNiKusY3Ix5eskZaRKJ7Mqh28Ltnp6lEqcvqIAgFnAtol/OtEL3ft/aLdt6212xnJsjKjBsjlEUkI=
X-Received: by 2002:a92:8ddd:: with SMTP id w90mr21340443ill.207.1591046078749;
 Mon, 01 Jun 2020 14:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200601062946.160954-1-Jason@zx2c4.com> <20200601.110044.945252928135960732.davem@davemloft.net>
 <CAHmME9pJB_Ts0+RBD=JqNBg-sfZMU+OtCCAtODBx61naZO3fqQ@mail.gmail.com> <20200601211307.qj27qx5rnjxdm3zi@lion.mk-sys.cz>
In-Reply-To: <20200601211307.qj27qx5rnjxdm3zi@lion.mk-sys.cz>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 1 Jun 2020 15:14:27 -0600
X-Gmail-Original-Message-ID: <CAHmME9rVjnRSNxw4kwRS_3TfPB_rt4h88SqYEmkuihJQHwi_rw@mail.gmail.com>
Message-ID: <CAHmME9rVjnRSNxw4kwRS_3TfPB_rt4h88SqYEmkuihJQHwi_rw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/1] wireguard column reformatting for end of cycle
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 3:13 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> It's not only about stable. The code has been backported e.g. into SLE15
> SP2 and openSUSE Leap 15.2 kernels which which are deep in RC phase so
> that we would face the choice between backporting this huge patch in
> a maintenance update and keeping to stumble over it in most of future
> backports (for years). Neither is very appealing (to put it mildly).
> I have no idea how many other distributions would be affected or for how
> long but I doubt we are the only ones.

Understood, no problem at all.
