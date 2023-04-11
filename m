Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246FD6DD457
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 09:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjDKHiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 03:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjDKHiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 03:38:18 -0400
X-Greylist: delayed 440 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 00:38:17 PDT
Received: from mail.loanfly.pl (mail.loanfly.pl [141.94.250.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CA61709
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 00:38:17 -0700 (PDT)
Received: by mail.loanfly.pl (Postfix, from userid 1002)
        id EEE35A26F6; Tue, 11 Apr 2023 07:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=loanfly.pl; s=mail;
        t=1681198254; bh=flSgn4+IJB03yMaHNopPnR0v50wun3P5Hd/CkHJx2Bc=;
        h=Date:From:To:Subject:From;
        b=jw72wI7+OaRljwWjUJr5dTiowm7Zbau6kGwXmrYYsOy5VVksaozS6wt9Brd6vurP2
         mkslVG8bYhXdgwa6JljJrLnRMd3hlwziYnJV4cUjq+e0Qj8S7Y8dGrUQQbFmQm0H4q
         UBUBveeQDdhinoyyNpSCZ+WmvUu9Ku4JgJWkzDtyvDhVIckHT3Z9/2jVwrzcrfvlgE
         G6jvVONTYnlwFD9M/73FWq/uzoDeC+S+LkP/yVTuVJ8jhQV9UC+fFQpOvFKidUJRck
         G4rZXPh90wP4MLN4IWY90FXX5A6jnIcv67iEFactiRacZj2jZr0UtdF5nleIaS302K
         hktpXMIl+b1jg==
Received: by mail.loanfly.pl for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 07:30:52 GMT
Message-ID: <20230411064500-0.1.9h.12jb8.0.7580m7oocl@loanfly.pl>
Date:   Tue, 11 Apr 2023 07:30:52 GMT
From:   "Damian Cichocki" <damian.cichocki@loanfly.pl>
To:     <netdev@vger.kernel.org>
Subject: Prezentacja
X-Mailer: mail.loanfly.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_ABUSE_SURBL,URIBL_CSS_A,URIBL_DBL_SPAM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  2.5 URIBL_DBL_SPAM Contains a spam URL listed in the Spamhaus DBL
        *      blocklist
        *      [URIs: loanfly.pl]
        *  3.6 RCVD_IN_SBL_CSS RBL: Received via a relay in Spamhaus SBL-CSS
        *      [141.94.250.68 listed in zen.spamhaus.org]
        *  0.1 URIBL_CSS_A Contains URL's A record listed in the Spamhaus CSS
        *      blocklist
        *      [URIs: loanfly.pl]
        *  1.9 URIBL_ABUSE_SURBL Contains an URL listed in the ABUSE SURBL
        *      blocklist
        *      [URIs: loanfly.pl]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
X-Spam-Level: *******
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


Pozdrawiam,
Damian Cichocki
