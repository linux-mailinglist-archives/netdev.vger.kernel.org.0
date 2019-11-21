Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC053105581
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfKUP0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:26:46 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:53357 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfKUP0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 10:26:46 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8153aecb;
        Thu, 21 Nov 2019 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=9rO4z5sa5cW/KppMdFyBM7L655M=; b=TjKXwA
        JIypICoKtVIfvC1uTqy8daQ00OJ9H5PiBR9zcuuFSG7u1kR4cBCEXHyvUbKDwgGw
        s5iHyQv+/ADmqU5NKFV60z2ABEHhm83h4WRRQh1hA7sm7mM8MFpKvs3KIC/Vt3Ei
        MG+YkSv5KlM8aBPUFZuExYEfpn+MMViw76ygzsanGv7u2BpoF2HSTArnbY/vo5rA
        NT8JHTBDZss46jcH+/Br3nnFpK5MTAr2FkVVsw27ZJngF6DZpEP3lBU+9CYHk40i
        dhhIQt9P3dA5BbpYP1kUSC8a/PgURS61I9xGk2eX7HyjB8Mqu446q0c1zSfi0MOW
        C4MSMadnTHtLu2fQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bf8a06f6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 21 Nov 2019 14:33:38 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id r24so3215243otk.12;
        Thu, 21 Nov 2019 07:26:43 -0800 (PST)
X-Gm-Message-State: APjAAAUR72CHIfOJFQO73Rg4tLzvxUlOseJo/bxeKgtCCQLNWc7DsSqp
        B4k+j0J6LDQcl5ZReZhRhNITHEDvQcNMwDg83Rw=
X-Google-Smtp-Source: APXvYqy+OOPTbY4wI1lR6UWfKKpza4kME2TCJyAP6+JIFH/G2GBY8787MbunIO+puAfzydaD9ym9gJwPeXC9rAw7Oaw=
X-Received: by 2002:a9d:4788:: with SMTP id b8mr6990169otf.120.1574350002882;
 Thu, 21 Nov 2019 07:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20191120203538.199367-1-Jason@zx2c4.com> <877e3t8qv7.fsf@toke.dk>
 <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com> <CANiq72mGPmMVBCmOMc_xJbKuOvbmmPAotGx67nSVQrYmXd2x3A@mail.gmail.com>
In-Reply-To: <CANiq72mGPmMVBCmOMc_xJbKuOvbmmPAotGx67nSVQrYmXd2x3A@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 21 Nov 2019 16:26:31 +0100
X-Gmail-Original-Message-ID: <CAHmME9q6UHweyNBmAOanJB=BBSyjydwurJin2eJd9R+nAe2YYQ@mail.gmail.com>
Message-ID: <CAHmME9q6UHweyNBmAOanJB=BBSyjydwurJin2eJd9R+nAe2YYQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 3:44 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> Any reason for the .clang-format in drivers/? If yes, it would be nice
> to state it in the comment of the file.

It's a total accident in porting my scripts from the older Zinc-based
patchset to this newer Frankenzinc-based one. It won't be there in the
next submission and is already gone from
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/linux.git/commit/?h=wireguard

Jason
