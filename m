Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCD405D1D7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGBOge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:36:34 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34151 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfGBOge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:36:34 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so27575580edb.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=afYE9IU6fIhWJ6cGXPHXMC4T6a6OI9PNipZSciWzk04=;
        b=qotVP+9BJVYFQZBxtlQVyJz2fM8mclpnHRPsRIvp0MwD5uUgwlRlHFmqCH85lb6vXB
         8MgUfhYRdqAFfUuc6FFQ1aRWro2GC/Mh/ueBIAEJEseojWCCNvF1ZFjqlaSrqkvD4ZqA
         MuBdDbTTWHqwHztcFgf94UtRTFqFj1aaEKdB5HA3AbKitf+u5FAejmjXDU7d97YKN/gl
         SIoTQhe1jzlKvhWYS20VLpz9NzQxLu4QDaLtg3ud7ZFcZ0RL/ISv3vdDwiAjvMWv+INy
         Q5OiJaAhbtujqadXdwM8Mo8mZodw/Mguv+5gudctzXuJj4z8RgIfJZRiP1ku0wSolJko
         R3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=afYE9IU6fIhWJ6cGXPHXMC4T6a6OI9PNipZSciWzk04=;
        b=BIPf/Ufqm55jUsh7wvBQiVKKyWDACd2P06kLbc1uh51LQ9K9UXoEw1g/796xJ57Kuf
         wW4X/JE+ViZN2gzeeX/k9tgoz2yVa8vc+6Vs9KTyeYasx/XlePE8NgV7EjsJhQf3s+3B
         yR9690AQXumV5dozAJI1+SpRqM5us/zZelYtNRLD7WkqKf1XJ4c40ih6ZM4q9+lQOiGf
         UXqYejvhJBPH7M7Th0KEwb1HZTF62O+Whk0Nuukw6jM1CwVmQS+FpoeQWuHUbfIbXpKc
         t8Q/EeIxDz7Nv11No0bgd0K2N480lUDBUYErsN1B0ZufIqLE6xtJBFJlSWH6r6nlDPpo
         /mhg==
X-Gm-Message-State: APjAAAX7q9ARbO1HaYomMyn4jmOwHx3hkLXKe25ozL4G6XEsrA6QLTkk
        fXE06Uw4cHMr9j8SXIc7IjWxXXQzMnV8QONvk4tjHw==
X-Google-Smtp-Source: APXvYqykRL/vSmL4cvqd48CupaeuB7YI1gO9EptL+vXwTp6Ov6skJySdNz4nPeCFfr35y86fH8UswVXss+Oy9GAI3Ks=
X-Received: by 2002:a50:a53a:: with SMTP id y55mr37040782edb.147.1562078192193;
 Tue, 02 Jul 2019 07:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <4932e7da775e76aa928f44c19288aa3a6ec72313.camel@domdv.de>
 <CA+FuTSfmi3XCTR5CCiUk180XTy69mJsL4Y_5zStP727b=woWJQ@mail.gmail.com>
 <20190701132157.GA15622@bistromath.localdomain> <b393fc9f9a9e4e49b9cbe6edebb3cd38301ffd92.camel@domdv.de>
In-Reply-To: <b393fc9f9a9e4e49b9cbe6edebb3cd38301ffd92.camel@domdv.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Jul 2019 10:35:56 -0400
Message-ID: <CAF=yD-JQYOVHeHr4wZ-mcxyQc2gS0RUNoFcRXch+F+RA94-W5A@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] macsec: add brackets and indentation after
 calling macsec_decrypt
To:     Andreas Steinmetz <ast@domdv.de>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 12:38 AM Andreas Steinmetz <ast@domdv.de> wrote:
>
> Ouch, I missed that when Andreas sent me that patch before. No, it is
> > actually intended. If we skip macsec_decrypt(), we should still
> > account for that packet in the InPktsUnchecked/InPktsDelayed
> > counters. That's in Figure 10-5 in the standard.
> >
> > Thanks for catching this, Willem. That patch should only move the
> > IS_ERR(skb) case under the block where macsec_decrypt() is called, but
> > not move the call to macsec_post_decrypt().
>
> Updated patch below.
>
> Signed-off-by: Andreas Steinmetz <ast@domdv.de>

When making a change in a patch set, please resubmit the entire
patchset (with a v2, and record the changelog).
