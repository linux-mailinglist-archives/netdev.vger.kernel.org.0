Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F59241647
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 08:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHKG02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 02:26:28 -0400
Received: from sonic314-15.consmr.mail.bf2.yahoo.com ([74.6.132.125]:35492
        "EHLO sonic314-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726154AbgHKG02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 02:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1597127186; bh=gH13qpDo1pe7E7DmJ6M5fxIu4YXvqPHbDbzMZhOfCDs=; h=Date:From:Reply-To:Subject:References:From:Subject; b=B2Lw+ucFaQwtwYdoy5uBMNZe51G7M98bZzY3GMExqV3ujQ6KdF3wcmtTBumo3Hs7KrRDbdyvjk9WHelr9hNnfApfyGdl9tkCQW3NSB054Y6wMhfapzqlkcLA8ACupcAeJZBVxTLWkQu9S4FnZigNUgYOSo6koYUk9N4PegZ7NT1WcrqJmDDRnQlWwx2/KjHrZSiFcnWft+3vfIKQlLv7PFQUXXm++shWxou1eGnhd3cKBzdNHr801+ihmZR6433Z1tTR7c7ZRoZBST4d6b4+OjwNNd1/Ng9xV8gs8A7Zhhe0jjAK81I95qAszMFh447qTYWGMIvQsLb1SrZEvE1kuQ==
X-YMail-OSG: DtP5xIoVM1lBIAJRtR3z0afnd5cojM90gFG33936SWz_uV3ocaEKJVY1DTt8FAz
 wqxu1_biWvajEEI7YUS9AL_tvog2jMBBTlegrP3cUiMU0Dic9G49PE6QeCH6TpXGLpixzRkoGmhP
 MDiPuqYY_Qh1SpsSJOqgX6rE67op_dhsO9A79r9NOuTYIkABJgNYhX8sLqJZEdoqmGCvo8o5i3Tx
 H3GmOUI.C3Eq6yFXebLNpYclKKZn4kSxKBrfz8Y2Kk7_BEZcJz0ICGe_.HFAz6zqQXkt.cqXHPxE
 2jFIQEnB8tDkJhVlshEBdzqvbqjs6lm8IxGSzmpGga4Qlc1w5JMVZY9biXImLS8kpa0JTYTA9J_1
 LRQtx1CNcblIiueykoRuQ8pXQKZcJMWqTcOvQVk4l4AKrIuhJdrKP0kodB4Ye4fCpQUXKLJv81oG
 O6a6_MOHV_VbCxjY5lv_nBWjbjC6tnK6pO9UwFXG8Fhf_3W211ceNOpFydR0bUK44eRXsm.27gDr
 ClWKQ7kdMVDBETFsedjemhLpwb7t7bVpn18x9os3iSz51dQNgYZql4NXK7TBOyIio7LWXI80.tgE
 G8aRkbcWwVpRC82fHM7EK9ddewM5IFna1PhW3KW0JQGSMtYdXMNpFCZaJ12DpLlFmYq6L8g_ayQq
 3zeh1_Q7j3pldRyC6Xd4oeSCTOg.hMeXAuRkc38x_wgftlGB48llDQymIFpqumeDsuLjkckLUJoB
 Guf2JvjLLHBmgYrZFX9HVwkGU_SNbbGwamBT0m58tozmrEE5cVFWDxvi53MjBjP6AfmbLOowAZSY
 YVGC.HpP8Sbai2GlscZYpwo10kyYiih9nqyFNU1_lT0GtpIIzbXHplnEZ1MZ2Qo3gXrs5uyytslz
 EgGABZg9HybIw_3yD4gQUmaQ4nbvmKidm4TLNJT3ZgZBalZcjcxNiX9eelW8MfD6KlrtjEp2I5cA
 BBNCQViDG26G1X7b1NyyJzDCsdkgwOC8rSc_khgUjcclleSnQ1fOIZInq55_mgTNGnTdYjCKh.85
 EUycaF0O86fHU5bz7htg73G9.yXt_g0KBBnTEVlhmcZpToRuXMopIYGBJdEVt2ZMq5QbAemKJHGh
 CwACAvqcmbqsJUMfTyRRqeTaD0F6F1dzwcFoq_PVsrM0zN3h7Kjs_hbhOiu12zl35430hO1vJhik
 lcl.MM.DxNLcBSpuVmcwvI9vps8vK0oanT2gxtX1I4EbdetiEAztGnfUglDYM8jFUYa_O.DGW5RN
 SNHhtLS9BeoLsh43FxDayvA2WeSJK2OEll_FKe2XxhzDpmAsGRY4LGvVgA2JUIyMMOVTCQeonV2S
 gNAyNs.0UHUeoGUw91Gnnz3AIV_5xamqsa7V1nTkVF_c1vKL_E9Xk1amRWxN2gOqNmP5E2LU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Tue, 11 Aug 2020 06:26:26 +0000
Date:   Tue, 11 Aug 2020 06:26:22 +0000 (UTC)
From:   Miss Amina Ibrahim <missaminaibrahim001@gmail.com>
Reply-To: missaminaibra@gmail.com
Message-ID: <632694604.94129.1597127182336@mail.yahoo.com>
Subject: My Name is Miss Amina Ibrahim from Libya, I am 23 years old
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <632694604.94129.1597127182336.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Name is Miss Amina Ibrahim from Libya, I am 23 years old, I am in St.Christopher's Parish for refugee in Burkina Faso under United Nations High commission for Refugee, I lost my parents in the recent war in Libya, right now am in Burkina Faso, please save my life i am in danger need your help in transferring my inheritance my father left behind for me in a Bank in Burkina Faso here, I have every document for the transfer, all I need is a foreigner who will stand as the foreign partner to my father and beneficiary of the fund. The money deposited in the Bank was US10.5 MILLION UNITED STATES DOLLAR) with 15 kilo Gold I have confirmed from the bank in Burkina Faso where the Gold was deposited.

Please I just need this fund to be transfer to your account so that I will come over to your country and complete my education as you know that my country have been in deep crisis due to the war in Libya and I cannot go back there again because I have nobody again all of my family were killed in the war.

Please read this proposal as urgent and get to me as well.

Yours Faithfully,

Miss Amina Ibrahim.
