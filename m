Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D6A89AD
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfIDPrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:47:40 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:43478 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729993AbfIDPrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:47:40 -0400
Received: by mail-yw1-f46.google.com with SMTP id q7so797539ywe.10
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 08:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=70ZOEgBmXN8cJ6SysFQnSbRP8tM+iSsC74CSZfRF7yI=;
        b=BvZfjr/YvtcW/6s0x/lnpc7GJvMmLWyHj3X5Dkbz/Jm/WxhkRFYnbUZnPfp3GTdRPV
         IQ/+gpzmcnH0GJ9DTM5fEyzcpFqF/dnxoLZnDPonEDDGLF0B3xydEptR67weJW3aMunC
         8T/58G+A4JG4Gv5ZgGHa6aPGsOyQ5yO/5fYkpsrcmgsHK1X4gsEMr+gEsVa9psm6UD7c
         5n5Ojdb53MLDkRgD2KT0LjhxIwCsXojngbmNjlAAw+KxzHfUaEKzKgc/lujfIZAWR2po
         a97G7VButgcMTsQZQthwGSh2VBZnLVTeFRD02j71GL/209uNij5NLMBUmAE7Mvbn1T6O
         JnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=70ZOEgBmXN8cJ6SysFQnSbRP8tM+iSsC74CSZfRF7yI=;
        b=VDcQNj9lT7zP1fkiOCvPJkXC2fJ+W5QJdXWnHY35FnN4f+HO7yuPIRYqR/1/g/XsSo
         vWwHOrbC6AYYbNuCXP8HGg4xUq6rPSfciZzlHAPO3I54jG5oBV+l8DyKxpQlR4eTNjLR
         JXPlQHPVOPlIyn9x8r9Tc6EjpM+wsPClszrx66zS1nptOj+caj98Xr+MyXLRnP76jH3M
         5EwQNjIg2PB+SXCjfG69HsrPPPrvYnGt/DTc3Q5NrkhiOliW0NxCx3E5cDoG1R8lBdmc
         65e2HNDnEmtavb6ca2zWTdjq83Y1agorfgN0f3eO+wcK8lqBdDk+vqsnx2SfhAzP8+CT
         S6Xg==
X-Gm-Message-State: APjAAAVKK4X4eGZwC14k8geygobasrzNJsD6LL4KBgSkhHD6rqRe2PGh
        hvyj8sKW0uhpI7B3i+WHZG8HsaU7
X-Google-Smtp-Source: APXvYqzEb8KBRL9ueN3WGOUeTneSDPdmozGGlbKKs3Vw6pPoF+etCA84WflgxK8Lht3t9L9F6S43RA==
X-Received: by 2002:a81:9c4c:: with SMTP id n12mr2760507ywa.40.1567612058182;
        Wed, 04 Sep 2019 08:47:38 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id a130sm2985480ywc.81.2019.09.04.08.47.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:47:36 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id g19so7457398ywe.2
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 08:47:36 -0700 (PDT)
X-Received: by 2002:a81:7d55:: with SMTP id y82mr16508473ywc.111.1567612055908;
 Wed, 04 Sep 2019 08:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net> <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
 <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com> <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
In-Reply-To: <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 4 Sep 2019 11:46:57 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
Message-ID: <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
To:     Steve Zabele <zabele@comcast.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mark KEATON <mark.keaton@raytheon.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 10:51 AM Steve Zabele <zabele@comcast.net> wrote:
>
> I think a dual table approach makes a lot of sense here, especially if we=
 look at the different use cases. For the DNS server example, almost certai=
nly there will not be any connected sockets using the server port, so a tes=
t of whether the connected table is empty (maybe a boolean stored with the =
unconnected table?) should get to the existing code very quickly and not re=
quire accessing the memory holding the connected table. For our use case, t=
he connected sockets persist for long periods (at network timescales at lea=
st) and so any rehashing should be infrequent and so have limited impact on=
 performance overall.
>
> So does a dual table approach seem workable to other folks that know the =
internals?

Let me take a stab and compare. A dual table does bring it more in
line with how the TCP code is structured.
