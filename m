Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44EBC924
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 15:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406344AbfIXNuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 09:50:15 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:55843 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfIXNuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 09:50:15 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4888bebe;
        Tue, 24 Sep 2019 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=V5uxGnCTUhNAnRktrNC2jwCDhAo=; b=WxfFkC
        SvZ6oQtgWyhpdQFEC27viS5d0Znh1e9eyEEdZ602mZSdouvvR8Jn48nv7FhYsmKe
        R5IN5yq0h/QLYHUM476O76xzY1fVBpZpiFdPUw0zq+qXV6+5hvj3LqL0e+IPypte
        CNy95ik+sdX2+ESFM4HuMfVsnlSpoaeTNsCZwm77dqMjDpIbb76rCvJmFvmKrkYU
        mneGxRg8U48I9t1NvcYieCDo37ebLcDbOgK+AX5fxy0iJ5YWJntdc5xMUizEjg2X
        PsNIWN5SrVMfMSXzzUiqhkagu/Iec37l4kh9sU1gkhjg3e9d1KmrB56ltI9RZ/Qb
        mQIDZX2AUcA7m5hg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ad92a611 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Sep 2019 13:04:35 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id y39so1512645ota.7;
        Tue, 24 Sep 2019 06:50:12 -0700 (PDT)
X-Gm-Message-State: APjAAAXr8cwE1t1EL2V2Rs9iuxVMeKgAWDeko3cUDRcgORqnBSoeb8uK
        zKdInBsdloWil+PuEwUIl1VRjFvEs8QYw0RymEE=
X-Google-Smtp-Source: APXvYqxhjyyZtdQ1jPkoocQ2RBFHJqNTYK/8voSdw785snav/9xtFXMs5ge5NC5iVBpBRGv+e0gGcRBgltcy/qptyRU=
X-Received: by 2002:a05:6830:20cd:: with SMTP id z13mr1933474otq.243.1569333011999;
 Tue, 24 Sep 2019 06:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190924073615.31704-1-Jason@zx2c4.com> <20190924.145257.2013712373872209531.davem@davemloft.net>
 <CAHmME9oqRg9L+wdhOra=UO3ypuy9N82DHVrbDJDgLpxSmS-rHQ@mail.gmail.com> <20190924.153008.1663682877890370513.davem@davemloft.net>
In-Reply-To: <20190924.153008.1663682877890370513.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 24 Sep 2019 15:49:59 +0200
X-Gmail-Original-Message-ID: <CAHmME9oL7qP=pGnXRT1hmPmRpQ1_0r__vHkuBe-LbfgZTEMV_g@mail.gmail.com>
Message-ID: <CAHmME9oL7qP=pGnXRT1hmPmRpQ1_0r__vHkuBe-LbfgZTEMV_g@mail.gmail.com>
Subject: Re: [PATCH] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 3:30 PM David Miller <davem@davemloft.net> wrote
> I'm asking you to make a non-wireguard test that triggers the problem.
Oh, gotcha. No problem.

>
> Or would you like a situation you're interested in to break from time
> to time.
My test suite should catch it in the future now that it's there, so I'm fine.

> Jason, please don't be difficult about this and write a proper test
> case just like I would ask anyone else fixing bugs like this to write.
I'm not being difficult. I just thought you didn't see what the test
case I linked to actually was. I have no qualms about reimplementing
it with the dummy interface, for a v2 of this patch. Coming your way
shortly.
