Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68A3818B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfFFXGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:06:34 -0400
Received: from sonic309-25.consmr.mail.ir2.yahoo.com ([77.238.179.83]:46266
        "EHLO sonic309-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbfFFXGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.pt; s=s2048; t=1559862392; bh=UWLwNn799tYKqEh5E8i1Banb+AssjoXNKQQVKnasZOA=; h=Date:From:Reply-To:Subject:From:Subject; b=GdVywJ80TXjSKUgcXgTZPMAdlGT1Sw/dIYCAr/VA76LheyPXKy7dYXyetU6tz30eJlPkHOyUnD/sRqShme2FullNIckckWwclklRMk2tscE5P3IUFeIKgcbu9Xfy6JWaYp6P3UloYy7iJuIySywC2zAQTr+m8ImbiKwJ4vXlNH8dYv7J50j1YtphDBdPbnCLAfKv6+IPI+ZR3zHZJOoldV2QFj6LfvOgeJqX2FtV1T4x7WC5klyXPHK1GqpN303x6V4LsJBUYAbbgnjTqidsyDuYRgl3g0ZmQi1z6BgCR+k1C+3l2hKw4b69F5S4AY1JNZsiqXaJ6A+5QKb03Q8QGA==
X-YMail-OSG: wO79cQ4VM1l6rr1JeRe_QSDsmi82HLh211rGCdlS1Vi5eNZNUQ.PYswj11eWGwk
 oBtao4GL6mZSqHSISZSYnLTrp4nsHJh73C6hly49iO2TAPm0axGJAd1WgAQntPfEQpNqr5JoQCNN
 83pDE9OIAtV2VuSnsSPd4MdmpjaVy0OHNF_ebKiOriQUe6nL9JLNh0gPatdtJ9dOWWbowXFmI7GC
 3Hy768aNUy44Ejov_zhI6GXE7yFYIfqaRvcFYG_mVQb6OSaFHrGynPDpDOXevL3gz2Dnz_fup4xT
 4CWbD6dEsxNIWryrQ_ndkxBqtFAKPPDkg51Ni1DfdbMO1vXrGR8X_j0yP63T1I_b1WFpoZipMx0m
 OI0btdPiXsLr24t1UicAR11I5V2.ei3AdoKSPtAeUqVmmCSijnoLRxYQrpx8qRoiAL8RGocyN01e
 GaQXuoXQulTKitRIKRvbyu8UdVAhja5V4.8nBx6DGxNQpRkPht8EAc.Vtr57bKvRO6plIUT8FVck
 h3aEY4PAfoVIm0MZqYLsv1VzUUYNKe_OMUrxrbXB4hjies8JuBxWs4xVYyl8aTZiPDl0gvPlplC2
 8WxHmS_UYu3nfgU4PkxYws7DGiJksi_N6xiCdanJyDvfeWU.tLaatHkg.ug19YAwOKWa3KY2z9Or
 RyJkbOyzT.4h25SfMd_BsfSCpDGj6cD_dOYnp0zfIOuQpHanwz7RHqIZMSjI_hT6soOlM59AZFj8
 LTWliHcIw0BRayCTHkItXm6nxbqzg9e.Gyu_CGkaejZrL7IDqyJjo6k2.iSzLIlAAUkyrlrMARDW
 6HlwTTnlnvIxzadnViJUgf5zsZH_hMyFvBCATP9UjviMuT_9Tz1IB6HZ4yAqrbCgW5HrmaaNAAZ.
 v78GdFc9_VTjX9NkIReH8kJbBy0CnqgBcmE8vLFSS5fWex4RimIa7q7qkMHDELvT5nZ5Mz04zRcC
 l6NdghJx57SIXgdlvaYEJbsYKQQadOvmnpzzZ3e4kQKhDeeQCnEn6NxlSpNB2WL1xllmW0Y43czw
 Q_53QJNy4eu2qVZFlZzOa2Ot4FLGh2ACyN45CgkXtpirTAmVMchjT0bQlyLHbhKVMaulVNRJkfEt
 Us7JCIOe5cYBdAzUjml6No0JOWsVnAxnukDc8PA9DGgYQD5LUaUpLR4j1P4phBvqtItfFMiCLu3y
 8uVnaFUm8iZEqc6yGPTG7CPagFdWsEdkCiVEtlQXcBODSp7WepKeeJotgW6VdVTMrYHjRFdrIBT_
 ljT0oEQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Thu, 6 Jun 2019 23:06:32 +0000
Date:   Thu, 6 Jun 2019 23:06:30 +0000 (UTC)
From:   jamesfentwistle61@yahoo.pt
Reply-To: davidmous77@gmail.com
Message-ID: <375610799.1494361.1559862390787@mail.yahoo.com>
Subject: Urgent
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Urgent=C2=A0Attention

This=C2=A0is=C2=A0my=C2=A0second=C2=A0time=C2=A0I=C2=A0am=C2=A0sending=C2=
=A0you=C2=A0this=C2=A0notification,=C2=A0simply=C2=A0contact
Diplomat=C2=A0David=C2=A0Mousn=C2=A0with=C2=A0your=C2=A0contact=C2=A0inform=
ation=C2=A0and=C2=A0your
nearest=C2=A0airport=C2=A0to=C2=A0land,=C2=A0so=C2=A0that=C2=A0he=C2=A0can=
=C2=A0deliver=C2=A0the=C2=A0Package=C2=A0worth=C2=A0($20.5
Million=C2=A0USD)=C2=A0as=C2=A0he=C2=A0just=C2=A0landed=C2=A0in=C2=A0your=
=C2=A0country=C2=A0now=C2=A0but=C2=A0misplaced=C2=A0your
information,=C2=A0he=C2=A0will=C2=A0give=C2=A0you=C2=A0more=C2=A0details=C2=
=A0when=C2=A0you=C2=A0re-confirm=C2=A0details.
Your=C2=A0personal=C2=A0code=C2=A0to=C2=A0the=C2=A0box=C2=A0is=C2=A0XLA2149=
2014SD,=C2=A0and=C2=A0the=C2=A0color=C2=A0is=C2=A0silver.=C2=A0NB
indicate=C2=A0this=C2=A0code=C2=A0to=C2=A0the=C2=A0diplomat=C2=A0David=C2=
=A0Mous,=C2=A0so=C2=A0that=C2=A0he=C2=A0can=C2=A0know
that=C2=A0you=C2=A0are=C2=A0the=C2=A0rightful=C2=A0owner=C2=A0of=C2=A0the=
=C2=A0box.=C2=A0you=C2=A0can=C2=A0Contact=C2=A0him=C2=A0with=C2=A0this
Email
davidmous77@gmail.com
Contact=C2=A0him=C2=A0with=C2=A0the=C2=A0information=C2=A0listed=C2=A0below

Reconfirm=C2=A0your=C2=A0current=C2=A0information=C2=A0as=C2=A0requested=C2=
=A0below

Beneficiary=C2=A0Name..........
Country.................
City.....................
Current=C2=A0address...........
Nearest=C2=A0airport...........
Direct=C2=A0phone=C2=A0number.......
I.d=C2=A0copy................

Best=C2=A0regard


Dr=C2=A0Victoria=C2=A0Douglas
