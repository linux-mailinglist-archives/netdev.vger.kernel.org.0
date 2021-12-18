Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD67479CC7
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234259AbhLRVOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbhLRVOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:14:34 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A403BC061574;
        Sat, 18 Dec 2021 13:14:33 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id 207so9081806ljf.10;
        Sat, 18 Dec 2021 13:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=hBfPEzdnBCIolTV0JC9Xy7BosUZffVOIatmUIf7muRk=;
        b=mj8Y1qjGVeVNpGrpHrq+yiolEP5JKpS78Llfm6+6cOb4hddPJ41w8aUtuFI/BVcYVD
         GMcOCh9EcozjknygR8Dxw5eL4Wont+Ljk5WngDI/xhSwx3A7B4V8wypQ7UYQpRoYG+AY
         FvfHpDsXUrkkMvTW0l4mnr4a+yk+I2826vIl0dK/xO/8RKV3qXUKvpYrpVfJyzPT1EPT
         uqcrkGx0yYj6gzgIYtOXXgAEj7MaEV5Yup/aGZ6wq+98EyB7Zm6H/QKuVvQI4Jhvog3w
         Rc1jPp2VbgRLc6dSrFyPVdJoMNda9A3sLWJgJzokUbozgc7Pe3ndazyVgvQF6XdHyltZ
         q1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=hBfPEzdnBCIolTV0JC9Xy7BosUZffVOIatmUIf7muRk=;
        b=Hllv7YBpNguQGOPe1x6uRj7b2SHC9vCkpTCLwf+9F1CEQqfIaet1H164QLJ5HUTb9T
         PkMFDjZjwDLIADOWh2yBjT8Cpf1XPfSKvW+3anxCvY+8MBVZsNOaozg786G/fiX7KMvH
         8NeONCjRtTGIVD/JEvVOnsjuU978ekhC5IOxNfmaWYSeuoz+iDz3Wzfp6jYrXTgMRSqh
         dSKMJ4SmuDYViDl5bu/u+ldqMCEL8KWJmbDAhu2u1bnJght92gev0IO4klXNcQKhUNdi
         kJ63VI4KfEFqPdUJ798Wt2OGtgLwLPMncDq9dUjdWWjkpJdyxyA54PR9qsndSDngRYWC
         YnUw==
X-Gm-Message-State: AOAM532CPbrDNIjBjZLv1oqYFyiCfn4KSbp603sQbqwcsz3LdiQ6XIQO
        xLN3sEWwCB372m7ig8yV6F4=
X-Google-Smtp-Source: ABdhPJzucJDRxJwDLjAUbGDqu9YkGwYZijg/cBUrGwS6yu/rvwhOI8RwQi4Ibj7sq+pSubmUdTa7Jw==
X-Received: by 2002:a05:651c:b23:: with SMTP id b35mr8488486ljr.286.1639862071960;
        Sat, 18 Dec 2021 13:14:31 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.239])
        by smtp.gmail.com with ESMTPSA id k15sm2092143ljg.123.2021.12.18.13.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Dec 2021 13:14:31 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------cAfV080rMMnQp8FfC7sfnDiX"
Message-ID: <13821c8b-c809-c820-04f0-2eadfdef0296@gmail.com>
Date:   Sun, 19 Dec 2021 00:14:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] KMSAN: uninit-value in asix_mdio_read (2)
Content-Language: en-US
To:     syzbot <syzbot+f44badb06036334e867a@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000021160205d369a962@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <00000000000021160205d369a962@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------cAfV080rMMnQp8FfC7sfnDiX
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/21 14:07, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b0a8b5053e8b kmsan: core: add dependency on DEBUG_KERNEL
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=13a4d133b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
> dashboard link: https://syzkaller.appspot.com/bug?extid=f44badb06036334e867a
> compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149fddcbb00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17baef25b00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
> 

The last unhanded case is asix_read_cmd() == 0. Let's handle it...

#syz test: https://github.com/google/kmsan.git master



With regards,
Pavel Skripkin


--------------cAfV080rMMnQp8FfC7sfnDiX
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9hc2l4X2NvbW1vbi5jIGIvZHJpdmVycy9u
ZXQvdXNiL2FzaXhfY29tbW9uLmMKaW5kZXggNDJiYTRhZjY4MDkwLi5mYjRmNmNlOTQ2NmEg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3VzYi9hc2l4X2NvbW1vbi5jCisrKyBiL2RyaXZl
cnMvbmV0L3VzYi9hc2l4X2NvbW1vbi5jCkBAIC03Nyw3ICs3Nyw3IEBAIHN0YXRpYyBpbnQg
YXNpeF9jaGVja19ob3N0X2VuYWJsZShzdHJ1Y3QgdXNibmV0ICpkZXYsIGludCBpbl9wbSkK
IAkJCQkgICAgMCwgMCwgMSwgJnNtc3IsIGluX3BtKTsKIAkJaWYgKHJldCA9PSAtRU5PREVW
KQogCQkJYnJlYWs7Ci0JCWVsc2UgaWYgKHJldCA8IDApCisJCWVsc2UgaWYgKHJldCA8PSAw
KQogCQkJY29udGludWU7CiAJCWVsc2UgaWYgKHNtc3IgJiBBWF9IT1NUX0VOKQogCQkJYnJl
YWs7Cg==
--------------cAfV080rMMnQp8FfC7sfnDiX--

