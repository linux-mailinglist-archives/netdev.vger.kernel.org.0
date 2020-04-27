Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCE01BA0BD
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgD0KFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:05:50 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:49249 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgD0KFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 06:05:50 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6248205a
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 09:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=2JHwkePsMb360ZAToLguMdocLSs=; b=zYIF/u
        o4ZQrqM6yDqAOloQP+wrR2HefHb4RD8U6fADTenOE+2n7tnpQGMajyhY+Fcdy/o0
        D9uJyqaBm3D6ggkH54ilDdoHu5uVpQH26ufjnL+ZNhTdpsbeEycNVn3Pu482O44r
        L4w22WyMQu/xjBTrCiEfEvxT7d09FJslQdbDABfohGHb3vLfUrawYLSSUztDCO5O
        LSEi6WGDynyAlWWd7ikEDedQf7kZ0tsR9i0FX9evpIlPQIrEGnBVOq93XVNTlOIE
        3hjb7B/ExuY3VO2xp+fLUI4N/IN2Un9VnzAqfvjljVkOYlevtOHxWcAaTrHjCUxx
        tRkpBRohMu+IqwiQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 57958fe9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 27 Apr 2020 09:54:18 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id z2so18135211iol.11
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 03:05:47 -0700 (PDT)
X-Gm-Message-State: AGi0PubL8lvOxhG+XYCNK0RZ0GQMDK7Mr+BAj7jVwLn6SSBeXB+TufRS
        mRvAppml8R6w0NXG0S1XdpkyLjJQfWiFo2laeBM=
X-Google-Smtp-Source: APiQypIq3CwRX8w+zwCN0MILuaBicwujoYc60cX4LICAB87Hr2Io7MGE9NWOq/WubLbb7PjhTAhatErE2YIqwlKK00Y=
X-Received: by 2002:a02:77c3:: with SMTP id g186mr10054001jac.95.1587981947228;
 Mon, 27 Apr 2020 03:05:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200427011002.320081-1-Jason@zx2c4.com> <87h7x51jjx.fsf@toke.dk>
In-Reply-To: <87h7x51jjx.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 27 Apr 2020 04:05:36 -0600
X-Gmail-Original-Message-ID: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
Message-ID: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
Subject: Re: [PATCH RFC v1] net: xdp: allow for layer 3 packets in generic skb handler
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(2) is infeasible, but there's another option: we can insert a pseudo
ethernet header during the xdp hook for the case of mac_len==0. I'll
play with that and send an RFC.
