Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3610E196DA6
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 15:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgC2NYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 09:24:51 -0400
Received: from sonic316-53.consmr.mail.ne1.yahoo.com ([66.163.187.179]:37592
        "EHLO sonic316-53.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727903AbgC2NYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 09:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1585488290; bh=VQV+To5S2gWVZyYzSF6aVVNoKJSf7fw7hH7Ff0SULss=; h=Date:From:Reply-To:Subject:References:From:Subject; b=JTKIoRxMoZTAuNAQl6Rnm9gLw1q2jjoYajxJ1dHREY2w5iBNwNHtAZrxe6U/YWNfyIXUHu3ohasNVZSgLKsz0p7/MErv/k5YM6YTp3nQYB59AHUNxCPQ6+nf4NfnA1c3NhtAookc0vH5hIAE2iK1SWt+D/v67yjOCmhyWyN9k/S+6WKM61cxfRd1jEweHHIXhaM4vh8Bai5LCBGEtJtv2VSBr3/uNocTyOspbMBGZEjX1A7o+gwwxwJsGMoHZYKhKIbssoSSpQEExK5VsV+52ux01QJACKQHyW0W94dQ97bMhjtUH55zukn1B4xDhpnb9hWgoi4r6lZH4EFBnYVnfQ==
X-YMail-OSG: Y1k7R_oVM1lJhQLjeEs3_Jg7N1On.p0VEKnR0eojM72E8gnpyaGTy41StkC7I84
 dG3O.v4LlXy.f3n8zkLXkesKkVR548RYedoeBh_gX6auS.uAO5C_OWFHc4cz_5.mC_dAUUclugSF
 GRS4L_beepVQQ.Unj5LQyk8UBl89csJvpd6ZcwzgwxRThIVTn94JDzOIeNG.5QmA_RjWnhVoOWmv
 ebzj3RBZudo2u_fC7eIMS14zH64pRz2HriXPgEhBgY1r7SAVyxVBoo.p7Q0.HRYKSsTljwnbUAbD
 iB6mJXNpuaP1xHtQmT5Zo_WEVZEMz2EspdMpRYjRUcrkEzBmAG9r6qRpcFpTQhZWqNTp6gF_4QnE
 yujzLARoPa_VPdSaFmWrqN3k7QAdFwQLBYVhgBPuTc9gsVdetTuxcin.MYwHx6BPP3LU9HBwhrFf
 ViaBiQNJ._DRu_w3ed_U1VAyr75LV0YFrfsmJC8HgSlm3RqVEcRRGprb6Jev8BfsTlMMMWCYvy38
 nZdsNuCW9OgmDbLu.Sw.6UVums4ILcgZ3DEszY3_8_u3v1GsoW0eFNtS6D_owRZsuiElQ3utCKye
 8_Et2gi9Yop0Rld.BkmrwtNvmPw7GQFMPptEKSF..otkwcZ.eQM93FYqqE_d7rhn1Q0e2EX7zpGA
 910XHYmaxsLFkqBcYquXvqKEeIjOlindlLqNEng37rkYbjQdjGxxzUP1CjYz0QHUHDuivG389I4z
 fzI4ktT3XKZKQE2dTpTgU3q6rU1v6G1CYsi6Md3XKwpnmJ.2jv79qO7KOipFpp2iynvD9ITV0gR1
 DE3xvx9sdep5GadGniETx8cib0PClh_vghQM.b7AO0ia9I3.bGK4wbGmLUjFkGnc5eeNAOnpCd61
 _kPBNK.TQgh83mbsWLY9G_ihT_JDly6gbull_POBOL8S5NRwJYXXomGxTek.LJyTXP5GHEZ4wUqs
 QQ3BbHQVtXAxash7qkDpfAebS25xneWqTYF4t.QLW6hG5tHZKW9dre7ieqSMLaBJpoQygyHXNdRa
 WAV4CpZI.BpReE_nO23jy.s5gmqd9m5QaESVsqUuh0Lhbg9xNlRLp9VuCpfnPsFofL3RFmRF4oUG
 9mskCeZDliD28BCoqYFBqgRoO0i8BPanuw7Zc1ZdYaAhDmojf6ZeF1V9.Wv.nApi0O73QwPMZHAF
 HaQDNjwTbmwiSu7zMRjblK4izC3LXMYc9X8J4pSRci3lfhmSBxLjqObiZxAS2.eQ.322vikj1oLF
 kBtOjt6r847ty1AUKpP9YgHt_Gz3jYVcP7cKpGxrlkb516FhxI6ZY6NMegLadYASJO8AaoMLjXl_
 wZ_Kgd6yT5k_YbPuAeL1HjGuJMG_3TX4M
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Sun, 29 Mar 2020 13:24:50 +0000
Date:   Sun, 29 Mar 2020 13:22:49 +0000 (UTC)
From:   Wang Xiu Ying <fgfhfghgfgfgfg@gtxbm.net>
Reply-To: wying353@yahoo.com
Message-ID: <591411389.543038.1585488169410@mail.yahoo.com>
Subject: My proposal
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <591411389.543038.1585488169410.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15555 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3237.0 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Good Day,
I am Wang Xiu Ying, the Director for Credit & Marketing Chong Hing Bank, Hong Kong, Chong Hing Bank Center, 24 Des Voeux Road Central, Hong Kong. I have a business proposal of USD$13,991,674 All confirmable documents to back up the claims will be made availableto you prior to your acceptance and as soon as I receive your return mail.
Best Regards,
Wang Xiu Ying
