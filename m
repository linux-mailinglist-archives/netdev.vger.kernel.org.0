Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F563E84D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 04:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiLADYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 22:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLADYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 22:24:35 -0500
X-Greylist: delayed 515 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 30 Nov 2022 19:24:31 PST
Received: from pctpxymta1.ctd.tn.gov.in (mail.ctd.tn.gov.in [164.100.134.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4BE140F8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 19:24:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by pctpxymta1.ctd.tn.gov.in (Postfix) with ESMTP id ADBA7A4217;
        Thu,  1 Dec 2022 08:44:31 +0530 (IST)
Received: from pctpxymta1.ctd.tn.gov.in ([127.0.0.1])
        by localhost (pctpxymta1.ctd.tn.gov.in [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id PqRPLpTG1os3; Thu,  1 Dec 2022 08:44:31 +0530 (IST)
Received: from localhost (localhost [127.0.0.1])
        by pctpxymta1.ctd.tn.gov.in (Postfix) with ESMTP id 77362A41D6;
        Thu,  1 Dec 2022 08:44:31 +0530 (IST)
DKIM-Filter: OpenDKIM Filter v2.10.3 pctpxymta1.ctd.tn.gov.in 77362A41D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ctd.tn.gov.in;
        s=5D52FA52-8E28-11EB-890F-40401F18B45F; t=1669864471;
        bh=qq4l1APaRBFOV8Y7JwyHpLogieHx6Q3zZ+hmqb7GxXE=;
        h=MIME-Version:To:From:Date:Message-Id;
        b=E7CD2SGXtJ+KAFShYvBoQ3btyZN2R8i3K/i2nIwZwhy32+t+wopMHD+Mx/6K1DFDC
         xWtfwjXLKoD+IS90ElfXvjnGv48pmMOgjDFN5A2yvHkbLcnu2Auwhgc5H3TImX/EWv
         mSf5/BdETxUuGt9KDOnRWrr5mdGEk9UZJxTK7+ZDuR5ehAGD5L8wZiHSqCIfwOeAL+
         6k4GzvJF3UIgfTxodIlVZMk6Kg+KBW62Tq3h+PEoea9TIdnbt9FgNS//coBH8KkMxN
         nj8ESoPLSBtJzFz0ptc+2XMzJocdvfLe0zjyC+7f518TIESJChPs5EF8vOkFxjWG0E
         T+eOIOhE6vEWQ==
X-Amavis-Modified: Mail body modified (using disclaimer) -
        pctpxymta1.ctd.tn.gov.in
X-Virus-Scanned: amavisd-new at pctpxymta1.ctd.tn.gov.in
Received: from pctpxymta1.ctd.tn.gov.in ([127.0.0.1])
        by localhost (pctpxymta1.ctd.tn.gov.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XUTWf2oi3fgm; Thu,  1 Dec 2022 08:44:31 +0530 (IST)
Received: from [172.20.10.2] (unknown [10.236.243.239])
        by pctpxymta1.ctd.tn.gov.in (Postfix) with ESMTPSA id 16849A4217;
        Thu,  1 Dec 2022 08:44:21 +0530 (IST)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Oferta pozyczki
To:     Recipients <mgrdcct.namakkal@ctd.tn.gov.in>
From:   mgrdcct.namakkal@ctd.tn.gov.in
Date:   Wed, 30 Nov 2022 19:14:12 -0800
Reply-To: andrewlogan1@outlook.com
X-Antivirus: Avast (VPS 221130-12, 11/30/2022), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20221201031422.16849A4217@pctpxymta1.ctd.tn.gov.in>
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,MIME_QP_LONG_LINE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Czy potrzebujesz zatwierdzonej pozyczki biznesowej i osobistej / finansowan=
ia o maksymalnej stopie procentowej 3% rocznie? Skontaktuj sie z nami juz d=
zis, wysylajac wiadomosc e-mail na adres (andrewlogan1@outlook.com), aby uz=
yskac wiecej informacji, jesli jestes zainteresowany.

-- 
This email has been checked for viruses by Avast antivirus software.
www.avast.com
The information contained in this mail message and/or attachments to it may contain confidential or privileged information of the Department. This message is intended only for you. If you are not the intended recipient, you are notified that disclosing, copying, distributing or taking any action in reliance on the contents of this information is strictly prohibited by the Department. If you have erroneously received this message, please immediately delete it, notify the sender and inform the Call Centre. This e-mail reply is only intended to provide clarity/explanation to the request mail. It cannot be used for any legal purposes. This e-mail is of confidential nature and intended solely for the use of the individual/entity to whom they are addressed and not binding any agreement on behalf of the department.

