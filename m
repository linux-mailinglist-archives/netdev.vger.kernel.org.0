Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3510314E6C1
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 01:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgAaA6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 19:58:11 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:24975 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbgAaA6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 19:58:11 -0500
Date:   Fri, 31 Jan 2020 00:58:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1580432289;
        bh=9AHEpQkadL1WiIN2xL7g2tbsNTG1cbCHof4RJIGPhiY=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=cRdQRZ5Z/LGP6leTVJWqPl3bfgQCHAALChj6J3kNcY+tIpjnvUYI4+y1YLgzr5q8A
         qhziMHbixI7aLI9CZWcrCw0s5PWfpq4TSQE9wuOQYNKUbBk/NzYOgNI6NDvCOxFlTl
         k0IQyPW7xHEw5Tk06mGX0Ex/Zf0fkNUaZGCPpmeg=
To:     Michal Kubecek <mkubecek@suse.cz>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [RFC] tcp: syncookies: Interesting serious errors when generating and verification cookies
Message-ID: <u7QxWWtde55Y9LShpj3u0U9TJnSF0kslGDC8-MLt7BkKYwuy-YcDvvr3lHGf81Rq6ubcvZu0fQ2OMmyWdaGp08UgovYZYKl3N9BNps0IEho=@protonmail.com>
In-Reply-To: <20200130143217.GB20720@unicorn.suse.cz>
References: <MUBNBny50CpQ5J-18Cx99emdQLBJsj6NiZUx_YT2wTBKSWmpTt1Ly67TGbllsxL-JVA2fCESTWEk72hrLWBukVvZcN2-3DidrDdrLRN9g9M=@protonmail.com>
 <20200130143217.GB20720@unicorn.suse.cz>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HK_RANDOM_REPLYTO shortcircuit=no autolearn=no autolearn_force=no
        version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I don't understand is that even if you yourself concluded that the
> implementation provides correct result for any possible values, you
> still insist on calling it "wrong". Why?

I used to think this was a coincidence, so I always thought it was a "cleve=
r" bug.

> Rather than "coincidence", I would call this optimization based on
> trivial identity

> (a - b % m) % m =3D (a - b) % m
>
> together with the usual trick that if m is a power of two, "% m" is
> equivalent to "& (m - 1)". To put it simply, if we know we are going to
> mask out upper bits eventually, there is no reason to do the same with
> one of the operands before the subtraction.

Thank you, I now know this is an optimization.
