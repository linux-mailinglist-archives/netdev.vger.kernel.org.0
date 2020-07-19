Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB6D2252AA
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgGSQBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 12:01:46 -0400
Received: from sonic302-2.consmr.mail.bf2.yahoo.com ([74.6.135.41]:41305 "EHLO
        sonic302-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbgGSQBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 12:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595174504; bh=CJfHRA3PAxA/lp6Mz2SeiBBl59bd5y646SzWk6cUNN4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=PcwIsLSr5xJi2H+CP+/j4pzqsyYxQLjVCaP66R2Anz6k1gYm0bwBKXEnrrdW2Rjk1HvVZuQFg+1Ah+E1VBUolUXMjpJQyQDCQ8iUrQLsP19GrLFggo8IJ5f4q9oRy+wb8kklHWJkjlD1F/DRNEB5HSfeckoU22I39oUFSChJVgK8QAlWfUb4Q7tIHFiFSFqdFrgVeeVlkEYYNTlSPCbHPBQSuH0rHiDbJdfzs/msB7KHNFMNmsaPJ0TA8DKVK2nzfhyabTuGRNCELjD6kInBk0wvskkHDuPNmGXPMeYmZOpUzZiMdq5/7aSOYgFkwKn9bHwnPES2vz4vLJe6TpPMhg==
X-YMail-OSG: xGaIVLcVM1kalivx6xJafi9g0Z2gZt_SCV7284NKHueKVj7Y_PNzjVismHa.Eyi
 B8aYGSu0RozCKV1JiFeLbAF3qSaT_JCkrgtxkZWVTv7Ug9crS9N48Gkwhrr.jXzfC6y.KbhXvzVu
 j1IIQIku0pC5Ema7IZc18gUOzpeWWXPgItAzoNGfbthL622LUhjZ9VxnCzX3yphXwuvRM9QKYu22
 a_neygtoLMnQdpBDZ4FGnr6a51qIdvbm7wgB9IHq.9Mt46062OM0Lyp8x62th9dExWXc_R7c92Zk
 c0Q.ZIgAs4j6KHdY1NoQazYwIZCXeZKaXTEqwd8lWcZTHC3liOGaHWOXY8y4e6fWiX2RZg2dTrVx
 P9KJRRKyp7YjYtD2KV4.rT2oi6BZC07iyHld.qLR15qRIZeMbn8HfToLvqwZWvd3aEB1C1ncqAZG
 WNLelb0_.vJDl3PCPCR3eqjhFxekqJZaHUMupNv6QvO1Y0DEUv7fMeBQBb0SLruoLnT93QSyEJis
 oRFGpi5b6dAsheAkU9kiWlqsCNDg__.sMKytPaFXJFpMKQS5xEmy2ZrUSZNIH.C0klyayxc6Eoat
 foJs1SNFz8EoP1Zrzk0MECGozkJo2tPwBjmlhvyjFKb065WrhvQ.FsBp4mjF0l6qaVz329IMAu5K
 ZOd2FijYi0uXHGuhSEtuurTQEQ3JBaB_cwqEhWEWCS.q60W7MoKEaC_FeSnjA5M1cca7iYUH2VDB
 9KQ88_tVsAjKj9dgDq5e8Lnz7DBrze1dVJTKwJ95FVUFxCEdEBo2f0rw_dv5h3zGh3fzJZLpas.5
 D3brFwYOp_RLcTxKq1MKliv.a5M56jL8WRIlaRc1_LdRLk3E8VzUM52Kjj_g9WJA.qipWcFP41jl
 CM_tl.P_PlsesVzZcwngmy8pimaTxjFaTlEbyLF.q63THE6uuBWsoTgL2I41fOTB_mXAP.C7ZDhq
 kbrJD56m1_IKyKITYNtWdLY5rjekU30lUxnrMYbX_ekmVpBzJxTF11EPxMZZWsEhSa4Ulfga..o6
 QTm6Q1o078u.5QcY_3_Tuupmgo2HJ8zqhvhEKQ8uNbVXT5bq4AHWAg9iBiwJ2sXsHLXY93CkaQrx
 2t7TR7ANDfvRLUjvgqAimcY9We6nmUPNoqIhXFRiB1jWj_NWCjKsAdW2WMx5ao26zgn29PoI.KoD
 mxjiJDFDpzBhQ9dctX4OFpDfBMdSAkDtrTxV.WL23Br0mFzYOEdoP_mh736wE5iSV5.bzvXT8qRU
 rk7nQkediKWwxMYF3INUBBMDT7wpDIEdxKK4YhWSbE_4fW_BuAC0JMlF5gEtz0amVQX_bqZhEQa_
 c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Sun, 19 Jul 2020 16:01:44 +0000
Date:   Sun, 19 Jul 2020 16:01:40 +0000 (UTC)
From:   Tapsoba Ahmed <chikabarnabas@gmail.com>
Reply-To: tapsobaahmed100@gmail.com
Message-ID: <165138179.2741627.1595174500291@mail.yahoo.com>
Subject: I NEED YOUR URGENT RESPOND PLEASE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <165138179.2741627.1595174500291.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear Friend,

My name is Mr.Tapsoba Ahmed. I have decided to seek a confidential co-operation  with you in the execution of the deal described here-under for our both  mutual benefit and I hope you will keep it a top secret because of the nature  of the transaction, During the course of our bank year auditing, I discovered  an unclaimed/abandoned fund, sum total of {US$19.3 Million United State  Dollars} in the bank account that belongs to a Saudi Arabia businessman Who unfortunately lost his life and entire family in a Motor Accident.

Now our bank has been waiting for any of the relatives to come-up for the claim but nobody has done that. I personally has been unsuccessful in locating any of the relatives, now, I sincerely seek your consent to present you as the next of kin / Will Beneficiary to the deceased so that the proceeds of this account valued at {US$19.3 Million United State Dollars} can be paid to you, which we will share in these percentages ratio, 60% to me and 40% to you. All I request is your utmost sincere co-operation; trust and maximum confidentiality to achieve this project successfully. I have carefully mapped out the moralities for execution of this transaction under a legitimate arrangement to protect you from any breach of the law both in your country and here in Burkina Faso when the fund is being transferred to your bank account.

I will have to provide all the relevant document that will be requested to indicate that you are the rightful beneficiary of this legacy and our bank will release the fund to you without any further delay, upon your consideration and acceptance of this offer, please send me the following information as stated below so we can proceed and get this fund transferred to your designated bank account immediately.

-Your Full Name:
-Your Contact Address:
-Your direct Mobile telephone Number:
-Your Date of Birth:
-Your occupation:

I await your swift response and re-assurance.

Best regards,
Mr.Tapsoba Ahmed.

