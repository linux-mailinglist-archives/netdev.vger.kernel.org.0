Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E956402CE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiLBJCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbiLBJBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:01:51 -0500
X-Greylist: delayed 442 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 00:59:18 PST
Received: from mail.moelfre.pl (mail.moelfre.pl [193.142.59.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ABEC7730
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:59:18 -0800 (PST)
Received: by mail.moelfre.pl (Postfix, from userid 1001)
        id AF09024EFE; Fri,  2 Dec 2022 09:51:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=moelfre.pl; s=mail;
        t=1669971113; bh=kECt9x2dzkW1QJ5sNZ9CqfHxrNzLdZ2r55b5WGK2SS0=;
        h=Date:From:To:Subject:From;
        b=uBBEhJGomGTuQKhh3mduIIfCvTQE4/j6mhE0WYMXGq+h8fU/eQgNK/n23HhefEJdT
         dBp/qFBTl30W9uIwO/TKURkI94qM8Slt8EqB2ywB+nSvScnNyyspAECw2hm1+xa4KD
         91eqzdTGx10chtOru0ZNlcJtFLtKSeSFxlOYcNUGXyPq3gulsJXGPSE7fbrI+bcWBa
         UmizYuAcDaqYucnHwNEulvog5vCFhLmFlQ5SX4+I+c5kAv7FigMxjZbnvE6qlWkxYm
         7IEfgapzs8o3tzY/sJK/I3wngSpMJe3H2ZpSw7wlrko5q3gVvdRAibLW5qHzk469zj
         9fTfmXVhfJt9g==
Received: by mail.moelfre.pl for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:51:38 GMT
Message-ID: <20221202083000-0.1.2b.5w6z.0.agi65fqtxi@moelfre.pl>
Date:   Fri,  2 Dec 2022 08:51:38 GMT
From:   "Patryk Zawada" <patryk.zawada@moelfre.pl>
To:     <netdev@vger.kernel.org>
Subject: =?UTF-8?Q?W_sprawie_zam=C3=B3wie=C5=84?=
X-Mailer: mail.moelfre.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_PBL,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4990]
        *  3.3 RCVD_IN_PBL RBL: Received via a relay in Spamhaus PBL
        *      [193.142.59.204 listed in zen.spamhaus.org]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [193.142.59.204 listed in bl.score.senderscore.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dzie=C5=84 dobry,

mo=C5=BCemy zap=C5=82aci=C4=87 u dostawcy za zakupione przez Pa=C5=84stwa=
 towary, a Pa=C5=84stwo ureguluj=C4=85 faktur=C4=99 w p=C3=B3=C5=BAniejsz=
ym terminie (30-90 dni).

Takie rozwi=C4=85zanie wielokrotnie sprawdza si=C4=99 u naszych Klient=C3=
=B3w, wi=C4=99c je=C5=9Bli chcieliby Pa=C5=84stwo zobaczy=C4=87, jak to w=
ygl=C4=85da w praktyce-prosz=C4=99 o wiadomo=C5=9B=C4=87.

Ch=C4=99tnie zadzwoni=C4=99 i przedstawi=C4=99 szczeg=C3=B3=C5=82y.=20


Pozdrawiam
Patryk Zawada
