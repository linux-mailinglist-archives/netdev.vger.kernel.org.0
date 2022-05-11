Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2F2522D2F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242878AbiEKHYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242867AbiEKHY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:24:29 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFCD1C0F25;
        Wed, 11 May 2022 00:24:27 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id D7A8930322EA;
        Wed, 11 May 2022 09:23:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=noksS
        6avucQChdNExBN5UJBtftQ5wnHW8uU3NUv5UFE=; b=PE6+UwTWyGs26TfPsDLKq
        a0T3t7uh5yN/A69uWtzKAAaKnjZwpSreGL3ooSQLpImH/Uq9EFSpkudO9f9JlK4Z
        Vw13M+68LotaYaytGCnuqQSzvAnHL7POSZfEEolfyz2VBRDobJNVqyqZMf0sObk0
        RB8ij9cnj+qfE4wKYZA2hMVS6J7YiXw72OMBPoCABD3U6fkOHjHobBv98lI4VS0r
        FgnbwlVq0Eqmv4oFfdGqIzihd6gH81+QF22iwFdWMXbiUTy+wAKZLQR/vEoeFd8a
        qBUQoB8AwFxOKGHq0iJW33FiEvNUQ9yJJtxDwm+0xKi8Gh23e88N3w5ECgQQVn2r
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id DDF8F30322D3;
        Wed, 11 May 2022 09:23:54 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 24B7NsBG027064;
        Wed, 11 May 2022 09:23:54 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 24B7Nshg027063;
        Wed, 11 May 2022 09:23:54 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [PATCH net-next] docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure'
Date:   Wed, 11 May 2022 09:23:24 +0200
User-Agent: KMail/1.9.10
Cc:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com> <202205101825.15126.pisa@cmp.felk.cvut.cz> <268372a9-2f6a-74f3-29ea-c51536a73dba@gmail.com>
In-Reply-To: <268372a9-2f6a-74f3-29ea-c51536a73dba@gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <202205110923.24202.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Akira,

On Wednesday 11 of May 2022 01:34:58 Akira Yokosawa wrote:
> On Tue, 10 May 2022 18:25:15 +0200,
>
> Pavel Pisa wrote:
> > Hello Akira,
=2E..
> > I have not noticed that there is kernel-figure
> > option. We have setup own Sphinx 1.4.9 based build for driver
> > documentation out of the tree compilation, I am not sure if that
> > would work with this option but if not we keep this version
> > modified. There are required modification for sources location anyway...
> >
> > https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/linux_driver/buil=
d/
> >ctucanfd-driver.html
>
> You might want to see kernel's doc-guide at
>
>     https://www.kernel.org/doc/html/latest/doc-guide/sphinx.html
>
> , or its source
>
>     Documentation/doc-guide/sphinx.rst

I think I have read it in 2019 when I have managed to switch
to kernel format documentation in out of the tree driver build

https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/commit/09983d11ab34977=
104d2be0b1376d4c93d9a01cb

Then I have enhanced documentation text and picture
from Martin Jerabek's thesis etc..

> >> The directive of "code:: raw" causes a warning from both
> >> "make htmldocs" and "make pdfdocs", which reads:
> >>
> >>     [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name
> >>     'raw' is not known
> >
> > Strange I have not seen any warning when building htmldocs
> > in my actual linux kernel tree. I have cleaned docs to be warnings
> > free, but it is possible that I have another tools versions.
>
> Well, I don't think "make htmldocs" runs with Sphinx 1.4.9.

This is Sphinx version reported by out of tree documentation build.
It can be hidden in one of dockers which are used by gitlabrunner
for CI. When I find some time I can look for update.

> You mean 1.7.9?

My local net-next make htmldocs generated pages report Sphinx version 1.8.4.

So this seems to be a mix, but I agree that it is important to clean
docs in the state when it works for each not totally archaic setup.

Thanks for the feedback,

                Pavel
=2D-=20
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

=20

> Then the above mentioned warning is not shown.
> I see the warning with Sphinx versions 2.4.4. and 4.5.0.
>
> I'll amend the changelog to mention the Sphinx versions and
> post as v2.
>
>         Thanks, Akira
>
> > Anyway thanks for cleanup.
> >
> >> A plain literal-block marker should suffice where no syntax
> >> highlighting is intended.
> >>
> >> Fix the issues by using suitable directive and marker.
> >>
> >> Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> >> Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core
> >> documentation.") Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> >> Cc: Martin Jerabek <martin.jerabek01@gmail.com>
> >> Cc: Ondrej Ille <ondrej.ille@gmail.com>
> >> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> >
> > Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> >
> >> ---
> >>  .../networking/device_drivers/can/ctu/ctucanfd-driver.rst     | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git
> >> a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
> >> b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
> >> index 2fde5551e756..40c92ea272af 100644
> >> ---
> >> a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
> >> +++
> >> b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst =
@@
> >> -72,7 +72,7 @@ it is reachable (on which bus it resides) and its
> >> configuration =E2=80=93 registers address, interrupts and so on. An ex=
ample of
> >> such a device tree is given in .
> >>
> >> -.. code:: raw
> >> +::
> >>
> >>             / {
> >>                 /* ... */
> >> @@ -451,7 +451,7 @@ the FIFO is maintained, together with priority
> >> rotation, is depicted in
> >>
> >>
> >>
> >> -.. figure:: fsm_txt_buffer_user.svg
> >> +.. kernel-figure:: fsm_txt_buffer_user.svg
> >>
> >>     TX Buffer states with possible transitions


=2D-=20
Yours sincerely

                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

