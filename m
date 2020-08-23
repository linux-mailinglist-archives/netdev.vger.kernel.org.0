Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D824EC48
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgHWI4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:56:13 -0400
Received: from sonic304-21.consmr.mail.ir2.yahoo.com ([77.238.179.146]:36189
        "EHLO sonic304-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbgHWI4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598172971; bh=Kmf4PGGAW4hFohRwP8VxB1XRE0jvKX4FRcFJqsGTJuM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=JlCu8UKEL+Tdj6PstCSYmsYB5/Z8AQ/NPXS9rfZ6xSa9LCveFWF/NJp4XL8c7zwzm3cNaFy62AyrdSlDWYaja3q0FXOGJfHlflNIFAp0vHUJZHlH1F1g0k0SH1qFFd3bHIsEhr2wZ70cW8mhQLxJJ8qljpcrp0ZLNs0Rt34VJcUFpMrtyjRKlvZLoTh70v4ZmI950iqthKiBc50Z4FvmoG6AKLbui9rAXARE67aAIQBO4rP6Y5y39k6jaiW3/XpST/tqk+vYlH5kAlk1uxFivJZXDXdXDAUHteTIVBarRHzIfUEpBKZW3SQ9NDP22hmdsOUY0PUAIQ9Xw9tkrgMfyQ==
X-YMail-OSG: ZhNuwGEVM1mWSeyBnhbk9W2VvPJPPBG7XziKbrPL4nbrNy0NO8fn0NpZRqywj7u
 AVRLJYv7Oj7vfNMR6o308ykinLBvv1ZAkYWaWpcN.LwT9HiT9B0G9u6P0zLZi7t5L4cDfyQwY4sJ
 U9xflkF6U5PNWuFBciY_Ym3pNN16.Id090Rt8fX7J53u9D8PodcA7P3OjhKUzufiMVqUrZdUrSl4
 VKr.BfJOe02e74qSEsrIgsygZ8qAEl41bg8Qdizh9xtpwEIpNCuCZq9Y22jQv3ThRdYTfyriti.7
 zFhNdX.cRByp97Ze3HIT7mIaGbnntuVt0T8G4UmTIah34hdUN.1JH1XmXz9R6N_LtN2l4xMG9TkJ
 lOHftPd4pt.tnabqT4CH4pGEe_GWVXcB7cyCW2cXNJGwgoPnm81FonQ2h6jfIpzkFXqDXzPzuEqX
 VzMMpp8SypkhlEum3eBPK2s5yQR4AbQoQ1kLm8RIgp96mKne10ckFl2_unxmMyLRzK3rUiYwOVss
 fu2Fexto_8TsskvZHR08MXB0U8krTxAwLOHYuCh5gAdNBR9Holo8hNxQxBXHpwiVLBkdFIp3PQce
 EICkc36DU23VbLtEuB8m9XuNNcRRD1juYPOrpS24MdWeVYzda_pT1b4Z4ebe6SBBjMMYzFw1z3HT
 oA2GCIcnHq9dFonuyO9ETlLq_6GQ17nFSdcR_j1qAh.gYxeYL90AabkDB.TKmsMHrU00nIQcA51c
 fcHRSY0.e2N1WUn_7nJM3FQ4Wv9ZQd4iqaZ6BVTQzrF.VKeHCoh8odssXPJ7pIbYHxRfVFOiQ7tj
 8o5G1Rk5E3TLVp3W8aAbPMbd0dvy30AOVjg5oPwJR1xy49euCbZMXHZL5zM9U.hmfWLH11hcpPnc
 ZlbLNKvDtx.gpTiTb7FX1qoLlRTX1fGbnLIfrC5C785nTnWgWmCENe2meRGMYP_jSsBAxHCVfrI9
 dIRPrLVnSOcIRkGhIUKzSGuUDY4HJawXfQJ6TLIcJ07B3Whz7uYuNAhX8So.v5IqMm63lmL1rJKl
 TfssTcakIIBJ8sHcXqanL7fK56J5LA.S0O7IlEKuuiDPZfDFD4FWRiaIwYpEcnSegGTbU0ff86sb
 p7CYrEfyf2r1ehb.ZUbj2XVXXoHXYreBNYhq46H8kViI0apzVCnzN2bYyN8cmqytZulQns9EV7tG
 s2n4UtgZrvi5SUkctRTvBkiqXPXgY_lk7Bg9oA57zh8JGnByCylTCX65d.OpcW_yoF8xSmVCAjq.
 dJskrDIKGlG2Kq2giDg.KuMssD6c9exbbiqxSDnBlXJCLdXxktSgijQVNl2HeoJ2Fk3AypJZ88JO
 XapgZa3sM9tTPb2_zlhp8vG2h94s.XSCSLjAMb3BnTuSSlKPTYt0SIHIuABOdBq6FWSfe70qVCtq
 2D247VsOS85X9DuARrIuyVldBxWjr.Zs0jWUmF5j.DTfMnO7A_pcq
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ir2.yahoo.com with HTTP; Sun, 23 Aug 2020 08:56:11 +0000
Date:   Sun, 23 Aug 2020 08:56:10 +0000 (UTC)
From:   Celine Marchand <official0178987@uymail.com>
Reply-To: celine88492@gmail.com
Message-ID: <863477265.7111606.1598172970824@mail.yahoo.com>
Subject: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <863477265.7111606.1598172970824.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hello
Dearest, how are you? I am sorry for intruding your mailbox, but I need to =
talk to you. I got your email address in my dream and i wonder if it is cor=
rect because i emailed you earlier without any response. You should know th=
at my contact to you is by the special grace of God. I am in urgent need of=
 a reliable and reputable person and i believe you are a person of fine rep=
ute, hence the revelation of your email to me in the dream.
I am Mrs. Celine Marchand a citizen of France (French). But reside in Burki=
na Faso for business purposes. I need your collaboration to execute some pr=
ojects worth =E2=82=AC 2.800.000 Euro and it is very urgent as am presently=
 in very critical condition.
Please reply through this email address ( celine88492@gmail.com ) with your=
 full contact information for more private and confidential communication.

Thank you as i wait for your reply.
Mrs. Celine Marchand
