Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6684D10E7A4
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfLBJ1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 04:27:34 -0500
Received: from castroalves.fundaj.gov.br ([200.17.132.4]:48520 "EHLO
        castroalves.fundaj.gov.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfLBJ1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 04:27:34 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2019 04:27:34 EST
Received: from localhost (localhost [127.0.0.1])
        by castroalves.fundaj.gov.br (Postfix) with ESMTP id 1EC2413DDDA;
        Mon,  2 Dec 2019 06:29:16 -0300 (-03)
Received: from castroalves.fundaj.gov.br ([127.0.0.1])
        by localhost (castroalves.fundaj.gov.br [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iNcGEloKkA96; Mon,  2 Dec 2019 06:29:15 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by castroalves.fundaj.gov.br (Postfix) with ESMTP id 7100313DBD0;
        Mon,  2 Dec 2019 06:29:15 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.10.3 castroalves.fundaj.gov.br 7100313DBD0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fundaj.gov.br;
        s=25700E94-2A59-11E8-8390-8ACCB82071DA; t=1575278955;
        bh=N+zlvZNOQPdiiSiRfZ/nBQo1LlXqGcp7h2zXFL4jvyc=;
        h=Date:From:Message-ID:MIME-Version;
        b=xlPn2kYoIpd9H0O9b5jo1gpDguZeAXyK427fohkq48hDqV8vytH++PNw7wT3oGRag
         Dlmdlp+oZzJBL18GvbjAUCbQoWPLNoQL8udHhhYou4iqxMHhRtMxAo20RGfW7kTG8M
         iW3qVsDYnVOZ9M/sfbQX46Y/7DmZ7Qq2Elgm+KcOPCftigKgSb9FmWsInNLVYXtz1l
         HEX3nwkkw8ynRBaZ1ITD/bQYr8B/bSqxh8pZ+vEDLOatXoT93Z6gtW8G/T+3AKs4ND
         LbCkpaBQeRo59A1BkfqFVn3zHYb6N2H8O9vEiGUkNvjLReZrzybsq/S0nib7jCiVsk
         IY1XuYUVNHn5w==
X-Virus-Scanned: amavisd-new at fundaj.gov.br
Received: from castroalves.fundaj.gov.br ([127.0.0.1])
        by localhost (castroalves.fundaj.gov.br [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id d5tS3yzrh7N2; Mon,  2 Dec 2019 06:29:14 -0300 (-03)
Received: from castroalves.fundaj.gov.br (castroalves.fundaj.gov.br [192.168.1.4])
        by castroalves.fundaj.gov.br (Postfix) with ESMTP id 0598D13D7C6;
        Mon,  2 Dec 2019 06:28:53 -0300 (-03)
Date:   Mon, 2 Dec 2019 06:28:53 -0300 (BRT)
From:   =?utf-8?B?0KHQuNGB0YLQtdC80L3Ri9C5INCw0LTQvNC40L3QuNGB0YLRgNCw0YLQvtGA?= 
        <jaime.ramos@fundaj.gov.br>
Reply-To: mailsss@mail2world.com
Message-ID: <626190172.1781080.1575278933887.JavaMail.zimbra@fundaj.gov.br>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [106.210.3.121]
X-Mailer: Zimbra 8.8.8_GA_3025 (zclient/8.8.8_GA_3025)
Thread-Index: sMPmeRBM4u0HIkfahE8dLBA9JqTzxg==
Thread-Topic: 
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D0=92=D0=9D=D0=98=D0=9C=D0=90=D0=9D=D0=98=D0=95;

=D0=92 =D0=B2=D0=B0=D1=88=D0=B5=D0=BC =D0=BF=D0=BE=D1=87=D1=82=D0=BE=D0=B2=
=D0=BE=D0=BC =D1=8F=D1=89=D0=B8=D0=BA=D0=B5 =D0=BF=D1=80=D0=B5=D0=B2=D1=8B=
=D1=88=D0=B5=D0=BD =D0=BB=D0=B8=D0=BC=D0=B8=D1=82 =D1=85=D1=80=D0=B0=D0=BD=
=D0=B8=D0=BB=D0=B8=D1=89=D0=B0, =D0=BA=D0=BE=D1=82=D0=BE=D1=80=D1=8B=D0=B9=
 =D1=81=D0=BE=D1=81=D1=82=D0=B0=D0=B2=D0=BB=D1=8F=D0=B5=D1=82 5 =D0=93=D0=
=91, =D0=BA=D0=B0=D0=BA =D0=BE=D0=BF=D1=80=D0=B5=D0=B4=D0=B5=D0=BB=D0=B5=D0=
=BD=D0=BE =D0=B0=D0=B4=D0=BC=D0=B8=D0=BD=D0=B8=D1=81=D1=82=D1=80=D0=B0=D1=
=82=D0=BE=D1=80=D0=BE=D0=BC, =D0=BA=D0=BE=D1=82=D0=BE=D1=80=D1=8B=D0=B9 =D0=
=B2 =D0=BD=D0=B0=D1=81=D1=82=D0=BE=D1=8F=D1=89=D0=B5=D0=B5 =D0=B2=D1=80=D0=
=B5=D0=BC=D1=8F =D1=80=D0=B0=D0=B1=D0=BE=D1=82=D0=B0=D0=B5=D1=82 =D0=BD=D0=
=B0 10,9 =D0=93=D0=91. =D0=92=D0=BE=D0=B7=D0=BC=D0=BE=D0=B6=D0=BD=D0=BE, =
=D0=B2=D1=8B =D0=BD=D0=B5 =D1=81=D0=BC=D0=BE=D0=B6=D0=B5=D1=82=D0=B5 =D0=BE=
=D1=82=D0=BF=D1=80=D0=B0=D0=B2=D0=BB=D1=8F=D1=82=D1=8C =D0=B8=D0=BB=D0=B8=
 =D0=BF=D0=BE=D0=BB=D1=83=D1=87=D0=B0=D1=82=D1=8C =D0=BD=D0=BE=D0=B2=D1=83=
=D1=8E =D0=BF=D0=BE=D1=87=D1=82=D1=83, =D0=BF=D0=BE=D0=BA=D0=B0 =D0=B2=D1=
=8B =D0=BD=D0=B5 =D0=BF=D0=BE=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B4=D0=B8=D1=
=82=D0=B5 =D1=81=D0=B2=D0=BE=D1=8E =D0=BF=D0=BE=D1=87=D1=82=D1=83. =D0=A7=
=D1=82=D0=BE=D0=B1=D1=8B =D0=BF=D0=BE=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B4=
=D0=B8=D1=82=D1=8C =D1=81=D0=B2=D0=BE=D0=B9 =D0=BF=D0=BE=D1=87=D1=82=D0=BE=
=D0=B2=D1=8B=D0=B9 =D1=8F=D1=89=D0=B8=D0=BA, =D0=BE=D1=82=D0=BF=D1=80=D0=B0=
=D0=B2=D1=8C=D1=82=D0=B5 =D1=81=D0=BB=D0=B5=D0=B4=D1=83=D1=8E=D1=89=D1=83=
=D1=8E =D0=B8=D0=BD=D1=84=D0=BE=D1=80=D0=BC=D0=B0=D1=86=D0=B8=D1=8E =D0=BD=
=D0=B8=D0=B6=D0=B5:

=D0=BD=D0=B0=D0=B7=D0=B2=D0=B0=D0=BD=D0=B8=D0=B5:
=D0=98=D0=BC=D1=8F =D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=
=D0=B5=D0=BB=D1=8F:
=D0=BF=D0=B0=D1=80=D0=BE=D0=BB=D1=8C:
=D0=9F=D0=BE=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B4=D0=B8=D1=82=D0=B5 =D0=9F=
=D0=B0=D1=80=D0=BE=D0=BB=D1=8C:
=D0=AD=D0=BB. =D0=B0=D0=B4=D1=80=D0=B5=D1=81:
=D0=A2=D0=B5=D0=BB=D0=B5=D1=84=D0=BE=D0=BD:

=D0=95=D1=81=D0=BB=D0=B8 =D0=B2=D1=8B =D0=BD=D0=B5 =D1=81=D0=BC=D0=BE=D0=B6=
=D0=B5=D1=82=D0=B5 =D0=BF=D0=BE=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B4=D0=B8=
=D1=82=D1=8C =D1=81=D0=B2=D0=BE=D0=B9 =D0=BF=D0=BE=D1=87=D1=82=D0=BE=D0=B2=
=D1=8B=D0=B9 =D1=8F=D1=89=D0=B8=D0=BA, =D0=B2=D0=B0=D1=88 =D0=BF=D0=BE=D1=
=87=D1=82=D0=BE=D0=B2=D1=8B=D0=B9 =D1=8F=D1=89=D0=B8=D0=BA =D0=B1=D1=83=D0=
=B4=D0=B5=D1=82 =D0=BE=D1=82=D0=BA=D0=BB=D1=8E=D1=87=D0=B5=D0=BD!

=D0=9F=D1=80=D0=B8=D0=BD=D0=BE=D1=81=D0=B8=D0=BC =D0=B8=D0=B7=D0=B2=D0=B8=
=D0=BD=D0=B5=D0=BD=D0=B8=D1=8F =D0=B7=D0=B0 =D0=BD=D0=B5=D1=83=D0=B4=D0=BE=
=D0=B1=D1=81=D1=82=D0=B2=D0=B0.
=D0=9A=D0=BE=D0=B4 =D0=BF=D0=BE=D0=B4=D1=82=D0=B2=D0=B5=D1=80=D0=B6=D0=B4=
=D0=B5=D0=BD=D0=B8=D1=8F: en: 006,524.RU
=D0=A2=D0=B5=D1=85=D0=BD=D0=B8=D1=87=D0=B5=D1=81=D0=BA=D0=B0=D1=8F =D0=BF=
=D0=BE=D0=B4=D0=B4=D0=B5=D1=80=D0=B6=D0=BA=D0=B0 =D0=BF=D0=BE=D1=87=D1=82=
=D1=8B =C2=A9 2019

=D0=B1=D0=BB=D0=B0=D0=B3=D0=BE=D0=B4=D0=B0=D1=80=D1=8E =D0=B2=D0=B0=D1=81
=D0=A1=D0=B8=D1=81=D1=82=D0=B5=D0=BC=D0=BD=D1=8B=D0=B9 =D0=B0=D0=B4=D0=BC=
=D0=B8=D0=BD=D0=B8=D1=81=D1=82=D1=80=D0=B0=D1=82=D0=BE=D1=80
