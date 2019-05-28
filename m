Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8712CBB4
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfE1QUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:20:33 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:44857 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfE1QUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:20:32 -0400
Received: by mail-lj1-f176.google.com with SMTP id e13so18258866ljl.11
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 09:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QUBK0smUCEmAkLWUMviQy/y2cmdfwPzjFuxose3v4AE=;
        b=dBNkFZox4YGYP39v4i5KOnXfaDqG/PeuWLXwWzvAsiXhrlOU5TiCNZNDa8eTdpQxEK
         HS3lqyfSgd2JSEL58AmD2dbwJUopAIjgScyPwjupax/Pj9aNTZSnws6IYsUN/KuKLpSx
         N2em3KEvPI+8cIxh5kHes03ZljvzFeQewHOCblH+dL63atF/ZoSacj/U52qXUJo+69OG
         vfigDgDclbgwH1a2djUCodOOw+nU7lfqbNJTxeM7RmYUw5qO6MsIR8iA0EDk60Vc06lj
         cEwUvCu/praxchEwMsoPozfxiOSE1Mxo3UQ1P/gLhaZapb9IwZuzG9n1deMb2q7X0EIC
         W5lw==
X-Gm-Message-State: APjAAAXgUH5hZgZQsAWkEK4dTnV2pvzLl7zqZ9DZxoedI38Q4wXUinXO
        dT8YoHkkgvhtB8th+eeapE1EEw==
X-Google-Smtp-Source: APXvYqzVt9C1LB4cbm3+M9Bns2HZLMoJ07zH/TtGTIfCyJBNb8EkZUGWbTwvimZvSCMSIkjZGg8MlA==
X-Received: by 2002:a2e:5c08:: with SMTP id q8mr15090148ljb.113.1559060430904;
        Tue, 28 May 2019 09:20:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id p6sm2994117lfo.55.2019.05.28.09.20.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 09:20:30 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 881DE18031E; Tue, 28 May 2019 18:20:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Akshat Kakkar <akshat.1984@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, lartc <lartc@vger.kernel.org>,
        cake@lists.bufferbloat.net
Subject: Re: Cake not doing rate limiting in a way it is expected to do
In-Reply-To: <CAA5aLPhrDbqJqfVVBWfCZ6TK0ZFMOSsqxK9DS9D1cd4GZJ0ctw@mail.gmail.com>
References: <CAA5aLPgz2Pzi5qNZkHwtN=fEXEwRpCQYFUkEzRWkdT39+YNWFA@mail.gmail.com> <875zpvvsar.fsf@toke.dk> <CAA5aLPhrDbqJqfVVBWfCZ6TK0ZFMOSsqxK9DS9D1cd4GZJ0ctw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 May 2019 18:20:29 +0200
Message-ID: <87muj6tusy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Akshat Kakkar <akshat.1984@gmail.com> writes:

> It's a controlled lab setup. Users connected to eno2 and server on eno1.
> Link speed 1Gbps.
> No ingress shaping.
> Simple http download.
>
> I am having multiple rates requirement for multiple user groups, which
> I am controlling using various classes and thus using htb.

Well, CAKE has its own built-in shaper, so it hasn't seen much testing
with HTB as a parent. Theoretically it *should* work, though, as long as
CAKE is running in unlimited mode.

Could you please share your full config, and the output of `tc -s qdisc`
after a run?

Thanks,

-Toke
