Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B70B6DD0
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 22:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbfIRUiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 16:38:19 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45767 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731565AbfIRUiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 16:38:18 -0400
Received: by mail-lj1-f194.google.com with SMTP id q64so1240531ljb.12
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 13:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/8d3VeqPtlNlv0WuasAX2KSDyKn49IVs0wboF0oBdy0=;
        b=KtDqZ/EyRDsRZvNpzA+6SvvsSBqH5Nh4NM9sAvPOPMqLFSdIKv6VGVPEzdkLtNZAc5
         kM8tmtk6cq36Xz59IqtmG+wwA1iHU8rVJEJGHPTdyZ108JDBp/bdumT/tYHsHpcumbxW
         U3sgpWYzExaPl5iCdQG6oWit9ehKQVmEbmVWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/8d3VeqPtlNlv0WuasAX2KSDyKn49IVs0wboF0oBdy0=;
        b=QWYe9WjkNF5VS2KVCZo/Z5Z7bElF0zFJAyMm+Y7pcXtiTPaUraxsv3GGQ4SCr/UnIj
         tMzsogYY8zox3m3YqaYbbH2uDubfrUvJ/fXeSQjylVQ+cZsHRZ5RljEQF2kU+a4x7eib
         /yLL1ihBZWWwGMQBh8tOL0oVXcsBlJRqOQzMAvKwqWF48nCCQ7dQDmgFG4+am0GBwabR
         k35s24tyHTsF6tYSS5uz3nRC4wtU3uWi99V7BFZdJhKPd6SP+1vCc1bF6edjbPLWeyx/
         9yACw6lYKdf4J27W/8CK4zPTuJ4/R046v+dhnF7zOg0rWjYhNRmVM59wzY35vXN8peE4
         DXfQ==
X-Gm-Message-State: APjAAAUhxcedmWh/9ERSCWwNPyOCD+MZu7tqynEk7nQgVTIsK3nkbmlp
        JyjtWxSUWjtxSadglclzZ+fVkHjPVyA=
X-Google-Smtp-Source: APXvYqzJMG0GzFF4NYYUtSo4/R1gR38QueomXLt5EnE6YDihcazMt6lGkwkCCHetzwYtp+YF7nTf3w==
X-Received: by 2002:a2e:309:: with SMTP id 9mr3330788ljd.171.1568839094380;
        Wed, 18 Sep 2019 13:38:14 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id m10sm1165579lfo.69.2019.09.18.13.38.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2019 13:38:13 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id f5so1273024ljg.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 13:38:13 -0700 (PDT)
X-Received: by 2002:a2e:3e07:: with SMTP id l7mr3339346lja.180.1568839093075;
 Wed, 18 Sep 2019 13:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190918.003903.2143222297141990229.davem@davemloft.net>
In-Reply-To: <20190918.003903.2143222297141990229.davem@davemloft.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 18 Sep 2019 13:37:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whSTx4ofABCgWVe_2Kfo3CV6kSkBSRQBR-o5=DefgXnUQ@mail.gmail.com>
Message-ID: <CAHk-=whSTx4ofABCgWVe_2Kfo3CV6kSkBSRQBR-o5=DefgXnUQ@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@davemloft.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hmm. This adds that NET_TC_SKB_EXT config thing, and makes it "default y".

Why?

It's also done in a crazy way:

+       depends on NET_CLS_ACT
+       default y if NET_CLS_ACT

yeah, that's some screwed-up thinking right there. First it depends on
another config variable, and then it defaults to "y" if that variable
is set.

That's all kinds of messed up:

 - we shouldn't "default y" for new features unless those features are
somehow critical (ie typically maybe it was a feature we already had,
but that now grew a config option to configure it _away_)

 - that's a very confused way of saying "default y" (which you
shouldn't say in the first place)

 - there's no explanation for why it should be enabled by default anyway.

I've obviously already pulled this (and only noticed when I was
testing further on my laptop), but please explain or fix.

              Linus
