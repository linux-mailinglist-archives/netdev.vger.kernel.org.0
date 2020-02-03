Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B605D150F47
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgBCSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:22:26 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:57605 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgBCSWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:22:25 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a78bbbd4
        for <netdev@vger.kernel.org>;
        Mon, 3 Feb 2020 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=AHnnn5c7E7ODjw+FcbKupE4aiZI=; b=u8g2um
        rLxYy4mImsKCq+aKDF3ud7UkOG99HCK7GmoAXiaOC4DZWxriigd0OOgM6fe7O8FS
        IoTpcn49bBMHOwxKF0xC320VohFbWue3ZgTupZCGzK2H6wq5N2xUpgUplN2TiQlN
        d8SkM2q8jnfYnPXqrMihTrYByc5AXreqGt/1XD7DlBenzxCkyVM4tgx/o5ck/D3L
        7XKfLNbxzYCb7nldifeFRFptoIc/6rlEoithLWjjXLQt3/9stY9WrgWQjX6RsbCR
        XaOUgS4aEVv6RD+YSkNzLjUJBe2cwmkfH5iFOY7ojvI6BjqMsedjnLT6UM5Ijo+U
        W8DzSo6fgshLftng==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3dc396cf (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 3 Feb 2020 18:21:40 +0000 (UTC)
Received: by mail-oi1-f174.google.com with SMTP id v19so15672164oic.12
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 10:22:23 -0800 (PST)
X-Gm-Message-State: APjAAAX1dmYi2vjIcatpG07bg3j2bDKi2Y2iM25m4aLZx2ST01W5n6YA
        QowajYeGlxSg2GaFQWPJcBJ1kwFGWbfYCeAGNOg=
X-Google-Smtp-Source: APXvYqyXMkbzSjU+9vH9C6oeGFQH5PxWcSpaXOqoIYb0IwBAnyurBABIUZwo+LylIai5E8U7n5q3sn2/cRKFOGxxUdI=
X-Received: by 2002:aca:815:: with SMTP id 21mr272089oii.52.1580754142271;
 Mon, 03 Feb 2020 10:22:22 -0800 (PST)
MIME-Version: 1.0
References: <20200203171951.222257-1-edumazet@google.com> <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
 <efaa70a3-5c71-3cc0-ffe4-e8401d598992@gmail.com> <ba618605-ec50-085d-c854-f65290473c1c@gmail.com>
In-Reply-To: <ba618605-ec50-085d-c854-f65290473c1c@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 3 Feb 2020 19:22:10 +0100
X-Gmail-Original-Message-ID: <CAHmME9oNEjjGA6r_DE4Lcya2G-uEHemS_gKfer9wT8Ov3mN9bg@mail.gmail.com>
Message-ID: <CAHmME9oNEjjGA6r_DE4Lcya2G-uEHemS_gKfer9wT8Ov3mN9bg@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: fix use-after-free in root_remove_peer_lists
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 7:20 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> BTW wireguard@lists.zx2c4.com  seems to be a moderated list...
>
> You might document this.

I'm actually trying to get the spam situation sane enough that I can
unmoderate it, since moderated lists tend to be a hassle for firing
off patches.
