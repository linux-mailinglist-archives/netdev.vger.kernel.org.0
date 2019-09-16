Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD85B3A54
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 14:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfIPM31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 08:29:27 -0400
Received: from sonic314-19.consmr.mail.sg3.yahoo.com ([106.10.240.143]:40852
        "EHLO sonic314-19.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727743AbfIPM31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 08:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.ph; s=s2048; t=1568636963; bh=t9JXXOOd1yT/BH1r5kOEjcUZJbsexPiQRYxiboi/kmQ=; h=Date:From:Reply-To:Subject:From:Subject; b=NBmXxUZTQPG/Kb/b0hRr5pb63G0DOHeZI8GmmzmF+gfTeP/HEMRPHmixwIO/HxH3F4+3MB+EZRXv55Sbm6c0oNecvN9DRYPI5TbBLuZHarknXHiDGIyoaPr0jnRjYYzrZ3rlReiUrZfVuUXGIM15U13kTmxO3k4POeUa7ZoZeP1Yo8kc109RwrlhHKmkif+rKaZ46osivfNLX4MKo80r6i0I/90Q6HrKrKHlGEBW9wf8GY4m0J9Oix5WRZpSkCOQmJjitz2ZxwSXkxu5s3AHd3Wx8oL80Qq7HtxX60/LmsTCNO9keQ6WnFecLUJiL9oVK6g3KkEtIDyCXaw2K69h0g==
X-YMail-OSG: J0FMYZUVM1lS1nj7ofQbnyXuQus7SyzS_WUNuXdpOisYuSlK8xFJ7R8YEfAb3Sa
 07clujuX0R9JEz2keBs3s6JyLRH33Bw1ahKSGJrD18NXRBzLhA7O0LIIwhh6I32mYJsPEWco5.Zl
 01FUWo1mOV3fuN9AHuEedGd8XoKmRdHqsmqSOcHTtabjD91OT.wlw1oTLsSUbR5u863iJ0eckTq0
 37Z6GeycjcRz5ghWPiAIGW8jVhxE0FMVx_0Bjs8vYnMh_PTVCNSNGXiX8tKO.nCmhEf6DJPjwMva
 uoIKCMrbi25qRDNdOJiWDcx03_ZLTzZIueJ1OdlZ9dEESBA353wE2I_WalyM6EHZCnh54GNOvvnR
 FB34Sm.ArwhdzSaLWeiinyxxYe65ZgnNjIdkx6fAfz1H2NT_nL62AlCF1P6hlhAvpE4UnwUK6Owy
 PypmpWJ65GGzF3UG2EAKtV31B9v8ESLj6xreb9OJReSmbWrxmSgn8nEIW4p0llmv4XeN44YtoOs1
 4eampKamykpcenOhBpGOGF98UHc9HFOJ1zzBM3p18ngtkJnbaUtYYKpZTNaG4px.gfK4sSQPrlb6
 XZhXS.Y.W79952JpHz.gF_H9mKTwv4kc67MG_Yx1HXWrkMeiPPMPMI.mJTMRxse1TdCj.nbEZL9W
 3.vvk91fNn19i.wACs8psQjJi9e5WINHt_a48X_hEftiFqBq4S3oAQhIfwbPePMa2MHp70ykqtt_
 AUBJUJcwqmf.MLY7gKg3oxKty1kCR_qM0NkYu1pdD2MQTJNdl1XsDskM14rvxJE.VaJEsdOjeKfS
 WNFZDAG47NKQnbKkf_smZgOdGKbB_j_1B6AZP_WhpjfEkmxebM9VJcVLXju.DzKQoDgsac.YPUjA
 RWiu27L3vrTOsI9DkLFm8ux5KXf7u5umvbXVaI_EjOUcuY21MFNB5GPUFEA54eePU13DXD2QsR8Z
 KsfVDqepyfrXLXo1CVWUuaYB8ALpi_a2coGBfpEfytWufsJ3kuo5NH7mB77430eN4huT3Bv6TDNE
 auU7fkxUThx_yFv1mvx90laAqv24KCOv5JN1GSlsznNgEligGnnFUACKqTftb6qg_M_a9GdVd83E
 tmzcn.nK6ykRVWAbeLthGodRmatB_cZ6n4tCAz_i0iLKrcnvlQnmUjQDtIu8AwhbqvbCFe3vZDQ9
 ycxxDvL9qCbOjs1zKbL9zy1P_wZA5XJrfh8W.6v2Ab_BDe3ntKVhaN4mkQT3AgSVdaazGk5krmMs
 66SsVFSg60kW3QLQYLzAIVS.ZfnTmfLdND1QxEbR23Ig-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.sg3.yahoo.com with HTTP; Mon, 16 Sep 2019 12:29:23 +0000
Date:   Mon, 16 Sep 2019 12:29:20 +0000 (UTC)
From:   M K <bsawinf@yahoo.com.ph>
Reply-To: infmk@hotmail.com
Message-ID: <289741741.6314721.1568636960135@mail.yahoo.com>
Subject: NOTICE!!
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I email you to receive the sum of $39 Million for our mutual benefit.
