Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1831510F7
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgBCUZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:25:13 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:55261 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgBCUZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 15:25:13 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7c191163;
        Mon, 3 Feb 2020 20:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=n10J7S+AOGTmDvM08pKinjPzH+0=; b=DuoZOv
        fR92bsTay3DgDOpyf0jXMaY67OD/cq3PkTJsMgqmYYrRJAgj2mN3wP49Ih0fiES/
        NhfVzZ0IfvN2mDPgjZfk7u6SJAQFXT1ZhUCimNcFizc67vzVAXWJ28g0M8XtdN5J
        P1uX0ECF1KNbBNOXE6qxomHpDiyb7dpyMVqFTLZTzgc33I812Kn8kDU4sT+tRFbf
        Kz6ZAHqLDRQmDzERNaGBQhPUbvSaB41Yg9vM7W8QW2UCHojPLogWzQeXXBAYXb9R
        fyuxZcqmAwEoiBiSD66TymAXZCbpkUy7Q26TK1VMXY6B/+moAA7PzhIPZ2IO5omI
        oM5cWSGf26RTTO+A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1eabf98a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 3 Feb 2020 20:24:28 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id v19so16058976oic.12;
        Mon, 03 Feb 2020 12:25:10 -0800 (PST)
X-Gm-Message-State: APjAAAULu979rK9aICEkt+mAM3MGzjViTm3yuGdHVW2DvTInnw6+JFSY
        7yfz0mVDT8nKVDsxHVxY0Yx5MN6VfOItEA8gSgE=
X-Google-Smtp-Source: APXvYqwstmCx6NDTmNXty+nOFS0LtivgqcnUmYH0S+j4J1xxMHQIG+1MPE5dF5AETVuOds6I/s5hkfLHzX8gXHxYqUA=
X-Received: by 2002:a05:6808:4cc:: with SMTP id a12mr588645oie.115.1580761509902;
 Mon, 03 Feb 2020 12:25:09 -0800 (PST)
MIME-Version: 1.0
References: <000000000000f8bfe8059db01519@google.com>
In-Reply-To: <000000000000f8bfe8059db01519@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 3 Feb 2020 21:24:57 +0100
X-Gmail-Original-Message-ID: <CAHmME9oVLWp_JcWzOm_OWqFOs+C=wj1kp7g=UnHANmrKHRbUsw@mail.gmail.com>
Message-ID: <CAHmME9oVLWp_JcWzOm_OWqFOs+C=wj1kp7g=UnHANmrKHRbUsw@mail.gmail.com>
Subject: Re: possible deadlock in wg_noise_handshake_create_initiation
To:     syzbot <syzbot+d5bc560aaa1cedefffd5@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 3, 2020 at 7:28 PM syzbot
<syzbot+d5bc560aaa1cedefffd5@syzkaller.appspotmail.com> wrote:
> syzbot found the following crash on:

Thanks, fixing.

Jason
