Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9022F899E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbhAOXsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:48:31 -0500
Received: from mail.zx2c4.com ([167.71.246.149]:42938 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbhAOXsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:48:31 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 18:48:30 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1610754068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YslQDcxo7d5X05E+3A1iy2Jx83a4hIAOz++l6yPwS0w=;
        b=UxnwuoCC1SwNi0h3w6jM2MWIXzO6zK22jfWb4/7xyUT+FaWntVmDpJGvAwZnaqB7XUNmHV
        pHOIOHmvGNPQ76fbE/OjBg+sz1cP57xfm/J/9OUVhDlXGZqMpMrI2ERzcxUBMZGwv3rr0q
        QA15ArYxxNCx8aB6McQY3Ux+k3Etnmo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 23b2aba1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 15 Jan 2021 23:41:08 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id w127so6591365ybw.8;
        Fri, 15 Jan 2021 15:41:07 -0800 (PST)
X-Gm-Message-State: AOAM532CZ1ScGPoHHZDkIYi83oRS4e6FUdM0B0QJRDLkyJ8wHtIFBWKL
        oFi84jKKnmFAoagzbPuLceevb/J17XPbesLXp2k=
X-Google-Smtp-Source: ABdhPJxmrDGWGWQRDXblexM2Wy32VQ2QL/9q7VmT4ORFOmz5uIS4Wn0l+QTTteQLZgUPnc6GRixFNRu14JJEWd8kTY4=
X-Received: by 2002:a25:4d7:: with SMTP id 206mr22267493ybe.306.1610754067207;
 Fri, 15 Jan 2021 15:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20210109210056.160597-1-linus@lotz.li> <20210115195353.11483-1-linus@lotz.li>
In-Reply-To: <20210115195353.11483-1-linus@lotz.li>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 16 Jan 2021 00:40:56 +0100
X-Gmail-Original-Message-ID: <CAHmME9rny0bc2JA1_9_A=_3OuPnEvqJyK7UMwsL+x=yTHRoBTQ@mail.gmail.com>
Message-ID: <CAHmME9rny0bc2JA1_9_A=_3OuPnEvqJyK7UMwsL+x=yTHRoBTQ@mail.gmail.com>
Subject: Re: [PATCH v2] wireguard: netlink: add multicast notification for
 peer changes
To:     Linus Lotz <linus@lotz.li>
Cc:     kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Linus,

My email server has been firewalled from vger.kernel.org until today,
so I didn't see the original until this v2 was sent today. My
apologies. I'll review this first thing on Monday.

Jason
