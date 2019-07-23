Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4795F71586
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfGWJwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:52:31 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:35726 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfGWJwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:52:31 -0400
Received: by mail-yw1-f65.google.com with SMTP id g19so16138045ywe.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 02:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+szG/pAJXx+BWcx9bBU5D0iDfWKkgxovNKoPf/NbZsA=;
        b=IKtF+tDkQ4GnzDMg54BC1tVZm0uqvOWZR2Ws182L+3uuqA6y3YMsev7PcnJFoKUnZE
         OB+Q3uNx3Fcz1eYZVu52Hs++UJvZeLh+dLneLjY+qPEnTAOiLI4rXMyfC/5I+uWx9Trs
         k86nLiVWKPTuBKiTVGHSBq0mGFnkdiBMqONEdcF2v2bZWDFlA40TTOa9xsgJzYzF3ZUt
         6SGw/QvIpSitQWYI/6+9teM7BTo1Zi5/sbqojVIIK25q99Gb14ICMO0BX6+7uobnVUQk
         vmOFSWnqsA8wdbBM1gh0crAjYLm1jKSZ+Gq7HSqbwx4x6XNfyC9ersktP3hydXeDW1GT
         5kRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+szG/pAJXx+BWcx9bBU5D0iDfWKkgxovNKoPf/NbZsA=;
        b=nTticHveG/P9g/24eg3VgTeGnREuyzZTAUcJ1PzCl3OJNhXY/vWiYO4FtHhi+Kqpk6
         XtRRSnAmN3MEvJ+ngiHAUAe0rLfdViDZoVCQqQxV9A7jLYbUvVFf/nCYQkKnY3FGeDnc
         pYbrsrzXCEnwiZ2L5v520B6pshm4DA8l1WCGqmpk++JYcJunMb5OfBQXjuHlEF1g/B1L
         i7d22p/JErMwg7TgsyY83rZnghY+4ymH/4bxziAz/1eSYxWp2s/FOt0wbMZg6S4bJJHY
         OJgg6+rGWAolvONCq2fnlLBJM0dZEITMTuFNd39lcT4lD5Fk5ryotF5H6g2vc/rDGwZu
         U3iQ==
X-Gm-Message-State: APjAAAW4ViOOrge5dXgonVZe0ufP1QO14LgTRqYvFx5/XG+bkfky8dlB
        Radi1GStoQ2bxwKCQnLEAWjbnUVic8yMRyOHBsSkpg==
X-Google-Smtp-Source: APXvYqxtPR0XeiJ7kxJkqS4NEA2aFvzwUOu5DvZHh4jq2OPUabL4wN2V7h4vZm1ZVO6VJwz1Drht7oO03YQp0IAbQk0=
X-Received: by 2002:a81:4911:: with SMTP id w17mr43046267ywa.156.1563875549772;
 Tue, 23 Jul 2019 02:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190719063003.10684-1-zenczykowski@gmail.com> <20190722.121107.493176692915633338.davem@davemloft.net>
In-Reply-To: <20190722.121107.493176692915633338.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 23 Jul 2019 17:52:17 +0800
Message-ID: <CANP3RGfG0gcA1a8n550+X1+43=6tpzdv4YG+FX6GQanfWKG7QQ@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6-ndisc: add support for RFC7710 RA Captive Portal Identifier
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Remi NGUYEN VAN <reminv@google.com>, raorn@raorn.name
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Applied to net-next

Any chance we could get this into LTS releases?

I can trivially backport this into Android common kernels - which
would get this into the kernel in time for devices that launch with
Android R, but by getting it into LTS we'd get this support even on
devices that upgrade to Android R (ie. it speeds things up by about 2
years).

Thanks,
Maciej
