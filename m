Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D56A2C73F2
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389150AbgK1Vtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731492AbgK1Sw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:52:58 -0500
X-Greylist: delayed 3156 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 27 Nov 2020 23:35:15 PST
Received: from vmse01.mailcluster.com.au (vmse01.mailcluster.com.au [IPv6:2401:fc00:2:13f::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6E3C094276
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 23:35:15 -0800 (PST)
Received: from vmcp06.digitalpacific.com.au ([101.0.112.229])
        by vmse01.mailcluster.com.au with esmtps (TLSv1.2:AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <eavicoma@vmcp06.digitalpacific.com.au>)
        id 1kitwF-00063F-SV
        for netdev@vger.kernel.org; Sat, 28 Nov 2020 17:42:35 +1100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=vmcp06.digitalpacific.com.au; s=default; h=Content-Type:
        Content-Transfer-Encoding:MIME-Version:Message-ID:From:Date:Subject:To:Sender
        :Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=8nx9MFpIRDeGhhy5SZM2EHOqKeno45Yg8wrNTCcNWeU=; b=tEsyIahmRjwe
        tIAXD2Ha2IXSMc1Y/N8Gb+3+wuVLHVlQ4qeh6J9vhikZSMCT+IJ8HqfiRms7h671JCSQ/1fOe3FYW
        PkZXOWCzE1JZDNBel8H8NEf/1J0NmyWFhIGa/bS28VlOhG/CnK9gxTZPK8fk97S5+Fa+2iY1eVf0H
        0XgTZxBowBOGV5VFhTb9+eGroqeQ5t2wgnINialAlsjEldESeTUZvp7FxODVBI81M09UTNxGaGvnd
        diWqMSAQLwx5ax5ArOzPR4R4cZcpefX7E9jfGqbvlnh2ca6PdBvPVpjhmOZtTjdnj6kZEC8sMd3t3
        Ed6jDX5VXknSft2sLBS19A==;
Received: from eavicoma by vmcp06.digitalpacific.com.au with local (Exim 4.93)
        (envelope-from <eavicoma@vmcp06.digitalpacific.com.au>)
        id 1kitwF-003YC0-Da
        for netdev@vger.kernel.org; Sat, 28 Nov 2020 17:42:31 +1100
To:     netdev@vger.kernel.org
Subject: [Shared Post] Home
X-PHP-Script: eavi.com.au/index.php for 82.103.116.126
X-PHP-Filename: /home/eavicoma/public_html/index.php REMOTE_ADDR: 82.103.116.126
Date:   Sat, 28 Nov 2020 06:42:31 +0000
From:   WordPress <wordpress@eavi.com.au>
Message-ID: <a1104ccc7fc879f265474cc26a5338ff@eavi.com.au>
X-Priority: 3
X-Mailer: PHPMailer (phpmailer.sourceforge.net) [version 2.0.4]
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-Originating-User: eavicoma
X-Originating-IP: 101.0.112.229
X-SpamExperts-Domain: digipac-sh-outbound0.mailcluster.com.au
X-SpamExperts-Username: 101.0.112.229
Authentication-Results: mailcluster.com.au; auth=pass smtp.auth=101.0.112.229@digipac-sh-outbound0.mailcluster.com.au
X-SpamExperts-Outgoing-Class: unsure
X-SpamExperts-Outgoing-Evidence: Combined (0.69)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0fJVsTFCFA1YlcTpjJcy6PSpSDasLI4SayDByyq9LIhV+Y0aAJ1ov1cq
 rAKrHkMi2kTNWdUk1Ol2OGx3IfrIJKywOmJyM1qr8uRnWBrbSAGDesseJUSjHz/88doLK5oKLCh4
 MK0k2uSGCYA7tfg2EIGE1rCW5JKrbuIOG+DdmlVHBMmyNbDn7R5kilAhwr3KtPRgtEKbbJiCf5yI
 2OixqpvpOGYDFnHfMfQ7HGf9HLkr6UTw0jTdDsh1dRVJBuLpYVNwYzVIo6KuHW8hVCQ7X76nPJMw
 iMmGDIAGwZKDDgC5V285Rg4HPV7XsztaaZW8YBkhzVJFWn887ct0NFXnFWKxnGmiI3p9NEdyvIai
 1RA3FPo67MEDuAALBU22yFTfTrvatWWiSP0Jxll7g1bGZi2rTLMTNniiMz1OAmb0Fz3NgrbPA+uI
 mOx9H2/gNYfuQNVCH58aHMOgJq49wVbzS8obDOdTMnvHqOmP4VxBW3PTCJuKmef1JCbmfgcv6zoJ
 wP+UUGE9pQOAAWlE+d5fWPyh2Dwf8plwptnx2pP0zfML0nALJ/SZ21tCHNSdoVdATYlSPGIn6LIh
 6vfZt6Tuc+uVfVL7ygxIxIEhQBgsu7ia6J1fhOzjF0b4LXcjJZ5lojs9WothUdTRGM+OK01jR2FT
 fj9Yy85rYwAPLNuau5MAUzRhidNRALGXuhKPQHGzKCTKelypEvEJvDCVKhdgOiEKmWM+8ftVwkKw
 27c7JqOyh1UcgPifqs9Z1959MOfpvMqtCru1poKZB7eNIruIcksmgo38I2WwKZqfJvB/ak2L0oqe
 UC8lAaqwC32/9Vd70EK5NuprBzu3LLHsov485niRmv+9A6chZRtUAs48HmyAIbtf63VNbf0lrvss
 Y+k7ACEuuc9n2iE8XDvKl8FdZy9JhWJQUPuZVFhkI9SEXS8+/vEZGKDVhQEd6lEOrnME+bakVnCS
 c+Ypc/Pypso1H9ugcRBJ/ZgqLqeUwG0R12svmEDJ7jgeHcJTevWg8+R1jgFehep93Fnpexz1pshK
 rgJ73n4rNOK4erw+M/WuBl/lU4k/ZfFdMgzqdIfIg9DUOOICUTIqG9GP/0y/T4/wTA+aCw5Hn2sA
 2GefVUqTY2dxMS+4ayUpOtEhdxekWDmK9g==
X-Report-Abuse-To: spam@vmse01.mailcluster.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

💖 Secret meetings and single girls are waiting for you. Answer me here: http://bit.do/fLrNf?oxlow 💖 (netdev@vger.kernel.org) thinks you may be interested in the following post:

Home
http://eavi.com.au/

