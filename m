Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2010A13059D
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 04:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgAEDEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 22:04:47 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:43619 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726240AbgAEDEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jan 2020 22:04:46 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 413eefc3
        for <netdev@vger.kernel.org>;
        Sun, 5 Jan 2020 02:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=WI53CESV+dc4Q98zpVOaBXpe4yo=; b=SFtUWt
        LLRCiQkviVy3+ME9GQ3fDPQAHRrqpx8btvhuMsxHMZSN6wd/SWK9gMG6fjSgeQ2D
        kf0GFbhE3c0ZyflzJtOzGWgcTE4JchaM8Wu+AMyGoJKrRpBVudbON0p3Jd2XALYG
        NRI86Ef95LsScMmT0vksLIAGIxG271N3xU0/EQq/V4JR7yFmWhDXEHFxmxYLj8b9
        l9TAakDB+f4697wMREWMaGxnyQlm1ufO6FQKfTXiAH7HcUq/z+MQmOO5DC6ozq9Q
        AGb4kt43tUfcNH6NbYl0KvYYy3nmxsimTiqUYJvEQPfspHgcCKNsV6oe+SWIycDn
        JpGMUjzTJNMD0vgg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b13a5fde (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sun, 5 Jan 2020 02:05:55 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id k16so62066709otb.2
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 19:04:44 -0800 (PST)
X-Gm-Message-State: APjAAAX829jCkuR4ggp0FFhjLSyUJOwcs+Taplg8+zYXnUdAHmL49Ozj
        UXDE9QVIp3VwltWC6MPlTXMjX42o8o7l2FlyASA=
X-Google-Smtp-Source: APXvYqzYXN3olJ9F2qmRdZfgBn+gWZ7HLxo+Qm8poX7Z1BAbDBSx67RsHWdqN0gbT5Wae74f+VdQ734sGUGasXMed1I=
X-Received: by 2002:a9d:1e88:: with SMTP id n8mr109859069otn.369.1578193484125;
 Sat, 04 Jan 2020 19:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20200102164751.416922-1-Jason@zx2c4.com>
In-Reply-To: <20200102164751.416922-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 4 Jan 2020 22:04:33 -0500
X-Gmail-Original-Message-ID: <CAHmME9pMPPmuHz-Cxi9e1UDThwQey8n1e3QJ2ic1ZxzjJZPP5Q@mail.gmail.com>
Message-ID: <CAHmME9pMPPmuHz-Cxi9e1UDThwQey8n1e3QJ2ic1ZxzjJZPP5Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] WireGuard bug fixes and cleanups
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I think this might have gotten lost in the post-New Years onslaught of
patches that have been coming your way in the last few days. So, just
a friendly poke.

Jason
