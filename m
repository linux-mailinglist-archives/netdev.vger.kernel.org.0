Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9A6C45B9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCVJIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCVJIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:08:02 -0400
X-Greylist: delayed 418 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Mar 2023 02:07:44 PDT
Received: from mail.tarvie.pl (mail.tarvie.pl [80.211.129.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2297B5D8A8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:07:43 -0700 (PDT)
Received: by mail.tarvie.pl (Postfix, from userid 1002)
        id 6A8EE86DF6; Wed, 22 Mar 2023 09:56:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tarvie.pl; s=mail;
        t=1679475463; bh=5QPMt7jNntM5ZbstM20BWsHIeLbmRE8lVU4Iu89IleQ=;
        h=Date:From:To:Subject:From;
        b=TQbdSoSQUSlQ1DWM49/bXwqkccUzIKgyS4eYhFOrjBj3TRawNiz1iM5VJhCGeYI5Z
         OylTJlb8GKMlaWYI1jVTx3Otky7WNE/mwLBf+XpCHPCdGB1s2xCzM9zQ9yn8uQE9Mv
         f2NUb4x5885sKil8GISVt4EsBiC6A2uYcFM1v0r6VB3qMT8o/QeywJLfztPggT3Gcy
         57Wxr1OP4v9pxbshKhpCrm0jKNPbddt5WpoVT8t1GP84y24LGZCIxBV3zsJRYfDMRo
         AQOFmGJU9foAYlmazIG60aNGBDQFzIPageNgqsy7JUNZ09e2uV7+q3ZyVeCHFNtEAx
         dWPWqizYwYsOg==
Received: by mail.tarvie.pl for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:56:18 GMT
Message-ID: <20230322084500-0.1.c.28tf.0.bwqaho0g8l@tarvie.pl>
Date:   Wed, 22 Mar 2023 08:56:18 GMT
From:   "Marcin Chruszcz" <marcin.chruszcz@tarvie.pl>
To:     <netdev@vger.kernel.org>
Subject: Prezentacja
X-Mailer: mail.tarvie.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,URIBL_CSS_A,URIBL_DBL_SPAM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: tarvie.pl]
        *  2.5 URIBL_DBL_SPAM Contains a spam URL listed in the Spamhaus DBL
        *      blocklist
        *      [URIs: tarvie.pl]
        *  3.6 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [80.211.129.100 listed in zen.spamhaus.org]
        *  0.1 URIBL_CSS_A Contains URL's A record listed in the Spamhaus CSS
        *      blocklist
        *      [URIs: tarvie.pl]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dzie=C5=84 dobry!

Czy m=C3=B3g=C5=82bym przedstawi=C4=87 rozwi=C4=85zanie, kt=C3=B3re umo=C5=
=BCliwia monitoring ka=C5=BCdego auta w czasie rzeczywistym w tym jego po=
zycj=C4=99, zu=C5=BCycie paliwa i przebieg?

Dodatkowo nasze narz=C4=99dzie minimalizuje koszty utrzymania samochod=C3=
=B3w, skraca czas przejazd=C3=B3w, a tak=C5=BCe tworzenie planu tras czy =
dostaw.

Z naszej wiedzy i do=C5=9Bwiadczenia korzysta ju=C5=BC ponad 49 tys. Klie=
nt=C3=B3w. Monitorujemy 809 000 pojazd=C3=B3w na ca=C5=82ym =C5=9Bwiecie,=
 co jest nasz=C4=85 najlepsz=C4=85 wizyt=C3=B3wk=C4=85.

Bardzo prosz=C4=99 o e-maila zwrotnego, je=C5=9Bli mogliby=C5=9Bmy wsp=C3=
=B3lnie om=C3=B3wi=C4=87 potencja=C5=82 wykorzystania takiego rozwi=C4=85=
zania w Pa=C5=84stwa firmie.


Pozdrawiam
Marcin Chruszcz
