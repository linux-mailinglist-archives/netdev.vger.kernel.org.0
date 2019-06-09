Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD563ABA5
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 21:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfFIT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 15:29:17 -0400
Received: from mtax.cdmx.gob.mx ([187.141.35.197]:9333 "EHLO mtax.cdmx.gob.mx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbfFIT3R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jun 2019 15:29:17 -0400
X-NAI-Header: Modified by McAfee Email Gateway (4500)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cdmx.gob.mx; s=72359050-3965-11E6-920A-0192F7A2F08E;
        t=1560106430; h=DKIM-Filter:X-Virus-Scanned:
         Content-Type:MIME-Version:Content-Transfer-Encoding:
         Content-Description:Subject:To:From:Date:Reply-To:
         Message-Id:X-AnalysisOut:X-AnalysisOut:X-AnalysisOut:
         X-AnalysisOut:X-AnalysisOut:X-AnalysisOut:
         X-SAAS-TrackingID:X-NAI-Spam-Flag:X-NAI-Spam-Threshold:
         X-NAI-Spam-Score:X-NAI-Spam-Rules:X-NAI-Spam-Version;
        bh=U0Muiz5ECa3gaTzMJe13Eshf2iywdDpIp+lqwE
        FBq5U=; b=YaV5N2nLheCWWULJ5mxrhmEuGuO/dEFQROM8ySsS
        5MuRb6DIFnLvQqZ+G8YAEFQ7e0e8GqsqIbpF5kis4u40yh41j8
        f8rFAUWGiV+noXs5sH7RvrvoOqg3+zC4gGEOoSLOEhDTQYg05x
        s6OYULmrfFKCddkYqlC+yM3XNcArcM4=
Received: from cdmx.gob.mx (unknown [10.250.108.150]) by mtax.cdmx.gob.mx with smtp
        (TLS: TLSv1/SSLv3,256bits,ECDHE-RSA-AES256-GCM-SHA384)
         id 03b6_91a6_3f6b3ab1_737a_473d_b80b_af1ea46d6a7a;
        Sun, 09 Jun 2019 13:53:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by cdmx.gob.mx (Postfix) with ESMTP id D7037301335;
        Sun,  9 Jun 2019 12:50:43 -0500 (CDT)
Received: from cdmx.gob.mx ([127.0.0.1])
        by localhost (cdmx.gob.mx [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AaY8IsfxZH9c; Sun,  9 Jun 2019 12:50:43 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by cdmx.gob.mx (Postfix) with ESMTP id 5D12B2C0AE5;
        Sun,  9 Jun 2019 10:42:53 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.9.2 cdmx.gob.mx 5D12B2C0AE5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cdmx.gob.mx;
        s=72359050-3965-11E6-920A-0192F7A2F08E; t=1560094973;
        bh=U0Muiz5ECa3gaTzMJe13Eshf2iywdDpIp+lqwEFBq5U=;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:Subject:To:
         From:Date:Reply-To:Message-Id;
        b=xTrvY0jCzJrp4Y5de35I/f9TrGJSpXVkkTeck8sl00z2jLncFumV0qNB2Xz0tKWcl
         mO2AfXULq2/iJRBQnKiS//QUZMLpMLHz9pbjHmgmX/Lvf+3BSUDEKiM6Vf7nO8CODD
         At06TwlCZ6jims1TEBz2nxdtCAWzkz0J8UE5zFVU=
X-Virus-Scanned: amavisd-new at cdmx.gob.mx
Received: from cdmx.gob.mx ([127.0.0.1])
        by localhost (cdmx.gob.mx [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZraiZJ-9b-hQ; Sun,  9 Jun 2019 10:42:53 -0500 (CDT)
Received: from [51.38.116.193] (ip193.ip-51-38-116.eu [51.38.116.193])
        by cdmx.gob.mx (Postfix) with ESMTPSA id DDCF91E63C6;
        Sun,  9 Jun 2019 10:17:42 -0500 (CDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?b?4oKsIDIuMDAwLjAwMCwwMCBFdXJv?=
To:     Recipients <cilpinez@cdmx.gob.mx>
From:   cilpinez@cdmx.gob.mx
Date:   Sun, 09 Jun 2019 08:17:44 -0700
Reply-To: johnwalterlove2010@gmail.com
Message-Id: <20190609151742.DDCF91E63C6@cdmx.gob.mx>
X-AnalysisOut: [v=2.2 cv=Qtku5R6d c=1 sm=1 tr=0 p=d_9A9YPZgCEA:10 p=UhPmRW]
X-AnalysisOut: [QW4yN_uUvCwugA:9 p=Ner0o0mvyuUA:10 p=CwrrfTYHidcoWUP_FusY:]
X-AnalysisOut: [22 p=Z3hVr4-9LPz_iBwj1Snb:22 a=T6zFoIZ12MK39YzkfxrL7A==:11]
X-AnalysisOut: [7 a=o6exIZH9ckoXPxROjXgmHg==:17 a=IkcTkHD0fZMA:10 a=x7bEGL]
X-AnalysisOut: [p0ZPQA:10 a=dq6fvYVFJ5YA:10 a=pGLkceISAAAA:8 a=QEXdDO2ut3Y]
X-AnalysisOut: [A:10 a=uXetiwfYVjQA:10]
X-SAAS-TrackingID: bd55dfc5.0.366238238.00-2272.626104784.s12p02m004.mxlogic.net
X-NAI-Spam-Flag: NO
X-NAI-Spam-Threshold: 3
X-NAI-Spam-Score: -5000
X-NAI-Spam-Rules: 1 Rules triggered
        WHITELISTED=-5000
X-NAI-Spam-Version: 2.3.0.9418 : core <6564> : inlines <7098> : streams
 <1824010> : uri <2854338>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ich bin Herr Richard Wahl der Mega-Gewinner von $ 533M In Mega Millions Jac=
kpot spende ich an 5 zuf=C3=A4llige Personen, wenn Sie diese E-Mail erhalte=
n, dann wurde Ihre E-Mail nach einem Spinball ausgew=C3=A4hlt. Ich habe den=
 gr=C3=B6=C3=9Ften Teil meines Verm=C3=B6gens auf eine Reihe von Wohlt=C3=
=A4tigkeitsorganisationen und Organisationen verteilt. Ich habe mich freiwi=
llig dazu entschieden, Ihnen den Betrag von =E2=82=AC 2.000.000,00 zu spend=
en eine der ausgew=C3=A4hlten 5, um meine Gewinne zu =C3=BCberpr=C3=BCfen. =
Das ist dein Spendencode: [DF00430342018] Antworten Sie mit dem Spendencode=
 auf diese E-Mail: richardpovertyorg@gmail.com
