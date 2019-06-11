Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9443C9B0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 13:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388622AbfFKLFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 07:05:47 -0400
Received: from sonic305-1.consmr.mail.bf2.yahoo.com ([74.6.133.40]:45414 "EHLO
        sonic305-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727278AbfFKLFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 07:05:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1560251145; bh=KjGTrcKxBnSNa4Y0eXUad32yjVm8WvcW0ACsAf8zNeE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jReXseL5R5UyzBYh1p0Jua8dzjZUjPNJs/QZPaE94eIqcY6e6ITUthTAzub6uRzItAWIYVQRhX7EhYmw+hPbbLyTntrfC4ZvmxBspmtjrY14rP6yfuSkFz2VhGRRnfP9JCMTLaYUR4uvJED4x6mKiVe/T7YkN54YHY1H8fDAjdU9ARfh9SOWNdpTjBgFRg9NGUgf4aP1ZztO5AP7ACjAU5vv+t0fZ3jzKgnIvZV34S/zzW+YjPvb257CDS2bQPHXqruWkyVqVrtXjUZnbZu4VRkr+PdALapQ9wAxfEI84UOjOBQBj0ASN+LDhg15LNW589qHVObeKpWbqwRXrDJuCg==
X-YMail-OSG: gmjRV20VM1k_rtINHOJ3e.PDioAn8PEt68rgneYML8Lck3LZIIejzBK1igTUl67
 M4OvhlsiOsS9rRqNXNuqHBcm9UJnTLUgEfiC5yAiSvc9phZJa16Zd8i3khDo6svGPKtW2bYZsAQw
 j80rECnfzFYn8RtbQHaFnFQX1PloC62Qb_VpxR5fEQ3K7qKkEWoWXSq4pHDtXeIcWq.Y0Z38p1YU
 HAFM2fC6bQdg.fKqq0f1gRHROlZKjTBvkZcFrirXR.iXxpFYTE8Tms8HNuLHzgq9pj3qnx7S3EbB
 I4ywzWgfsL5kKhcuqZb9g.Tb_uCosEs6q61ogk0zHalG1CoNanqTdKMNd5gTs_sm2XVC8juDg7.N
 l39ZPJ85X1._IDCjtD3Rs3KKd8FxQzqk3WssK0TVe3Nknql6fOkSs5urjeMrw7elYk.soHzhBAHK
 Cw6.T0TBgaNNewJCmtEliUcEvpy.CwZdDHfgGOgfTopHF10TLvaY6expvD4aqGdzeZRFxRPKPLDz
 p.a7hrViD5F9A9YTse9aWhVNew9joOE80UMhuXzJhBhrk71ADr8VcnDyPaTlMvRDeXehz4y_k1At
 bt_fdFCxe2vLUF5BxM.p5jcIRenS4SEPNpKUEupAQ2YJYTs4M5ejzMNr67QZJEsIemv9N1lnlLc5
 K51XiRK_O_iwluPXQv0vpMnC.w8XVH9v4Qj.hxksqxtaIfKy9YRwRlZLICKeAu5DdvwGbc76v5dN
 Bn6cVpS3IR7grZJ4xXPwLBcyJLMHSYgUuHDlW7XYmILbzGEljtXUZzuForkD7R8FHUMsEXt9H5eE
 He3B9zsR25Gx7VuivUD1LvaFo3qm2SLL9e.F1hlx73N6_kgx0boLaYazszJxmsM_92HixVEqTKYD
 dc.p8Ia.b_l2lUHM4t4lSNhp5iYUIHKVo5ydgnk478k3dSdIK_4C5QORtehYPgMktGI9L4LvWWYe
 H1U6maIjrxTj0LoiDurKz8JIVuMqUFQ3_eKvBZSGL1yub23QcCRFU6ttuXkJHmZIk5qeBVmSPoOH
 91HR6VlC_wwQV5gZoY6aR7q3PVrCS5siutA.dfNNWRekNpVwMgeOahfK9giyF5pA9GA_XtxATKFr
 4Is1f0Cr3knIrYp5nrL4.rUwU17GKekiy_7cQDz32ut1qEPcgtGvwZ5lSdofsSBYiiCJbHByWoIL
 sCrRiw0zkfga1FRuR4aLb5t5HKUZXddgQUq.pgjpW5rHm357mPTwt_YVcyvev0w2X6cvfsf0MNZi
 bROnP8wdsrDKl8SpmKQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Tue, 11 Jun 2019 11:05:45 +0000
Date:   Tue, 11 Jun 2019 11:05:41 +0000 (UTC)
From:   "mrs.kadi.brahimmusa" <mrs.kadi.brahimmusa@gmail.com>
Reply-To: "mrs.kadi.brahimmusa" <mrs.kadi.brahimmusa@gmail.com>
Message-ID: <525822254.1056660.1560251141252@mail.yahoo.com>
Subject: "As-Salam-u-Alaikum" Dear friends,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <525822254.1056660.1560251141252.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.1; WOW64; rv:67.0) Gecko/20100101 Firefox/67.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh,

My Dear Good Friend.

I came across your e-mail contact prior a private search while in need of your assistance, The only Daughter of (Late Ahmed Ibrahim the education and information minister Libya )under the government of late Muammar Qaddafi.

My Father was sentenced to death after the death of late president Muammar Qaddafi by Libya's supreme court for supporting late president Muammar Qaddafi, before his death he deposit the sum of Ten Million Five Hundred Thousand United State Dollar ($10.500.000.00 in UBA bank with my name as the only daughter and indicated me as the next of kin to the fund ,in another country called Burkina Faso where are am now as a refuge. am here pleading with you to help me as a foreign partner and transfer the fund out of here , i will come over to your country and invest over there and as well have opportunity to start my education.

You can email me { mrs.kadi.brahimmusa@gmail.com} to enable me give you all the full details of the fund

Best Regards
Mrs Kadi brahim
