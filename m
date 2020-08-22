Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6983824E758
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 14:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgHVMSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 08:18:39 -0400
Received: from sonic306-1.consmr.mail.bf2.yahoo.com ([74.6.132.40]:34160 "EHLO
        sonic306-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727870AbgHVMSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 08:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598098716; bh=HWomD5uP1j5Q5FEvOniIgsvD2oX57lzH8wSJnE4ZdFk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=BX9h3jhda9za/0wv9fDIU+9Nh1vAQf6BMlslPthJ6BGQHB4CasmoE1sYKORlpvhiSOESZZEqIHIno4OWI+vBN6o5t+MOeabPpOhPaDDhZh2DDaSw1Ksbzfi6anJaaZuB5zpMcyfixPpAtxK4MBO9qvMozrRVKvwL8I1e8Ho0YYpj9FuGhcPkCkzd+PXn1D0eaq0MBY98zjLU9r1ek52TtKroITpM0q4/21wI10vJ2uvJft/lwojHPh41lwxNtAmnol1f8mOq6uweYc5sii+53hJe/VbKzMbMUkmPBlF/OXa5AZItc6kQf6dAqnq6bt8sU1zyGqfrNeu1C3zBYj8HQg==
X-YMail-OSG: Yry3hsUVM1nUsNNLa.rqTCSY5Ie.M3c4A2dM6JPyFxgeWyDNE9TeOQdg6NoA4v7
 y6.8R1vb5R800Qy7mcnQm4hAWH17LqHQpsq9wkg1Ph0fAeNYkRsTLlyFpzgalXpizDB1nuk0s4oQ
 4u1xmSuEbHWdvVEtx32UPxjDcekWVxTp_4KZitzYC5hmRJtsMpVEfC7ztLuONPZu6cSyP1ovO_NF
 _SzdAJLP_DzDQnAdhO.mN0IdhwRR8OfmZBEGl9KI6jSWlpvfFDdicltYlCTfCIISPQqrqyhr7xzv
 EcpdDMKMpfMILGVevjmvbcWBIFYYqYiqbxZqosVAoiNNazzhuQWA9LPoCW7X5R9LhhLjz3qmPyzv
 skRLY8SXFguuAIS1bQSW3uGMx9IIRWxW17hft8W50gpqVn8gk5q.9H6nrZ_JcpUnhmp4ix6T92Ya
 NYhBlCrGNsvvoT7BfPLPNPUtASUfSa8E5TgxlcfMw.mgRa7KWH3c4rtOp_NSYqB7eE_vRr.88OGd
 kzPXPKCoKQGcKhdMNqEpMdIEU0x6cpa7.g4.LnXTecIRgDL1l9Hs7nNzhCGe9RjjTSRKcLHEY35C
 tOgu2Pa0f5eo945f9mrDD8rohoN5u_lmDzqdpDZJXUb8omQm1jt0yRfg3n5J.xGv18hMDbE8asUj
 s2U.6FAbZtTl4CHPqLDCoHquuk6l1ODI_hd9U.exdFSs9ltwKYEPJyYPZsOm9PsZqPYhArWzmxHB
 8TzjXQOiiB47aIKT5eyDFYlPTE0m5pG0SxV.jRJPtXJSuKNAleJKUO.hl599NQu722mxYZdNsrcT
 emAjg2vtf3pKy7CqT67SlGJKTgpANEP02GBjvjATQrl4h9LrxEGkAX9WmOQjctwe_UUuz2nLr3cd
 fC2gp47oMCOywks1qYWb0bwzxQ4xgs7ND70YgghC2cUXXo7y08StWD5cU1pAe.nYQMjl7qOzifb9
 P7myGWZpJTbtviUWeyWm6YCVtLSD01j17HaT7vHD4Gz4bYXcXFJ_yIb43.2m9EAncyKMZj7A.g77
 NvYi5bcvoMIz9eiLuf_HtIzMBAcU4AZOygIC2tZlp0kaRtAD7sVInL2T2ggNzUTTHT1oTdLCmyFY
 cU0uO9RoqUiW9kju2jzhfWMxzN07e_FZi81JF32FesjNJWmPZB6n7Qli0EbIH64.vU_eEm5u4QsR
 AcUj9.Ap62V8drZelbaLMRIrF7e4IEB5wfY9EgHBLajxscip_xHYiAghPha2zuLu.nOz37mZKgFY
 0GrBcK6LgPKzu9l3L5taVgG2S4RJwzZLlZ2WJqIsxV4vV1ypTGsrc8YlDP9XLcQl4buvkYNRRF79
 7_CGtQ52ga7vhc_BmaGEpo56HigIYwWcFEAFROJh0NCBnGH6G_3gdwAFhL.9pkcFcRz1jhlH80rA
 lPsotkar1gVabQBWbl0w3.LAtITU8sBI.5YMBS2oScIk8GozH8ipEPIA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Sat, 22 Aug 2020 12:18:36 +0000
Date:   Sat, 22 Aug 2020 12:18:34 +0000 (UTC)
From:   Mr Waleed Mazin <waleedmazin3@gmail.com>
Reply-To: mrwaleedmazin11@gmail.com
Message-ID: <1394329082.4406666.1598098714152@mail.yahoo.com>
Subject: I NEED YOUR URGENT RESPOND PLEASE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1394329082.4406666.1598098714152.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I NEED YOUR URGENT RESPOND PLEASE

My name is Mr Waleed Mazin . I have decided to seek a confidential co-operation with you in the execution of the deal described here-under for our both mutual benefit and I hope you will keep it a top secret because of the nature of the transaction, During the course of our bank year auditing, I discovered an unclaimed/abandoned fund, sum total of {US$19.3 Million United State Dollars} in the bank account that belongs to a Saudi Arabia businessman Who unfortunately lost his life and entire family in a Motor Accident.

Now our bank has been waiting for any of the relatives to come-up for the claim but nobody has done that. I personally has been unsuccessful in locating any of the relatives, now, I sincerely seek your consent to present you as the next of kin / Will Beneficiary to the deceased so that the proceeds of this account valued at {US$19.Million United State Dollars} can be paid to you, which we will share in these percentages ratio, 60% to me and 40% to you. All I request is your utmost sincere co-operation; trust and maximum confidentiality to achieve this project successfully. I have carefully mapped out the moralities for execution of this transaction under a legitimate arrangement to protect you from any breach of the law both in your country and here in Burkina Faso when the fund is being transferred to your bank account.

I will have to provide all the relevant document that will be requested to indicate that you are the rightful beneficiary of this legacy and our bank will release the fund to you without any further delay, upon your consideration and acceptance of this offer, please send me the following information as stated below so we can proceed and get this fund transferred to your designated bank account immediately.

-Your Full Name:
-Your Contact Address:
-Your direct Mobile telephone Number:
-Your Date of Birth:
-Your occupation:

I await your swift response and re-assurance.

Best regards,
Mr Waleed Mazin
