Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C2C2352C4
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 16:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgHAOiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 10:38:20 -0400
Received: from fenix.talca.cl ([190.13.160.40]:47314 "EHLO fenix.talca.cl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgHAOiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 10:38:20 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Aug 2020 10:38:19 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by fenix.talca.cl (Postfix) with ESMTP id 01B0D864313;
        Sat,  1 Aug 2020 10:31:35 -0400 (-04)
Received: from fenix.talca.cl ([127.0.0.1])
        by localhost (fenix.talca.cl [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Muj6X15yaHT3; Sat,  1 Aug 2020 10:31:34 -0400 (-04)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by fenix.talca.cl (Postfix) with ESMTP id 4AB608643D3;
        Sat,  1 Aug 2020 10:31:33 -0400 (-04)
DKIM-Filter: OpenDKIM Filter v2.10.3 fenix.talca.cl 4AB608643D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=talca.cl;
        s=E35D15BE-A0AB-11E3-8CD3-AD1989A2094F; t=1596292293;
        bh=ZYAs/FMOQ8KhhdIbZsZBO1hyIMYNOCP2gWKfMfUAYvE=;
        h=Date:From:Message-ID:MIME-Version;
        b=YJjVKrnC2PIUg5Wy4JeCfUnWsvgro+XvlzXwOe6lGPl/Pk4uU1evv3WSEOQMQ9Vac
         EvDrnsb+hi+xvP8D85fGcqfRVfk0SxgudmEU7YWqEvV6xqnArOhT6rmF1AJTAsifsl
         8mzRwkYkxbX02tpMf9ZHqyFo6bSVdw0JxgIBX0oY=
X-Virus-Scanned: amavisd-new at talca.cl
Received: from fenix.talca.cl ([127.0.0.1])
        by localhost (fenix.talca.cl [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bv2LUOHbx70G; Sat,  1 Aug 2020 10:31:33 -0400 (-04)
Received: from fenix.talca.cl (fenix.talca.cl [10.21.0.253])
        by fenix.talca.cl (Postfix) with ESMTP id 98575862AF2;
        Sat,  1 Aug 2020 10:31:31 -0400 (-04)
Date:   Sat, 1 Aug 2020 10:31:31 -0400 (CLT)
From:   Tayeb Souami <leandro.valenzuela@talca.cl>
Reply-To: Tayebsouami278@gmail.com
Message-ID: <1750083669.1512283.1596292291579.JavaMail.zimbra@talca.cl>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.21.0.253]
X-Mailer: Zimbra 8.8.12_GA_3807 (zclient/8.8.12_GA_3807)
Thread-Index: cDgTbCq09yJmL8CqoerZtHccXBMFIg==
Thread-Topic: 
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Ahoj!Jmenuji se Tayeb Souami, k=C5=99es=C5=A5ansk=C3=BD a americk=C3=BD ob=
=C4=8Dan. =C5=BD=C3=A1d=C3=A1m v=C3=A1s o svolen=C3=AD sv=C4=9B=C5=99it spo=
le=C4=8Denskou a humanit=C3=A1rn=C3=AD misi ve va=C5=A1=C3=AD zemi proveden=
=C3=ADm mal=C3=A9ho vyhled=C3=A1v=C3=A1n=C3=AD ve vyhled=C3=A1v=C3=A1n=C3=
=AD Google, kter=C3=A9 jsem p=C5=99ekro=C4=8Dil va=C5=A1i e-mailovou adresu=
.=C4=8Cek=C3=A1m na va=C5=A1i odpov=C4=9B=C4=8F, abych v=C3=A1m dal dal=C5=
=A1=C3=AD podrobnosti.D=C4=9Bkuji mnohokr=C3=A1t.Tayeb Souami.
