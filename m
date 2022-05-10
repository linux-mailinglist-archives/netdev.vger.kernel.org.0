Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02AA522160
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347487AbiEJQin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244941AbiEJQim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:38:42 -0400
X-Greylist: delayed 557 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 May 2022 09:34:43 PDT
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891E02A3752;
        Tue, 10 May 2022 09:34:43 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 4F8D8303260B;
        Tue, 10 May 2022 18:25:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=GUwmb
        8WUz+d8rIT5s68PdvGp8OiPvyQgMToZHWTShs8=; b=anjgfRPvazXbKAMxUXKa7
        fY6juY58etYD/ZiNtJmBdIBIdGc4KaooWeuPCcPz51tSx6dqctHVf106A4I7RPMb
        1TEgzTFo4U/YVOyaWGs39x4NKRCTRkfoMTSOob95cXLgg+ZbOjzvnS0am3VPvL6T
        c1bqktoZkeemT60Xy0O8S57CRqB4GFw8LJxevnYiLXmj6qnAQpwq+aMn4CZOiqQz
        8yHC/4abCXhKR2UqR6AX8wewcPtF6LYTERJLnWiVZpqUuC4VP5MyMMNBmwPokEcO
        SUnGfniSF6vixheoxKvEoyvX/y0yfVi5y+mNdp/NDeZWEBQxDJYejAZ7/IxUs79Z
        g==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 77C823032609;
        Tue, 10 May 2022 18:25:23 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 24AGPNgM025943;
        Tue, 10 May 2022 18:25:23 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 24AGPM8X025942;
        Tue, 10 May 2022 18:25:22 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [PATCH net-next] docs: ctucanfd: Use 'kernel-figure' directive instead of 'figure'
Date:   Tue, 10 May 2022 18:25:15 +0200
User-Agent: KMail/1.9.10
Cc:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
In-Reply-To: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Message-Id: <202205101825.15126.pisa@cmp.felk.cvut.cz>
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

On Tuesday 10 of May 2022 11:34:37 Akira Yokosawa wrote:
> Two issues were observed in the ReST doc added by commit c3a0addefbde
> ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.").

Thanks for the fix

> The plain "figure" directive broke "make pdfdocs" due to a missing=20
> PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
> directive, which is an extension for kernel documentations, should
> be used instead.

I have not noticed that there is kernel-figure
option. We have setup own Sphinx 1.4.9 based build for driver
documentation out of the tree compilation, I am not sure if that
would work with this option but if not we keep this version
modified. There are required modification for sources location anyway...

https://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/linux_driver/build/ct=
ucanfd-driver.html

> The directive of "code:: raw" causes a warning from both
> "make htmldocs" and "make pdfdocs", which reads:
>
>     [...]/can/ctu/ctucanfd-driver.rst:75: WARNING: Pygments lexer name
>     'raw' is not known

Strange I have not seen any warning when building htmldocs
in my actual linux kernel tree. I have cleaned docs to be warnings
free, but it is possible that I have another tools versions.

Anyway thanks for cleanup.

> A plain literal-block marker should suffice where no syntax
> highlighting is intended.
>
> Fix the issues by using suitable directive and marker.
>
> Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> Fixes: c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core
> documentation.") Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
> Cc: Martin Jerabek <martin.jerabek01@gmail.com>
> Cc: Ondrej Ille <ondrej.ille@gmail.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>

Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

> ---
>  .../networking/device_drivers/can/ctu/ctucanfd-driver.rst     | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git
> a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
> b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst ind=
ex
> 2fde5551e756..40c92ea272af 100644
> --- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
> +++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
> @@ -72,7 +72,7 @@ it is reachable (on which bus it resides) and its
> configuration =E2=80=93 registers address, interrupts and so on. An examp=
le of such
> a device tree is given in .
>
> -.. code:: raw
> +::
>
>             / {
>                 /* ... */
> @@ -451,7 +451,7 @@ the FIFO is maintained, together with priority
> rotation, is depicted in
>
>
>
> -.. figure:: fsm_txt_buffer_user.svg
> +.. kernel-figure:: fsm_txt_buffer_user.svg
>
>     TX Buffer states with possible transitions


