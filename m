Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6A110E818
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfLBKCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:02:25 -0500
Received: from castroalves.fundaj.gov.br ([200.17.132.4]:33178 "EHLO
        castroalves.fundaj.gov.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfLBKCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 05:02:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by castroalves.fundaj.gov.br (Postfix) with ESMTP id C5E1D13DFC8;
        Mon,  2 Dec 2019 07:07:43 -0300 (-03)
Received: from castroalves.fundaj.gov.br ([127.0.0.1])
        by localhost (castroalves.fundaj.gov.br [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 9H1IibwC-XvG; Mon,  2 Dec 2019 07:07:43 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by castroalves.fundaj.gov.br (Postfix) with ESMTP id 5783C13DFD3;
        Mon,  2 Dec 2019 07:07:42 -0300 (-03)
DKIM-Filter: OpenDKIM Filter v2.10.3 castroalves.fundaj.gov.br 5783C13DFD3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fundaj.gov.br;
        s=25700E94-2A59-11E8-8390-8ACCB82071DA; t=1575281262;
        bh=N+zlvZNOQPdiiSiRfZ/nBQo1LlXqGcp7h2zXFL4jvyc=;
        h=Date:From:Message-ID:MIME-Version;
        b=B8i2oUWIwFivcx+C7WULR/3kPXVdNdaY2Hlunv8n0vI+k9k3EljOWZudxqeAt7mzT
         B/sLwLWwkj2QDPcLS+LuvxKI8LoJkGclW2u1LwbW8iNUr5K4epVVyCVP0wGvGXFtch
         2ju7Pl9gPopo/iNmGfgMp+YIVd92+6bq3r36Hiw06C6pK6u5QO0mFpLIhDXyFHUMX4
         I+81We46rOyGFxlSddjdBG9QZr6oqWJfxlvNF0EwYZmLbkmhToE4NbFlCxSn3WjUMs
         gK1AX5JMGz9cU7T9tTxabXZniC7MyK6xwepNtOS4zLTn4j0nvG8eMuoINiifyWERj6
         tNjX59+ebzD6Q==
X-Virus-Scanned: amavisd-new at fundaj.gov.br
Received: from castroalves.fundaj.gov.br ([127.0.0.1])
        by localhost (castroalves.fundaj.gov.br [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id K-8NA6ufmMuL; Mon,  2 Dec 2019 07:07:42 -0300 (-03)
Received: from castroalves.fundaj.gov.br (castroalves.fundaj.gov.br [192.168.1.4])
        by castroalves.fundaj.gov.br (Postfix) with ESMTP id 3B34A13DFB9;
        Mon,  2 Dec 2019 07:07:22 -0300 (-03)
Date:   Mon, 2 Dec 2019 07:07:22 -0300 (BRT)
From:   =?utf-8?B?0KHQuNGB0YLQtdC80L3Ri9C5INCw0LTQvNC40L3QuNGB0YLRgNCw0YLQvtGA?= 
        <jaime.ramos@fundaj.gov.br>
Reply-To: mailsss@mail2world.com
Message-ID: <1805881940.1785315.1575281242190.JavaMail.zimbra@fundaj.gov.br>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Originating-IP: [106.210.3.121]
X-Mailer: Zimbra 8.8.8_GA_3025 (zclient/8.8.8_GA_3025)
Thread-Index: 8PEDbVV24lYAHf419CBMzdgAFCyxlQ==
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
