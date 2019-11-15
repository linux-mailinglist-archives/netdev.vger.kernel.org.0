Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7391BFD3B2
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfKOEgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbfKOEgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 23:36:22 -0500
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB0B20728;
        Fri, 15 Nov 2019 04:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573792582;
        bh=MPH8c5t2q8tDKDcSoX1E0hyx3wDVfXgAkaiLLTOUl9c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZjZudCcCLdf/g3NWLZHBvRh82XdZnMk7eJ22sQiOlw7tmajsXZKqdyDAe98emgwvY
         6nwvYvjTKteew+ll87yWHPn1c4j5ZnjfE9a9TggXJ8gjIhD6YjphSF3VjD6dWrKRdo
         PqU3R7d1u6K3zfYsHYrO7wKOKe9dIj3mDw5EZhWs=
Received: by mail-qt1-f176.google.com with SMTP id o11so9461494qtr.11;
        Thu, 14 Nov 2019 20:36:22 -0800 (PST)
X-Gm-Message-State: APjAAAWHacYoBURMDpgT1Ex/WdHh0MfqsyI5QQZ3tevfOt11LsE586t1
        AR53wt8OMxh6k+LvdtD5RCORZE4d9bZTW1kCv7I=
X-Google-Smtp-Source: APXvYqyEVfUJcKNuJBdUvGkZuJhPdcKZNhu5NkZlypIG9JAM/A9WKKwqK8Q92zF/Y3Kh5IOc/QoPwWQgkR3S7XljIAA=
X-Received: by 2002:ac8:1858:: with SMTP id n24mr11375005qtk.334.1573792581301;
 Thu, 14 Nov 2019 20:36:21 -0800 (PST)
MIME-Version: 1.0
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk> <20191108130123.6839-47-linux@rasmusvillemoes.dk>
In-Reply-To: <20191108130123.6839-47-linux@rasmusvillemoes.dk>
From:   Timur Tabi <timur@kernel.org>
Date:   Thu, 14 Nov 2019 22:35:43 -0600
X-Gmail-Original-Message-ID: <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
Message-ID: <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
Subject: Re: [PATCH v4 46/47] net: ethernet: freescale: make UCC_GETH
 explicitly depend on PPC32
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 7:04 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
> change anything. In order to allow removing the PPC32 dependency from
> QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
> dependency.

Can you add an explanation why we don't want ucc_geth on non-PowerPC platforms?
