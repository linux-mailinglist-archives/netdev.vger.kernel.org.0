Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E49D5A575
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfF1Two (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:52:44 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37951 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfF1Two (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:52:44 -0400
Received: by mail-yw1-f66.google.com with SMTP id k125so4642404ywe.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Zbt8t4OGSrBZUltQdpu2XfV4/PLifVH/Z0A6OyR0+8=;
        b=bsREio19ZCYiktCkIASujl5tmzasz+I6GbX0QwjW1yWtrPHLtl8F72d/tP0OV718gu
         JhET9fkvZSnspuxgKrEOx/1kP1SYjQ7fj0fI/XoKoCGyk+qi6UDO6wRJo+hNRVYcyyxq
         0JSncshPTPt64doooXNY6ma4/ktV2ka0yVK/xrE/yAYCFGpIjfHmlQ4eCCCi+mJeJUsc
         8W4PI0vw66GNUmY1JGqXcSHa2CiCZHRkpxNiXv/kZ+fttkGp4qs1PP7G81iPFP6xFUG7
         n7G6MbZWqfBIpLiVXTzG3xd/E7GrLNqS/TCCUVcsr/qDjsGrDy2eGI721OOsI6wgTV9h
         S/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Zbt8t4OGSrBZUltQdpu2XfV4/PLifVH/Z0A6OyR0+8=;
        b=Eo0irw8SRPzaufcOlIjCuGV9EZ+BDSxcTb0IewhMNCCt/4qxBL+c6xZHNVR5E3AMrc
         8GdfdI4Ebnw38OtL/fPWHy2fo9mEORMkl01JbrXRlN8Jz5COPHIOM/xLTMQV/jFGD9cs
         RMevkQsLnXfpt2DjNGdeqAaaqjc2aCXrATGzFMGdKXpS9IHsLNhTkJTHatRqh+yAV+je
         PyYlfZTQNOfdDhmNRJcx4l5r2okhJYu1Ie5XZ1yQTqWjRzMCBbYNGbPZqaodPXEAZCua
         i7VDQNjY06dkPL6hYTK8aB1/YwwKWEI59zNenAi3Wkbo98VhZ3UIo9CzKawo3SjwiXJN
         7Wtg==
X-Gm-Message-State: APjAAAUuTw0HM/ZXRASa5l8L7DpM3uKdSI1uYc51lv5jJQlOGP5kPgVt
        fXxOGq70SP/dQr/p5PyaslLBAuCM/aI=
X-Google-Smtp-Source: APXvYqzFL0ug3duO7jQiv4fIYDc9PRRgxXUE2znrHe+9Wbg98aE5ito2BvwQiYOyFf/uU62h7odVaQ==
X-Received: by 2002:a81:1bc8:: with SMTP id b191mr7003606ywb.120.1561751562263;
        Fri, 28 Jun 2019 12:52:42 -0700 (PDT)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id 15sm692368ywo.74.2019.06.28.12.52.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 12:52:41 -0700 (PDT)
Received: by mail-yw1-f45.google.com with SMTP id u134so4646673ywf.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 12:52:40 -0700 (PDT)
X-Received: by 2002:a81:8357:: with SMTP id t84mr7023115ywf.109.1561751559659;
 Fri, 28 Jun 2019 12:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190628123819.2785504-1-arnd@arndb.de> <20190628123819.2785504-3-arnd@arndb.de>
In-Reply-To: <20190628123819.2785504-3-arnd@arndb.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 15:52:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdL=GwjhbERsePAJfbakgEQZb7X51UHw=+4R9dJD3JD4A@mail.gmail.com>
Message-ID: <CA+FuTSdL=GwjhbERsePAJfbakgEQZb7X51UHw=+4R9dJD3JD4A@mail.gmail.com>
Subject: Re: [PATCH 3/4] staging: rtl8712: reduce stack usage, again
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Network Development <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 8:41 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> An earlier patch I sent reduced the stack usage enough to get
> below the warning limit, and I could show this was safe, but with
> GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, it gets worse again because large stack
> variables in the same function no longer overlap:
>
> drivers/staging/rtl8712/rtl871x_ioctl_linux.c: In function 'translate_scan.isra.2':
> drivers/staging/rtl8712/rtl871x_ioctl_linux.c:322:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> Split out the largest two blocks in the affected function into two
> separate functions and mark those noinline_for_stack.
>
> Fixes: 8c5af16f7953 ("staging: rtl8712: reduce stack usage")
> Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Willem de Bruijn <willemb@google.com>
