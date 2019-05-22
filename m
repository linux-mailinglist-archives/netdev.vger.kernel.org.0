Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA0C272BE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfEVXLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:11:37 -0400
Received: from avgw.kerala.gov.in ([103.251.43.140]:52920 "EHLO
        avgw.kerala.gov.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEVXLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:11:36 -0400
X-Greylist: delayed 7180 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2019 19:11:33 EDT
Received: from avgw.kerala.gov.in (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CC7CFF706;
        Thu, 23 May 2019 02:05:24 +0530 (IST)
Received: from avgw.kerala.gov.in (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66EE8FE80E;
        Thu, 23 May 2019 02:05:24 +0530 (IST)
Received: from kite.kerala.gov.in (unknown [10.1.14.254])
        by avgw.kerala.gov.in (Postfix) with ESMTPS;
        Thu, 23 May 2019 02:05:24 +0530 (IST)
Received: from localhost (mail.kite.kerala.gov.in [127.0.0.1])
        by kite.kerala.gov.in (Postfix) with ESMTP id 081ECF00321;
        Thu, 23 May 2019 02:08:51 +0530 (IST)
Received: from kite.kerala.gov.in ([127.0.0.1])
        by localhost (mail.kite.kerala.gov.in [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id VcSB8SDokEkr; Thu, 23 May 2019 02:08:50 +0530 (IST)
Received: from localhost (mail.kite.kerala.gov.in [127.0.0.1])
        by kite.kerala.gov.in (Postfix) with ESMTP id 74702F00333;
        Thu, 23 May 2019 02:08:34 +0530 (IST)
DKIM-Filter: OpenDKIM Filter v2.10.3 kite.kerala.gov.in 74702F00333
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kite.kerala.gov.in;
        s=4DDB9C16-1548-11E8-B0E3-8CFC090FAE39; t=1558557514;
        bh=xdX1Gks1twh985vnVWJnyZD3mvs4sdm61HhbQV8P000=;
        h=Date:From:Message-ID:MIME-Version;
        b=IRCJ8Ci+b9KxUNzwyiroZL+p6Am0j4PVJJcgy5y6PxVM6+LfD2LbwZPI0eSbSXMLB
         Qy0AydkFCZzMDLSyI7cqrwklonN1vsU9ROVu2a/YOLIjfme4shJo1hB9lAGTk2N40Z
         q/sgPKC28+fjUnrVWu+7Dnvy6rr2yCGf5f0rY4T8=
X-Virus-Scanned: amavisd-new at mail.kite.kerala.gov.in
Received: from kite.kerala.gov.in ([127.0.0.1])
        by localhost (mail.kite.kerala.gov.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id karLceh6cf8H; Thu, 23 May 2019 02:08:34 +0530 (IST)
Received: from mail.kite.kerala.gov.in (mail.kite.kerala.gov.in [127.0.0.1])
        by kite.kerala.gov.in (Postfix) with ESMTP id 1EEF6F00335;
        Thu, 23 May 2019 02:08:11 +0530 (IST)
Date:   Thu, 23 May 2019 02:08:11 +0530 (IST)
From:   Mme Lilie MARTINS <tvm.saju@kite.kerala.gov.in>
Reply-To: martins.lilie626@gmail.com
Message-ID: <1835740325.1479042.1558557491003.JavaMail.zimbra@kite.kerala.gov.in>
Subject: Proposition!
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [217.146.10.218]
X-Mailer: Zimbra 8.8.9_GA_3019 (zclient/8.8.9_GA_3019)
Thread-Index: OJgpLXJ/333Nf7NA4zNQuDbH8/Kyjw==
Thread-Topic: Proposition!
To:     undisclosed-recipients:;
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1631-8.2.0.1013-24000.002
X-TM-AS-Result: No-2.332-5.0-31-10
X-imss-scan-details: No-2.332-5.0-31-10
X-TM-AS-User-Approved-Sender: No
X-TMASE-Version: IMSVA-9.1.0.1631-8.2.1013-24000.002
X-TMASE-Result: 10-2.331800-10.000000
X-TMASE-MatchedRID: H/kUi5gqYrtHQJGk1Hph9rFqYdL4PpMrd7Y+WeNB+fnhbnAZMqQsqyAk
        is7jq4ifBuB7w1USiML9XWQn53XUo501MYb9w4IJ3tJaKJZJX/XTiYKZ8XvVrb1zrBPyX0mHvXe
        Ps60Bhp2vGrgEn8xGHsXgLzaWHewVJ+sC4+0Jdlggo6w4FE5vHCZjzMarVA2FdcQmUOoq1YCONL
        EL3aLu9ydQpoIHFbIDZUAENbiGwWFJSwq58rnQukNPmWMW/PcIKpBqUyGzhQGVHaiH1ua4YQcZH
        DcgQUlk/qrsQc9mp/pftuJwrFEhTXouvKaPcX0GFQ98tXLWB2H+u3c2kKmLaF02NLODYqDa3Z6P
        60hwor3Zs3HUcS/scCq2rl3dzGQ1VEBzI08ZRUkBk/KO3YUsFMcrt5anoXyfylv4InitCe1RwBx
        VzJStWVEJS5pRUcpyAXD7wgveXU/lEBIsIWthfN3TvGN50Wtqg8CEDeewYtelPzJCUUfFsuA6i1
        91iG+A+zB71g071HJ6fJ5UskDTiUMMprcbiest
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonjour,

Je soussign=C3=A9e Mme Lilie MARTINS de nationalit=C3=A9 fran=C3=A7aise. Je=
 vous envoie ce pr=C3=A9sent message afin de solliciter votre accord pour l=
a r=C3=A9alisation d'un projet de donation. Ayant perdu mon =C3=A9poux et m=
on enfant de 8 ans au cours d'un accident tragique et mortel Il y a quelque=
s ann=C3=A9es, je n'ai ni famille ni enfant qui pourra b=C3=A9n=C3=A9ficier=
 de ma fortune.

Actuellement hospitalis=C3=A9e aux USA pour un cancer en phase terminale, j=
e d=C3=A9cide de faire don de ma fortune afin que vous puissiez r=C3=A9alis=
er les =C5=93uvres de charit=C3=A9 de votre choix.=20

Pour cela je vous l=C3=A8gue =C3=A0 titre de don.une somme de un million ci=
nq cent mille dollars am=C3=A9ricain en banque en Afrique de l=E2=80=99oues=
t o=C3=B9 je m=E2=80=99=C3=A9tais install=C3=A9e apr=C3=A8s la mort de mon =
mari et mon enfant.
Merci me de r=C3=A9pondre pour plus de d=C3=A9tails.

Sinc=C3=A8rement
Mme Lilie=20
E-mail: martins.lilie626@gmail.com
