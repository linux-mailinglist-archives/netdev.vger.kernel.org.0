Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83131559449
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiFXHiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiFXHix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:38:53 -0400
X-Greylist: delayed 502 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Jun 2022 00:38:52 PDT
Received: from mail.procompanybiz.com (mail.procompanybiz.com [141.94.250.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C026F5DC13
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:38:52 -0700 (PDT)
Received: by mail.procompanybiz.com (Postfix, from userid 1002)
        id 95D65A24B5; Fri, 24 Jun 2022 07:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=procompanybiz.com;
        s=mail; t=1656055828;
        bh=BRzo865V3b2iqpNAJFpvo/jzl/BiRdlPQfOepA8hDDc=;
        h=Date:From:To:Subject:From;
        b=K+7PQWsCQk6M9BlecMU+MPM/xyGb1z8NvMRB/v7hTAVivKkjr5ckFGY9beWI9b8fV
         05iix+2eWq6gwZLE8jThHWr416W2AvrIrkPdEAtMRT9MY2t2oCirOVAfIJ56nfAI7E
         vvLHsnjDEgo3/C/mPup5ZGV6/iosJVAh+2Rdi9v1sTJAIOikgkWZ9AKkBCQWlCoSJ3
         u068fTLxXTx38iEtI0/l5J5WKlCv3Ux1cUt+XBtl3eOBZiLiModOJz+tOTPTcF7qGd
         dYah2ccebqwrVDlC14hPzdLjWdTmUxQdzB+hQD6zYv1n+e/apf1kjL8T7Is7gr1v4L
         HjNW8lTp+wscw==
Received: by mail.procompanybiz.com for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 07:30:26 GMT
Message-ID: <20220624064500-0.1.25.fv7l.0.2h1cpzn27e@procompanybiz.com>
Date:   Fri, 24 Jun 2022 07:30:26 GMT
From:   "Kamil Podskrobek" <kamil.podskrobek@procompanybiz.com>
To:     <netdev@vger.kernel.org>
Subject: Zaplanowanie dostaw
X-Mailer: mail.procompanybiz.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dzie=C5=84 dobry,

kilka miesi=C4=99cy temu zg=C5=82osi=C5=82a si=C4=99 do nas firma produkc=
yjna, w kt=C3=B3rej transport towaru przekroczy=C5=82 ustalony bud=C5=BCe=
t, a r=C4=99czne planowanie dostaw poch=C5=82ania=C5=82o zbyt du=C5=BCo c=
zasu.

Zaproponowali=C5=9Bmy im rozwi=C4=85zanie, kt=C3=B3re w ci=C4=85gu kilku =
minut generuje optymalny plan dystrybucji i transportu, optymalizuj=C4=85=
c trasy dla dostaw i odbior=C3=B3w.=20

W efekcie Klient zmniejszy=C5=82 koszty dostaw nawet o 20%, skr=C3=B3ci=C5=
=82 czas planowania i zarz=C4=85dzania dostawami i tym samym obs=C5=82ugu=
je wi=C4=99ksza ilo=C5=9Bc wysy=C5=82ek i nawet 10 razy wi=C4=99ksza ilo=C5=
=9B=C4=87 zam=C3=B3wie=C5=84.

Dzi=C4=99ki wieloletniemu do=C5=9Bwiadczeniu uwa=C5=BCam, =C5=BCe to dobr=
e rozwi=C4=85zanie dla rozwoju Pa=C5=84stwa firmy i wierz=C4=99, =C5=BCe =
warto o tym porozmawia=C4=87. Mog=C4=99 zadzwoni=C4=87?


Pozdrawiam
Kamil Podskrobek
