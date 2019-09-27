Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E96C0DA5
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 23:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfI0Vv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 17:51:58 -0400
Received: from sonic317-27.consmr.mail.bf2.yahoo.com ([74.6.129.82]:44006 "EHLO
        sonic317-27.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728150AbfI0Vv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 17:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1569621116; bh=knPlk/DNE0/D/MXFLLvasv6chgzVxN8njVGPUdifoTc=; h=Date:From:Reply-To:Subject:From:Subject; b=gF2EEBJ1cdX73Vd/C2SCEp4gwmekcqXOa1hx9Tt6VSkzWglVh88wGz3QsPYFfiJYihhihUw4YNVbuOyG/x+KLtc5iofn78i2p8SPTcFh5oTKUWfqc33N3jgY91jJ4lbm0HIZjC36nfcWKSozxqr+LSuFwsiO3ISKQcLTGt0IjiadRcnNB/WLiD9Cfx6uONFrf9TAwNuHz2fE+Ad+O3sX0LxUNnjnAYQloFEdv8em98evfoLIcjIk7fEzuNhtKxw+jbEvv5/TtS+GIWcdfkdwFZ0P4lIjnM9kmsuvA9BZNxULRmf+QRn2bc77MBmNMRV+CZSxvse/EQFRS+wvWStn9g==
X-YMail-OSG: kklIvTMVM1li1Kb9jH9lKG7vmuCoMnk9Bec3MKOVbcMJrABOSpt0DEyMY_EkNok
 mZYqhSho9i85MXtNJuZLZWetsX2TIbdnxy7ZlNvd05AJOdLRFtXDaDwk_dtoiDQfZC1Y87ahUO_f
 V2KMDDCS2QYvS_Ca8wLhd6K5pZ89FANOCgh63sr2159.EPqzJqBKyt9JpOzEKeBrHnaie2KJpfm7
 fMWCmSIR7Bjd5quIguGrUNeziZlwxEC55Oa6KZ7LsV6spuaE_j2hos7yzO_Z23ukkflcAkmgYYMc
 ZeVEA5r1C10kiUJCLjalhNkjcPKsf44.DFOJBZPGIbQITkwkNZpPBSHufwJpZkm8.kdvtbFqIWoV
 ybHsSizKcDCVX9hjeTmiBJ55te89qm7FYyy4TDnMT6CxrGNynaLKFzKt7d95YIEU7P_y8Diz4bRj
 YZYkRUMjzpiVXoQJ1_hwBqUYw3W4YzTAQoZ2TawrGvalaECbRLQF2BhTIg0YEODKkW5wMfToY.3p
 GQv9GUSpKBU1PjrI1K81Xbx6_YEt0IB.TU4FGcAjT1KCRnEaCg74Y6_wqn0QVJyQ7AwuyREQWISu
 xA5ev7pTd996uc_2QMElRJRZIlW_fJ4bnc1z0dTu_ejv8FKJj8zD3_bguoF0s7OXUm_4R2D.0VGK
 Rb_xESA7DblKwYc5bpaBX0sYRw4BY7HvhFZ6MK1Ij0avxz69668B34Y5frpn13L9LrgJOkg3cs95
 Ftz37brk7ccSMyqD67I.VbWVeG2npKnGYEJmhIAulMfXkSJTsjRjHoFBXxM0xtXLiqrcptgf8dYM
 sChu5fzFTItwT_H9LpnYBlfzIh1cmDy3MU2As3pCpSzC4leSzNU2A0i7Hu57xR9TidIr_Om1A4hc
 OHhdxv7wvJKy3usYOrIe_UL7Y3inCFnOn42pRe3W9TsLEiinRXvWQldzQEOLjr_xZ5VKxPhjHIB7
 F5XydsA_BL6whrQZ._16LQcGqoZgmzeGO5_ZM_DzA4j8bw6XgCBz_M6TidBJRkcjMUS_OPKMPpKY
 Thg0EKkkXX_6wuThBeMpP6izi0Mlw2cl8_F2IPNRkQgFAQDbREqnFSg_WGAARCv0i34DFrd7Rhg1
 sRW9jnc4MaKqW_3EqHm_hjmseZIrwtgHitkdoe5kkmy7HvD6UIF_eUYfiq5_kfszbMRlHhwcGUeH
 .NjGZIGbkO51plSmZMyWvhZT_9gtmAljGckfcpFU4YIGiiGIECFq1n05v3jyuV19JG7p._3cYp0H
 1F6zbJzeTpLsKKeH6qq_oQXVGRKkDxsOp39.Q
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Fri, 27 Sep 2019 21:51:56 +0000
Date:   Fri, 27 Sep 2019 21:51:54 +0000 (UTC)
From:   Rita Nick <nickrita@outlook.fr>
Reply-To: ritanick95@gmail.com
Message-ID: <1183427364.314194.1569621114650@mail.yahoo.com>
Subject: Hello Dear Friend
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dearest,

Sorry=C2=A0for=C2=A0open=C2=A0a=C2=A0privacy,=C2=A0my=C2=A0name=C2=A0is=C2=
=A0Rita=C2=A0Nick.=C2=A0I=C2=A0am=C2=A0currentilled=C2=A0infection=C2=A0can=
cer=C2=A0disease=C2=A0and=C2=A0i=C2=A0wish=C2=A0to=C2=A0donate=C2=A0my=C2=
=A0inheritance=C2=A0of=C2=A0my=C2=A0late=C2=A0husband=C2=A0fund=C2=A0deposi=
ted=C2=A0in=C2=A0his=C2=A0bank=C2=A0account=C2=A0as=C2=A0amount=C2=A0of=C2=
=A0$3,560,000.00=C2=A0USD,=C2=A0recently=C2=A0the=C2=A0doctor=C2=A0told=C2=
=A0me=C2=A0that=C2=A0i=C2=A0might=C2=A0not=C2=A0live=C2=A0for=C2=A0more=C2=
=A0eight=C2=A0months=C2=A0from=C2=A0now=C2=A0due=C2=A0to=C2=A0my=C2=A0cance=
r=C2=A0infection=C2=A0disease.=C2=A0I=C2=A0want=C2=A0you=C2=A0to=C2=A0utili=
se=C2=A0it=C2=A0to=C2=A0establish=C2=A0business=C2=A0investments=C2=A0that=
=C2=A0will=C2=A0create=C2=A0a=C2=A0job=C2=A0for=C2=A0opportunities=C2=A0to=
=C2=A0the=C2=A0jobless=C2=A0population=C2=A0and=C2=A0less=C2=A0privilege,=
=C2=A0i=C2=A0should=C2=A0give=C2=A0you=C2=A0more=C2=A0details.=C2=A0If=C2=
=A0you=C2=A0are=C2=A0willing=C2=A0to=C2=A0go=C2=A0this=C2=A0project,=C2=A0i=
=C2=A0look=C2=A0forward=C2=A0to=C2=A0hear=C2=A0back=C2=A0from=C2=A0you=C2=
=A0as=C2=A0soon=C2=A0as=C2=A0possible.

Regards!
Mrs.=C2=A0Rita=C2=A0Nick
