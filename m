Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D52317A3A8
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 12:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgCELGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 06:06:51 -0500
Received: from ulan.pagasa.dost.gov.ph ([202.90.128.205]:45338 "EHLO
        mailgw.pagasa.dost.gov.ph" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725953AbgCELGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 06:06:51 -0500
X-Greylist: delayed 1224 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 06:06:50 EST
Received: from webmail.pagasa.dost.int ([10.10.11.8])
        by mailgw.pagasa.dost.gov.ph  with ESMTP id 025Aig2M006237-025Aig2O006237
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 5 Mar 2020 18:44:42 +0800
Received: from localhost (localhost [127.0.0.1])
        by webmail.pagasa.dost.int (Postfix) with ESMTP id 8128A2981670;
        Thu,  5 Mar 2020 18:35:17 +0800 (PST)
Received: from webmail.pagasa.dost.int ([127.0.0.1])
        by localhost (webmail.pagasa.dost.int [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 0MOUjDXd6_Qm; Thu,  5 Mar 2020 18:35:17 +0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by webmail.pagasa.dost.int (Postfix) with ESMTP id 78682298172F;
        Thu,  5 Mar 2020 18:35:16 +0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 webmail.pagasa.dost.int 78682298172F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pagasa.dost.gov.ph;
        s=96B9A03E-48B0-11EA-A7E8-92F42F537CE2; t=1583404516;
        bh=RC75T5p3JPNk7JUNB+lH0UfaFQO1Ac584gPL3SIL6h8=;
        h=Date:From:Message-ID:MIME-Version;
        b=QluOTNSzd9MxZ3z5lXtzgy3ErulKQfaKIVDpIg0OtI5bKQHL8j3sEaWb/Pt9ws9mZ
         zTNyFJS78Fhk6rNB6CuPPDu1dQbe7H5qYUEx5S4ZV2DiOOEdf/PlbuJRihnRJ7is85
         MxV5E6fUqirQYY0a3trUXQtGDi5BT8f+TBx8xPXc=
X-Virus-Scanned: amavisd-new at pagasa.dost.int
Received: from webmail.pagasa.dost.int ([127.0.0.1])
        by localhost (webmail.pagasa.dost.int [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 03X5Z3ZNVI5Y; Thu,  5 Mar 2020 18:35:16 +0800 (PST)
Received: from webmail.pagasa.dost.int (webmail.pagasa.dost.int [10.11.1.8])
        by webmail.pagasa.dost.int (Postfix) with ESMTP id 848F42981681;
        Thu,  5 Mar 2020 18:35:14 +0800 (PST)
Date:   Thu, 5 Mar 2020 18:35:14 +0800 (PST)
From:   "Juanito S. Galang" <juanito.galang@pagasa.dost.gov.ph>
Message-ID: <1203625487.3574237.1583404514499.JavaMail.zimbra@pagasa.dost.gov.ph>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.15_GA_3899 (ZimbraWebClient - GC79 (Win)/8.8.15_GA_3895)
Thread-Index: g8SfOi3PEuHY16jbfKrElO9m558F3g==
Thread-Topic: 
X-FEAS-DKIM: Valid
Authentication-Results: mailgw.pagasa.dost.gov.ph;
        dkim=pass header.i=@pagasa.dost.gov.ph
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Herzlichen Gl=C3=BCckwunsch Lieber Beg=C3=BCnstigter,Sie erhalten diese E-M=
ail von der Robert Bailey Foundation. Ich bin ein pensionierter Regierungsa=
ngestellter aus Harlem und ein Gewinner des Powerball Lottery Jackpot im We=
rt von 343,8 Millionen US-Dollar. Ich bin der gr=C3=B6=C3=9Fte Jackpot-Gewi=
nner in der Geschichte der New Yorker Lotterie im US-Bundesstaat Amerika. I=
ch habe diese Lotterie am 27. Oktober 2018 gewonnen und m=C3=B6chte Sie dar=
=C3=BCber informieren, dass Google in Zusammenarbeit mit Microsoft Ihre "E-=
Mail-Adresse" auf meine Bitte, einen Spendenbetrag von 3.000.000,00 Million=
en Euro zu erhalten, =C3=BCbermittelt hat. Ich spende diese 3 Millionen Eur=
o an Sie, um den Wohlt=C3=A4tigkeitsheimen und armen Menschen in Ihrer Geme=
inde zu helfen, damit wir die Welt f=C3=BCr alle verbessern k=C3=B6nnen.Wei=
tere Informationen finden Sie auf der folgenden Website, damit Sie nicht sk=
eptisch sind
Diese Spende von 3 Mio. EUR.https://nypost.com/2018/11/14/meet-the-winner-o=
f-the-biggest-lottery-jackpot-in-new-york-history/Sie k=C3=B6nnen auch mein=
 YouTube f=C3=BCr mehr Best=C3=A4tigung aufpassen:
https://www.youtube.com/watch?v=3DH5vT18Ysavc
Bitte beachten Sie, dass alle Antworten an (robertdonation7@gmail.com=C2=A0=
 ) gesendet werden, damit wir das k=C3=B6nnen
Fahren Sie fort, um das gespendete Geld an Sie zu =C3=BCberweisen.E-Mail: r=
obertdonation7@gmail.comFreundliche Gr=C3=BC=C3=9Fe,
Robert Bailey
* * * * * * * * * * * * * * * *
Powerball Jackpot Gewinner
