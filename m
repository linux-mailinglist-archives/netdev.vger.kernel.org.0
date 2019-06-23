Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A474FA89
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 08:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfFWGqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 02:46:19 -0400
Received: from sonic311-17.consmr.mail.bf2.yahoo.com ([74.6.131.240]:42428
        "EHLO sonic311-17.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfFWGqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 02:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1561272377; bh=ASdX86yUYRsxIlZvXAdrB/RwQ9ZomONpQNmJPYz3O9E=; h=Date:From:Reply-To:Subject:References:From:Subject; b=bFDZb9QljMgoaHzyDHSM/ruHFcUwpfz+AqTUEludJytXaVFa+cDhpFcEiFQOcxzyd9XOFDdWthrqDTqVipQKhjrrlHkf9UKH7bNB9NmA4R70TqPrtXJ992/sj3KlxGipQkISK3qjmO5FLoSf2DCkOzmKC14Tp2Gfffgl+W18phxTQf51814tIsBksGdQMjvdjT0q4+ErxO27/LTMYVA8FV9cZg5+34tJjJNORz8f6eLMub3zh2Hxfl14nQu7McRDUxNPyY14tZI+H35CybHJE4GuPlReHfL+JgfPjTZ1/o4i0gFs7YH/g2Cik/YpCcLJn4lH+vEflTOVbFzQ38YbxQ==
X-YMail-OSG: 0bsF8u4VM1kptpPzMugp5KygQhss7lQHdWrFu9eKfHBk2Byux5XpmzWdjxQmpBl
 UHw5jyA2oRpsus2kb1psNN6bw2ueWKYfvL8lhEIxFPSN9CS8tfjlL0MP0NPkqrh9exrlk_YfbCeB
 cw.XM9UNhe8tyjZgIcAUSL2Sc6fSBMvIWmH.Tm0cPfxH1nkKhIdXBxtrNRxR3CPV1OswPNZALM0F
 2iyLlgdDAtEvwFmfJKVIAvu2ocpFwJ1qf3RWqdg7SydLhSKp2IJGLnfYKoaez8w56bHxPU0oMU_H
 0AdTSBeq_kuutBWFm.ccGBOdonfg4g77e0n.QEs.Jrej.ogF.Ho9I8BRi.6OYuVv2bHKylurw0IX
 TXZutVZe4fC8VDsSQRNlCWAJSlgHUViyw3WLXDYXDWc.Caoh519KAcjdKMtU4zRGTwAkMOLtXVnq
 u7Z9WX9JPXUbCzoU42tMt3xnVSwJsQm_xddFGOK7boLH1Fb4OS850Q.YFk19iKB0o00AuusWBZ.M
 vIw1KPaxTJ3hii9mB3kRXp7PmSFBZkAUae_2_kNjAdWLIaUc8xtdUgZL_aO04iqhRnyRVuu5KXbJ
 bLvCBB.tELoa_TRDHUk6ZPoKiPYMhC.h_bDptxxc5CZWjGD5EC_NR3JpbvwwYfZlMOoG1LvwYcmd
 W6YueJOxBBzkJvFdKwRSmo1weu4O56N8TYsylcKOFSMIpnHUjZRWctzlJV9DeUC5itF8IUx9Unar
 XRpPzAHfttA6wRbKNQOco1ymj97k2FBDZQ3osDpnT20JjaiUpFNi7imA6dx2wxnCNPmUQdFI6PF8
 bEfAsT.3aMgoRA0M_vuiLPVxRmCDglpYqoayMXGqqys6wdhvBoEb5vy.APLDcx9ogj2yt_88z9cP
 haU1lZbuS6vJw3erfLeCt4LQkq.rYRmhNVGenkh3tVqUihG5G.Ea0LMRBKWZrfb6Vp27DzxD3zX_
 7jh4KxkAzCnIsQsffrRx_rcxxHGZNvp8XaJrBcL1kWh4Aa7DgL9Dgn7PnOwfA6mXvb28.aagW12X
 G7gZgSjluZo4Vh0SaPbR6kdwMNB64gXP4UmSnHYdrtf10iI9192FxB2AF_HoEFX.d5_S9rtP_WsS
 M2FDT2UNr9orIDdR1MLq_DyeiLAm0Vsum71.L6FaK054wu_HyHv02pxxmfcz7Js65BzUQ1GYzExU
 67uNRCpZ1QNwhnPSw.STy7UePIGvDURrHR14wIGnfU3N9Vo27F40kGc8MZZr4uq7T2wVSj3T_LYV
 8OBiC10n86diuwUCZ82mk
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Sun, 23 Jun 2019 06:46:17 +0000
Date:   Sun, 23 Jun 2019 06:44:16 +0000 (UTC)
From:   "cd8 ." <cd8@gajdm.org.in>
Reply-To: "cd8 ." <cd8@gajdm.org.in>
Message-ID: <52860076.377779.1561272256850@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <52860076.377779.1561272256850.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13837 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I am in the military unit here in Afghanistan, we have some amount of funds that we want to move out of the country. My partners and I need a good partner someone we can trust. It is risk free and legal. Reply to this email: hornbeckmajordennis635@gmail.com

Regards,
Major Dennis Hornbeck.
