Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F0946139A
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377317AbhK2LNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354197AbhK2LLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:11:30 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39E1C08EC68
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:23:17 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id r26so43175456lfn.8
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=0DHWLEyjPMueXZH7PbEr8BqcKt0Odu86Wt7qYO+bGqw=;
        b=IMnuNNOVCQ8AwtpNKBF3pqoVBCSBayoOkE9Tq2sioZ//dUYHNnQqreApIcSEgePC5P
         rYOoFvduI9LDTjb24WZuteBHYgaUDQJbUHL+xECUXV6mxgdc7wcbfG8ED/LuqpxlpCRX
         xcXz9GjvPbr3U8aMBooIKYh2HxO/DscX7vRrFGxm/oGsqNZcp+7Viq4PktzMPSPP93CP
         ICzz3NrtVggPC1D0gSepghsrysxCEW6OBMGamcRGq39b7EMOiRRjti3DGvwWTExtoESZ
         hKz8TcQfw4LsE7htvPh4q/rGKXs4/hX9x84TH+0D5Io7owDHv/Zv8Bsf6xMvZBRfw4IZ
         mGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=0DHWLEyjPMueXZH7PbEr8BqcKt0Odu86Wt7qYO+bGqw=;
        b=coHrpZ71ESW3IFS8L2f4ARQ0zIQo5Rulg6N40R7ZDM0a0cZkB9ROPcDZBrdqchxpHW
         JgY7HElnsD/w0PSDlUWdzBwB+QuUHTK/AfatAYpFpmAIEvWQQr8HogtmsugjE2vKX+qo
         AuS3n5EJa8PeWrR5XtjwIRqnNgYfnW8raNIdLRiE4s4MZXMFmLF2LsyZr6isrgu/YziR
         b5gUmOTPZ9vkDzKLysSSyDSoC+exG/+I4d5NNPl3wJ0Oyyoho5fGivIllGJ9oWBgZP1U
         1NRJ6YssQG0s2UULcVvW0CFRwaeROGxNwSfAQnEBUp5IFpK7U5ypJ7f1/l2h9vFjhdCC
         1mWA==
X-Gm-Message-State: AOAM531Yf5fUCxZgh8/UTlMxiHjAR7tqbdhmsKB8PnjJHJIq5hV4jWMw
        OLPaqFMEPxtKEbA8GuxnEH+H3ibesHnzWYWFUGs=
X-Google-Smtp-Source: ABdhPJxK/NK+dyckB1JzLeUpYOocZQ32LKQOWLdfj+D1KydRGU23XOvG4h5ngtsrv5S6y7UPtwJdU4y9MGJS66RBqVo=
X-Received: by 2002:ac2:4ad9:: with SMTP id m25mr47234631lfp.193.1638181396048;
 Mon, 29 Nov 2021 02:23:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6512:308e:0:0:0:0 with HTTP; Mon, 29 Nov 2021 02:23:15
 -0800 (PST)
Reply-To: bintou_deme2011@aol.com
From:   Bintou Deme <sm8199101@gmail.com>
Date:   Mon, 29 Nov 2021 10:23:15 +0000
Message-ID: <CAGmzi6dMdkN=_7-cYRG8A33AdEryW4Ky2BO6E72k9+MFxU8dBA@mail.gmail.com>
Subject: Von Bintou
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Von: Bintou Deme Liebste, Guten Tag und vielen Dank f=C3=BCr Ihre
Aufmerksamkeit. Bitte, ich m=C3=B6chte, dass Sie meine E-Mail sorgf=C3=A4lt=
ig lesen
und mir helfen, dieses Projekt zu bearbeiten. Ich bin Miss Bintou Deme und
m=C3=B6chte Sie in aller Bescheidenheit um Ihre Partnerschaft und Unterst=
=C3=BCtzung
bei der =C3=9Cbertragung und Anlage meiner Erbschaftsgelder in H=C3=B6he vo=
n
6.500.000,00 US-Dollar (sechs Millionen f=C3=BCnfhunderttausend US-Dollar)
bitten, die mein verstorbener geliebter Vater vor seinem Tod bei einer Bank
hinterlegt hat. Ich m=C3=B6chte Ihnen versichern, dass dieser Fonds legal v=
on
meinem verstorbenen Vater erworben wurde und keinen kriminellen Hintergrund
hat. Mein Vater hat diesen Fonds legal durch ein legitimes Gesch=C3=A4ft
erworben, bevor er w=C3=A4hrend seiner Gesch=C3=A4ftsreise zu Tode vergifte=
t wurde.
Der Tod meines Vaters wurde von seinen Verwandten, die ihn w=C3=A4hrend sei=
ner
Dienstreise begleiteten, vermutet. Denn nach 3 Monaten nach dem Tod meines
Vaters begannen Seine Verwandten, alle Besitzt=C3=BCmer meines verstorbenen
Vaters zu beanspruchen und zu verkaufen. Die Verwandten meines verstorbenen
Vaters wissen nichts von den 6.500.000,00 US-Dollar (sechs Millionen
f=C3=BCnfhunderttausend US-Dollar), die mein verstorbener Vater auf die Ban=
k
eingezahlt hat und mein verstorbener Vater sagte mir heimlich, bevor er
starb, dass ich in jedem Land nach einem ausl=C3=A4ndischen Partner suchen
sollte meiner Wahl, wohin ich diese Gelder f=C3=BCr meine eigenen Zwecke
=C3=BCberweise. Bitte helfen Sie mir, dieses Geld f=C3=BCr gesch=C3=A4ftlic=
he Zwecke in
Ihrem Land auf Ihr Konto zu =C3=BCberweisen. Ich habe diese Entscheidung
getroffen, weil ich viele Dem=C3=BCtigungen von den Verwandten meines
verstorbenen Vaters erlitten habe. Zur Zeit habe ich Kommunikation mit dem
Direktor der Bank, bei der mein verstorbener Vater dieses Geld hinterlegt
hat. Ich habe dem Direktor der Bank die Dringlichkeit erkl=C3=A4rt,
sicherzustellen, dass das Geld ins Ausland =C3=BCberwiesen wird, damit ich
dieses Land zu meiner Sicherheit verlassen kann. Der Direktor der Bank hat
mir zugesichert, dass das Geld =C3=BCberwiesen wird, sobald ich jemanden
vorlege, der den Geldbetrag in meinem Namen f=C3=BCr diesen Zweck ehrlich
entgegennimmt. Seien Sie versichert, dass die Bank den Betrag auf Ihr Konto
=C3=BCberweist und es keine Probleme geben wird. Diese Transaktion ist 100%
risikofrei und legitim. Ich bin bereit, Ihnen nach erfolgreicher
=C3=9Cberweisung dieses Geldes auf Ihr Konto 30% der Gesamtsumme als
Entsch=C3=A4digung f=C3=BCr Ihren Aufwand anzubieten. Sie werden mir auch h=
elfen, 10%
an Wohlt=C3=A4tigkeitsorganisationen und Heime f=C3=BCr mutterlose Babys in=
 Ihrem
Land zu spenden. Bitte alles, was ich m=C3=B6chte, ist, dass Sie f=C3=BCr m=
ich als
mein ausl=C3=A4ndischer Partner auftreten, damit die Bank dieses Geld auf I=
hr
Konto =C3=BCberweist, damit ich in diesem Land leben kann. Bitte, ich brauc=
he
Ihre dringende Hilfe wegen meines jetzigen Zustands. Mit Ihrer vollen
Zustimmung, mit mir zu diesem Zweck zusammenzuarbeiten, bekunden Sie bitte
Ihr Interesse durch eine R=C3=BCckantwort an mich, damit ich Ihnen die
notwendigen Informationen und die Details zum weiteren Vorgehen gebe. Ich
werde Ihnen 30% des Geldes f=C3=BCr Ihre Hilfe anbieten und Hilfestellung, =
damit
umzugehen. Ihre dringende Antwort wird gesch=C3=A4tzt. Mit freundlichen Gr=
=C3=BC=C3=9Fen
Bintou Deme
