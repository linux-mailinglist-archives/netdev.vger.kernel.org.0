Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8022EFD481
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKOFoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:44:34 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:47023 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfKOFoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:44:34 -0500
Received: by mail-oi1-f195.google.com with SMTP id n14so7591450oie.13;
        Thu, 14 Nov 2019 21:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/3uU+eY5BtMdRnLX2UOVt6iN0KOpw7AZZyEPeGfnQp4=;
        b=DvBPhJ5hNSIVVXhVsiHAcd2uqINIue4JNpb0Fhkx5aNxr6mGgdBqnUzxyBfXhz+Vvb
         quSerUMzMVeUUcdunWCoyQb6rYyQ7WzsjBWQwg8ymO+Lt75x2mmbZ22SGT0GEFXaa5n2
         xM/MoXMhhY/+UxziqCVhSaEk0TN668cWRFagcL4uWFUGVawa+5en/ONLOp6DnYWaOmyK
         qfGfGCzulmqVAoIMCRXUmHk/rqD4PA9monIx1VScdx6K2FBx6T/+CbyVlS4GmDOuEbHJ
         H0nxb7TUj9xwL/hiVtrYhOKDBMANV8OCYZisu5qqgDgoQzx6mdKgdIb0YxkOkkNCHnQ7
         RBkw==
X-Gm-Message-State: APjAAAV/cvjHy5O5OMcKf1K5cVflbJiWIdDWgzu4hQP4gCWgDUCY0s7C
        lAlnlbaHY3czkJ1r39LBnz0Ydbw8
X-Google-Smtp-Source: APXvYqyP7mM2B2YHL3qUad4bdKQIAVScMQ4K9L2oTb5HfN5+3hzlEknxB5ROuK9a6JDUu5IYtDyg4w==
X-Received: by 2002:aca:ef8b:: with SMTP id n133mr6184321oih.11.1573796673163;
        Thu, 14 Nov 2019 21:44:33 -0800 (PST)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com. [209.85.167.180])
        by smtp.gmail.com with ESMTPSA id u1sm2568821otk.33.2019.11.14.21.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 21:44:32 -0800 (PST)
Received: by mail-oi1-f180.google.com with SMTP id m193so7650728oig.0;
        Thu, 14 Nov 2019 21:44:32 -0800 (PST)
X-Received: by 2002:a54:451a:: with SMTP id l26mr6675985oil.154.1573796672412;
 Thu, 14 Nov 2019 21:44:32 -0800 (PST)
MIME-Version: 1.0
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
 <20191108130123.6839-47-linux@rasmusvillemoes.dk> <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
In-Reply-To: <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Thu, 14 Nov 2019 23:44:21 -0600
X-Gmail-Original-Message-ID: <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
Message-ID: <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
Subject: Re: [PATCH v4 46/47] net: ethernet: freescale: make UCC_GETH
 explicitly depend on PPC32
To:     Timur Tabi <timur@kernel.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Qiang Zhao <qiang.zhao@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 10:37 PM Timur Tabi <timur@kernel.org> wrote:
>
> On Fri, Nov 8, 2019 at 7:04 AM Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
> >
> > Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
> > change anything. In order to allow removing the PPC32 dependency from
> > QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
> > dependency.
>
> Can you add an explanation why we don't want ucc_geth on non-PowerPC platforms?

I think it is because the QE Ethernet was never integrated in any
non-PowerPC SoC and most likely will not be in the future.  We
probably can make it compile for other architectures for general code
quality but it is not a priority.

Regards,
Leo
