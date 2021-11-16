Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327F8453454
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbhKPOiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237483AbhKPOiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:38:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B50363213;
        Tue, 16 Nov 2021 14:35:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="PCkrc5GM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1637073352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aVvWJd39MYeyeXC45cmKJyUS0lCWpXog0spU1EM+noY=;
        b=PCkrc5GMc1qWLgfXCw1ItycqGQOu16H22orWQS0UumpbaOR014iB/b+YmU9zD6xZiBxnrg
        v6ryvudDe58myVnXCPEBKtwE8M+HN5gAREkBmdEdxC9sK7GgUGER9wHF3pbluSchxBTpv/
        by8XlzzBi+BVw5iqYt65+fYkWG1IvWw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ddbeaefd (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 16 Nov 2021 14:35:52 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id v7so58222856ybq.0;
        Tue, 16 Nov 2021 06:35:52 -0800 (PST)
X-Gm-Message-State: AOAM53204i6fU7997TW3T1nsIC3AkK7tXE1niHJpIUX9mrfQ6OWMex0H
        1/PvgmoB9Tbq6FRT3hjKK+XE076PPzE3ouVixOk=
X-Google-Smtp-Source: ABdhPJyK8fZhJKugHashqCWYgbrM0WK5WAdHzetQ2HIizA6DknS8jNCPsJEtvdY389KpOzysx5m3hyDpAUEIf1bTVzU=
X-Received: by 2002:a5b:783:: with SMTP id b3mr8299681ybq.328.1637073351028;
 Tue, 16 Nov 2021 06:35:51 -0800 (PST)
MIME-Version: 1.0
References: <20211116081359.975655-1-liuhangbin@gmail.com>
In-Reply-To: <20211116081359.975655-1-liuhangbin@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 16 Nov 2021 15:35:40 +0100
X-Gmail-Original-Message-ID: <CAHmME9pNFe7grqhW7=YQgRq10g4K5bqVuJrq0HonEVNbQSRuYg@mail.gmail.com>
Message-ID: <CAHmME9pNFe7grqhW7=YQgRq10g4K5bqVuJrq0HonEVNbQSRuYg@mail.gmail.com>
Subject: Re: [PATCH wireguard] wireguard: selftests: refactor the test structure
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

I don't know how interested in this I am. Splitting things into two
files means more confusing maintenance, and categorizing sections
strictly into functions means there's more overhead when adding tests
(e.g. "where do they fit?"), because the categories you've chosen are
fairly broad, rather than being functions for each specific test. I'd
be more amenable to something _entirely_ granular, because that'd be
consistent, or what we have now, which is just linear. Full
granularity, though, has its own downsides, of increased clutter.
Alternatively, if you'd like to add some comments around the different
areas to better document what's happening, perhaps that'd accomplish
the same thing as this patch.

Jason
