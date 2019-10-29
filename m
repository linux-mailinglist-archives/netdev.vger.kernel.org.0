Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D69BE7E51
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfJ2B7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:59:46 -0400
Received: from pb-smtp2.pobox.com ([64.147.108.71]:56526 "EHLO
        pb-smtp2.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfJ2B7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 21:59:45 -0400
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id A38792D032
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 21:59:40 -0400 (EDT)
        (envelope-from njs@pobox.com)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=sasl; bh=lzc4t/wVbQJnuuwi9sKStJdgYuw=; b=qWxg+a
        JvtPThFHwOwqTEnCwC/zGiL2jreUSixGYkbZ9bUVCEYkghK4TzH2fmw8P1fZ40Ad
        xc+uULg3ETx96FYe+ck7s+EWHCLwQDtU4Bf7kQuQBe9It8UbVYqwbjWu3oBMFy2H
        8i04wYuhp37O7UFROb8GI3BtLWtXUbL8etiwQ=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; q=dns; s=sasl; b=lqTYVI5qLvCjR4/c8cSn8BDsbfDJi8Fa
        obn6grRIEaXa31Y7KOi+CCAJLU3BD3QCmTluO/8PV5MQCCRk2pumd28fqFrvejxS
        E+07ptg3iVNd5Eg73KLXUT8WRSgM4+Fyby163CUnjCaSLEbYsJ4ysAux7SDyjYGi
        romxHkmrB4k=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id 9AE902D030
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 21:59:40 -0400 (EDT)
        (envelope-from njs@pobox.com)
Received: from mail-ot1-f44.google.com (unknown [209.85.210.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id 266452D02F
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 21:59:40 -0400 (EDT)
        (envelope-from njs@pobox.com)
Received: by mail-ot1-f44.google.com with SMTP id 41so8409777oti.12
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 18:59:40 -0700 (PDT)
X-Gm-Message-State: APjAAAXW0mRL7CulcMYpxox/2PKVfsck/Q0iyWzHjyBOmzNcGZ93aa49
        2bq8XIDafLWVeD8tGXQRJd4Qym5edOrS8X6SS+3ePw==
X-Google-Smtp-Source: APXvYqxZalpWVs3uAcD+PUYGI4t833gmLW/mPK+BU+cPMf3tojycJlue1SC+cTnyMJRwSGcqPrZU/NvH/gDQAtDWa04=
X-Received: by 2002:a9d:738a:: with SMTP id j10mr8579602otk.289.1572314379528;
 Mon, 28 Oct 2019 18:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191028081107.38b73eb1@hermes.lan> <a863e2a4-8d31-c8d8-2f85-7fe3fa30104f@gmail.com>
In-Reply-To: <a863e2a4-8d31-c8d8-2f85-7fe3fa30104f@gmail.com>
From:   Nathaniel Smith <njs@pobox.com>
Date:   Mon, 28 Oct 2019 18:59:28 -0700
X-Gmail-Original-Message-ID: <CAPJVwB=PGn-V04kCHmoq0bk0fMUH9aS9-cE6j+cQ24-gtgfBWg@mail.gmail.com>
Message-ID: <CAPJVwB=PGn-V04kCHmoq0bk0fMUH9aS9-cE6j+cQ24-gtgfBWg@mail.gmail.com>
Subject: Re: Fw: [Bug 205339] New: epoll can fail to report a socket readable
 after enabling SO_OOBINLINE
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Pobox-Relay-ID: C48F0086-F9EF-11E9-B60F-D1361DBA3BAF-09433513!pb-smtp2.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 2:22 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > -- Scenario 4: OOB data arrives -> register -> toggle SO_OOBINLINE=True --
> > select() says: sock is readable
> > epoll says: sock is NOT readable
> > reality: read succeeded
> >
>
> I really wonder how much energy we should put in maintaining this archaic thing.
>
> We do not have a single packetdrill test at Google using URG stuff.

Yeah, URG is pretty useless. I didn't find this because I was trying
to use URG; I found it because I was trying to avoid having to think
about URG :-).

The problem with URG is that it lets untrusted remote peers trivially
trigger weird socket semantics that most userspace developers haven't
tested or thought about at all. Once I started looking around I found
lots of prominent apps that react badly to receiving URG, plus there's
a history of nasty stuff like [1]. SO_OOBINLINE is interesting because
it makes the URG semantics more similar to the regular semantics that
apps are expecting, and empirically it would have mitigated lots of
these bugs. So I started wondering whether we should enable
SO_OOBINLINE unconditionally in the networking library I maintain, as
a general hardening measure, and while writing tests for that I
stumbled on this bug.

This specific bug is pretty unimportant... in practice you'd always
enable SO_OOBINLINE when a socket is created, not after you're already
polling it, so whatever. For the larger question about maintaining the
archaic URG code: having *some* kind of predictable semantics is
important! Though for me, even SO_OOBINLINE is fancier than I really
want; I'd be just as happy if the way to get boring, predictable
semantics was a simple SO_DISABLEOOBENTIRELY. I can also see an
argument for offering a system-level config option to disable URG
handling globally, and encouraging distros to turn it on...

-n

[1] https://sandstorm.io/news/2015-04-08-osx-security-bug

-- 
Nathaniel J. Smith -- https://vorpus.org
