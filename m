Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0599A18835E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCQML4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:11:56 -0400
Received: from sonic308-2.consmr.mail.ne1.yahoo.com ([66.163.187.121]:45562
        "EHLO sonic308-2.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726968AbgCQML4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 08:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1584447115; bh=kcevCRoll2+Bsa3FDERpIV72LVcB1A4YV1b5N2AWYBk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=iUlGnRLQG6F3FaEVNIp3zcBgcxIJSYrz1n2caipTs0506aGX82j4iJh/jdfSgvf/ydicy2n4aU/zcMuD6FT0MPShSa5Y9D0k1iZPPFL8PIFVehJi7MVWrDXqoMlkPLuvXo9aP+WQB/EErjPvAayMOmUP+gTL/NWxITqPGPZK2XtE9pgcVrWyc3xc/+YTyebWNK+rtmAyWlGP/eliRO3yEsGmz8o9JBSgOoQqhEmw5DHDZJheBrRRyvm+a84qVIzOFpXH9siCaC50IUM0wmFhzZuSMna+3k035X/W95iGIQBCFRdjIOLpT0JSULvvxk0W9DSm14SNXbMEEWQazrStyw==
X-YMail-OSG: 1HTxhrwVM1kZE2_6l5ymOn55wL.OWIsR9auq.uEqq_ZHTQie.PaPJpxl5rp9igB
 FCikKZTBgfOj8BtWp.7dvKTeASz9ejKdjMoqxE0hg4RSPq.Xd74XcI5VEnMkqJkyztk67cbM7Or9
 unzm5W7a3GjGw1sOHs_4l.tEhyFRVj01f6pdEhXinjs1ji5NymU2z43mkQDygHNj16YBZa9wTB07
 moCD3msk0w8_kdkp22fpPwTX4fLTEmNYBk21vXz6HtPk0.6b3kVjtTGK6_ZZh_OYbaLCc5TFSvT.
 AENtXRny18CK0gOejXVDH8ptfkWZF5lg6LdBoZiGU43ZYWbhjIXMSDsrYPX.SYJZG3m6aL96RlDc
 4vm72HzxkuZRIQhMed8kwuXYxZl_jqoyOlhI.nyfIvgsga1AYHOmHv.U_XZRhERMqBF.P5FA.Wnv
 6kMqdwrgGgGIaBeQs75cdTwEmgv5ykzgM2LfpevJOpR_MdTOpjHP08RQMgGirEnMzLLu4uGsG6Jp
 KxzISBhVgXQ4x9lZvKT1RFpVYF.wX6_RTCbllK1_nHOjYKRfnp8EfjyYm_VsnMOFRAnulZztZzAB
 juSj9TeppZ71SsI8u6thVsJU0PtFY_.RdSdkfF0PQaXmIwubwv0BR2gR0gt5yXxJV0kAW.bpPwB4
 8v7fMU_tvJzbYunZIf9a6A3doFdxSkSIuEfQctkuJZxwf955s2qBys5JamCgpQA5LprKLq3.iR.G
 BIyc.9HtBGd7_XlYAWyIBlRYB4dhsVF8_yma6nxIJdOXkg7QBy0U0Mba7DucPundHOuIxwEb5Rov
 KpuYyiiYmAOOobaSJaM8GYdWZLDqdKdCwa.RlA0BHZIK3lDCKK9a76.qpc6gs.WiFFwndlk9SpVe
 CFz52MUKaSLxUp3Y.jhTJdHuxZgtpswiFP2J_BbRrk3nvH_6qaOcGnaxXjwty5qD_ElDn2rmpKl4
 a06XHTzdmDucbtqSf1I5rTyiFcVFiIzSREWbA7Kc8Kh_utzmUu7QXM6J87zt9PxzcFHlBHvtZV3d
 Jt2ydetpORiYIDflivuU8c5bAF93F6tbvCTO1bi7racv42jfg48zkh61iQck2C7pew6.5E.HLDNs
 CDqJWL0wv05joC45oVjMt6mHEACw8YXaKFnoUMjnlrbHwDktN8ty70H7rYDNrKIM_SRj1rjtWOE2
 wpRrOZm8gM..Xxb1sh2OeXwtcuiT16WAIZ8HTAtstL3u_TVZOyW_eMVZbtrQE7M7dhwEAxNYa.uz
 Rdql3UbrnbUdAEu4bpqZDBxt5XwCviqOtp.6WkyD5frAPEgwbHYnAZsPjZPglQsouJX2ttD_S.Kj
 HBXFqHTAuu1pSYJNaUNcIey6u_eM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Tue, 17 Mar 2020 12:11:55 +0000
Date:   Tue, 17 Mar 2020 12:09:54 +0000 (UTC)
From:   Stephen Li <stenn6@gabg.net>
Reply-To: stephli947701@gmail.com
Message-ID: <2059527141.1811494.1584446994240@mail.yahoo.com>
Subject: REF
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2059527141.1811494.1584446994240.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15342 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings,
I was searching through a local business directory when I found your
profile. I am Soliciting On-Behalf of my private client who is
interested in having a serious business investment in your country. If
you have a valid business, investment or project he can invest
back to me for more details. Your swift response is highly needed.
Sincerely
Stephen Li
Please response back to me with is my private email below for more details
stephli947701@gmail.com
