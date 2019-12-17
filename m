Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BC712258B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 08:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLQHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 02:35:31 -0500
Received: from mx4.pb.gov.br ([200.164.109.76]:38536 "HELO mx4.pb.gov.br"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1725893AbfLQHfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 02:35:30 -0500
X-Greylist: delayed 840 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 02:35:20 EST
Received: from localhost (localhost [127.0.0.1])
        by mx4.pb.gov.br (Postfix) with ESMTP id DCE613A641;
        Tue, 17 Dec 2019 04:21:17 -0300 (-03)
X-Virus-Scanned: Debian amavisd-new at mx1.pb.gov.br
Received: from mx4.pb.gov.br ([127.0.0.1])
        by localhost (mx4.pb.gov.br [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HfbOPH38N6tl; Tue, 17 Dec 2019 04:21:17 -0300 (-03)
Received: from gerencia.webmail.pb.gov.br (newmail.pb.gov.br [200.164.109.75])
        by mx4.pb.gov.br (Postfix) with ESMTPS id C75B63A63B;
        Tue, 17 Dec 2019 04:21:15 -0300 (-03)
Received: from localhost (localhost [127.0.0.1])
        by gerencia.webmail.pb.gov.br (Postfix) with ESMTP id 04C3438030C;
        Tue, 17 Dec 2019 04:21:16 -0300 (BRT)
Received: from gerencia.webmail.pb.gov.br ([127.0.0.1])
        by localhost (gerencia.webmail.pb.gov.br [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id tdDwNct-mIr7; Tue, 17 Dec 2019 04:21:15 -0300 (BRT)
Received: from localhost (localhost [127.0.0.1])
        by gerencia.webmail.pb.gov.br (Postfix) with ESMTP id 8496B380388;
        Tue, 17 Dec 2019 04:21:12 -0300 (BRT)
DKIM-Filter: OpenDKIM Filter v2.10.3 gerencia.webmail.pb.gov.br 8496B380388
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ses.pb.gov.br;
        s=DF097E4A-2002-11E9-B7D5-D974AFC91483; t=1576567273;
        bh=KgUgQlfJbej+DHIgSE4SItT35/zGnbGQcdhxQCPkNcU=;
        h=Date:From:Message-ID:MIME-Version;
        b=nsXX9KQWYCSJ3mGPmdR5A0A2UvaSWRJyXYEyE7pgShneu3vyZAkHJDxo5bHKhGqBh
         fU78oyfw2IR0HvpG+yWnFqCxw9+5kV2nLMAAIPmAe1EecsS3AFNC7DmOeuKK4x4O2p
         Ik4MyJhu4ExWJOdO+4XaHZM3NxVzzEQkUB+5wBPZVV/TgxAo+OQi7aPsmIjTZJKTbp
         B2sBrSFVoYlYPinq+bAU41mCH5P8rahEu30byZ5a0meZkVx41tAFErg9mmnBj7Q9t5
         XQSAlhS6KBOzIg/i7FDDEzA+NLxrOwVe5RNAyjphS8VGNMqMx3prxrS+JwJ4F+N1PF
         xaEYy2VZv9Gqw==
X-Virus-Scanned: amavisd-new at gerencia.webmail.pb.gov.br
Received: from gerencia.webmail.pb.gov.br ([127.0.0.1])
        by localhost (gerencia.webmail.pb.gov.br [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YxuXiACmt3XR; Tue, 17 Dec 2019 04:21:10 -0300 (BRT)
Received: from gerencia.webmail.pb.gov.br (localhost [127.0.0.1])
        by gerencia.webmail.pb.gov.br (Postfix) with ESMTP id 47B10380006;
        Tue, 17 Dec 2019 04:20:52 -0300 (BRT)
Date:   Tue, 17 Dec 2019 04:20:52 -0300 (BRT)
From:   Luisa Adams <fernanda.medeiros@ses.pb.gov.br>
Reply-To: Luisa Adams <fundingcirclelimited19@gmail.com>
Message-ID: <1944025404.12349315.1576567252226.JavaMail.zimbra@ses.pb.gov.br>
Subject: hallo
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [200.164.109.74]
X-Mailer: Zimbra 8.8.15_GA_3847 (zclient/8.8.15_GA_3847)
X-Authenticated-User: fernanda.medeiros@ses.pb.gov.br
Thread-Index: eYmuBPxegjM0hg9nMXLBPhoN5XlFog==
Thread-Topic: hallo
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Gr=C3=BC=C3=9Fe an alle da!

Dies ist Luisa Adams von FUNDING CIRCLE LTD mit Sitz in Gro=C3=9Fbritannien=
. Wir sind hier, um Ihre finanziellen Probleme zu l=C3=B6sen: Haben Sie une=
rwartete Kosten? Pers=C3=B6nliche Darlehen? Autokredite? Heimwerker? F=C3=
=BCr weitere Informationen gehen Sie zu einem Darlehen, um uns zu kaufen:

Kontaktieren Sie uns per E-Mail, wenn Sie an unseren Dienstleistungen inter=
essiert sind: fundscirclelimited@gmail.com.

Vollst=C3=A4ndiger Name:
Darlehen
Dauer:
Land:

Vielen Dank,




