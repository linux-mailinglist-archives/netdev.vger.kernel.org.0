Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34606125E9B
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 11:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLSKLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 05:11:42 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51689 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbfLSKLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 05:11:42 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7c18075f;
        Thu, 19 Dec 2019 09:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=+EdDtiusBwNIJrxz56VcIGbZpNs=; b=FTuevp
        CztgWnh124N9Nn3nz/BVzwzUHNgy5G22x2l9dsc6Au8NjG0G/XAXJmW9Aild7858
        FCgbdU65oy9CJo0Wr5LWyGsMbLFrIb5hDtqYX9FboOSYo1gPNYyreD8g4Ewi1Sx9
        4e7f8j1kTMFDExICtYQGTesVWUNcbx/bN8VXo5YY1bZHlHNglpO8JziPBmwD/U1l
        O/0XN+6JPNlxWRjpsur9b63wGPwFf0X6gimzQiNdkbi0Sf9+ADCTUNCkGrOA7eLz
        f77tyGLO616udTw2H7ep35ncg6ZacdY+YF2g/mcdaSuAaqvJAaOp+2lPUfiCEmt8
        zL2dcZXsfqHm4Dug==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dd99e7a2 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Dec 2019 09:14:59 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id p8so6572188oth.10;
        Thu, 19 Dec 2019 02:11:40 -0800 (PST)
X-Gm-Message-State: APjAAAV6D4ucSOd5mAmYW6rYqgrTc8qd00vkT8hnXsKwiCZNGdgbGQZh
        QCrKT/TROCq/595oUogKBUqt4fHuQ5/J+x4RhmI=
X-Google-Smtp-Source: APXvYqy2bEz5l9a5Y3gzHzSKOIotYH8t0rUMP0jMFV0ZfqMV3QiV4R0uH2n6J7gtc1dXxQj1YkvTw5upDEDByrmGe8g=
X-Received: by 2002:a05:6830:184:: with SMTP id q4mr8104517ota.52.1576750300137;
 Thu, 19 Dec 2019 02:11:40 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com> <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
In-Reply-To: <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 19 Dec 2019 11:11:28 +0100
X-Gmail-Original-Message-ID: <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
Message-ID: <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: WireGuard secure network tunnel
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:07 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Dec 19, 2019 at 10:35 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> That's exciting about syzcaller having at it with WireGuard. Is there
> some place where I can "see" it fuzzing WireGuard, or do I just wait
> for the bug reports to come rolling in?

Ahh, found it: https://storage.googleapis.com/syzkaller/cover/ci-upstream-net-kasan-gce.html
Looks like we're at 1% and counting. :)
