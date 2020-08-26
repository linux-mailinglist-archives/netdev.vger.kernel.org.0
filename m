Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6932530BE
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 15:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgHZN4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 09:56:52 -0400
Received: from sonic304-21.consmr.mail.ne1.yahoo.com ([66.163.191.147]:45164
        "EHLO sonic304-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730520AbgHZN4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 09:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598450205; bh=OCp2NQ1DG8WDrE2HT9ykXjnTFISlxhUILAf78oJl1As=; h=Date:From:Reply-To:Subject:References:From:Subject; b=XPFXERR62Vsu7AR3vFuIWbjwaDAv7+5sovKPH84bJcedOEr4a8gan7owPlmekRe/Y4+kC1XUuA3cvUHgaoKWB+Qnpjy4pEsGVd71n82mGFrh7vImqFgGNHPBAVeHE7yLVgodywsUFsmer9fOj94Qs0jNzvJtKOiQxZGvs0MDG9BOzLt5Z7vf8Rb31lbB9AFrfovVs+Qzr2XZameHnjwibYJ0c5J4uUGLcGuqvTbzf5gv5e0T2enfCPCBY0hr0w+PGFzJA0Ui55vROglskuOFk+hoiGOeFDlRD16tWQcXIjY0c79peGvELG9dA2Uodn3ulHsDU/OhxWAiCNGnFM6Rog==
X-YMail-OSG: P3yaZfAVM1kZVRgnlSJ48Nn8DaVTFYBK6WIrKwFLyKXs11x5UNgYWATijTiGWXA
 88w78hII9lvh_fz9OL8RBkuV3ZCUWt8QcoDziDVpPxdNuMoAlPewc397qLiIkpVXKRBu3Y1S4wlf
 TDgHb54sawQDvah3NOiAAg.d2hvr6CTX_JdtQWz8ePdbBZJDB81rkDeXgt3GzgsbnQa_F9Kn_PCO
 MEIDtKPkArijSsWEmtBtI..NVSlqXQXsd_tDPTfhuII.2qVpyG5jVERI1sZFltdtTZ2OSCNdXu4A
 jiwbGGAIUUDwWqdNvAWEu9sq7yQP.gTXE_IUaH22TAjuj8RsSl1lSGHlLVE9iF4p4bTwhL_zTeca
 g0gFrWW7VwiQVYxQsbB78ncLx_C6urraM06DOE2JaCd3wSzYbWPQq7eFcdgNdbXXkBPfkGoR_qQg
 Bz3fpHYK1EKS99QtAjjuJ8.IQ4Yr5fQfvZ4ZJLTqOu_JmDK11uPuffhRXTSYfKoj4xWMDiG3cDOP
 fhyXx6OOD2tmeTSBvdwN6in2aisoRuJO_xFzmvagtHs9sbPtmROHfqw6lpbw6qhqQdU9Mlpx00nd
 Oo1_dsZa8_N1qFWrkM00HOFKYSYHZVz17kEIBEgjDtFVHU49EQ0YHyMsT5Ka41jiMwdy6lYCoDCb
 3l4Ym6yzyThQdLLfiBd0pRmHO.SCBWQJ2qwzlINwWFktGt8HXLzaKEpFzhQSv8Lz_uXRuRagLFB5
 XB.ZVBWdydaklj6gorotZEqZm8dONE_LZGAvnBRqnnHGkmXscbm_Dj6hn1F_0wkBcUFlElzUNccI
 vr8is3Gthl01zvTqmLUtMNqicViVkcieCxWN2oZnbWEeXCG99nb92yLXDHeZinFGlzzf10MNxI.k
 60iGf9zTvsCNviuyL8jJrjSg.HC2X671J_m_QZadF5pFpd5ouCUYtnxt8lk4tShU1XyqJqNA.Rfs
 yWI6w8CVKWiVjS7CzfFiyAPLwFR.aG03OA_44j944SuXKBShqUcXhB7aX1cLdabJhLFwR7EOKNIw
 sYa9iqyNeTTfmXDRSCHYRwQ6R7Ss6EhZ5R_EuI4jMyw5VtMlqHnOrwsqFqiGMtjp8vEeA1mBAl48
 a7cNZx41ggiGZc2U9q4bBfL9dWYDBWRhcc62VI7xSy0QXbMG.sAD.q0szY0MkW6.N5LW0tva_R4G
 7yUEVz9BWtH9eCFYAvM6cX3LPL.HSni0Dxaa34F9KgUhUf8hMRcOqvAI3cjCLeQkp5cPj9oU.3Hr
 krMNNVwSZtn7glizRmsftA7Ab7f00ERjegeUl._w6104avJKmxgUQMJLcoFj2UfaSOTbyoWX8tpr
 KhNgJ_S8hGAUQllIFJas58fvIg9JhnLon4T5c_YQqYdYOyltL4xiMvp1rtHH_1lyVfpS04mvyosp
 R8HDwahnXdw7CbsORMvpEJRJ7MJQmPlG4SMt1Jn8Ys6IY79iBuPVj
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Wed, 26 Aug 2020 13:56:45 +0000
Date:   Wed, 26 Aug 2020 13:56:43 +0000 (UTC)
From:   Mrs Elodie Antoine <eodieantoine@gmail.com>
Reply-To: elodieantoin678@yahoo.com
Message-ID: <1782567564.7857547.1598450203982@mail.yahoo.com>
Subject: Greetings from Mrs Elodie Antoine,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1782567564.7857547.1598450203982.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:80.0) Gecko/20100101 Firefox/80.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Greetings from Mrs Elodie Antoine,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIST the giver of every good thing. Good day,i know this letter will definitely come to you as a huge surprise, but I implore you to take the time to go through it carefully as the decision you make will go off a long way to determine my future and continued existence. I am Mrs Elodie Antoine
aging widow of 59 years old suffering from long time illness. I have some funds I inherited from my late husband,

The sum of (US$4.5 Million Dollars) and I needed a very honest and God fearing who can withdraw this money then use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email address from the internet after honest prayers to the LORD to bring me a helper and i decided to contact you if you may be willing and interested to handle these trust funds in good faith before anything happens to me.
I accept this decision because I do not have any child who will inherit this money after I die. I want your urgent reply to me so that I will give you the deposit receipt which the COMPANY issued to me as next of kin for immediate transfer of the money to your account in your country, to start the good work of God, I want you to use the 15/percent of the total amount to help yourself in doing the project.


I am desperately in keen need of assistance and I have summoned up courage to contact you for this task, you must not fail me and the millions of the poor people in our todays WORLD. This is no stolen money and there are no dangers involved,100% RISK FREE with full legal proof. Please if you would be able to use the funds for the Charity works kindly let me know immediately.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish. I want you to take 15 percent of the total money for your personal use while 85% of the money will go to charity.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish.


kindly respond for further details.

Thanks and God bless you,

Mrs Elodie Antoine
