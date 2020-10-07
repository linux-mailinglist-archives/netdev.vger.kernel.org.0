Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F84286139
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgJGO3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:29:16 -0400
Received: from sonic306-20.consmr.mail.sg3.yahoo.com ([106.10.241.140]:37942
        "EHLO sonic306-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728577AbgJGO3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 10:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602080952; bh=k6qD474V9VtXKDobcCBmjOJywgarZvgPlTt0r+34qBY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IBlGrt2FIjmrQGFpKiZBxPV3lfhn7CJ6E4zHSjoRFSxdjuZYp/uvzK0UwIe4GXKIEvBuMj07PF1+d+uB8t9tFr2JRUwV55xrbyft+MM+fWLXO+Xcw2ZGNQnuA2t3ROcuUSrnaW4c1Ju+BdeCcKw5OUDYEcUhRTWdvyxeKJg6+Z1A82SZB9HNOfRt9p7xMoEs5EMvStxjwPGK5a0aS51XAQcDv/GvEExatx2m1KzPAduQxA+/b1ODv1X6VF5om3LEBIRkswV5e1sn9Uaaa1lKbsemZzIzESvIpr0KhsbRFd1edsX8OfW3HP8+lVQeP/WCkI8InefJ8SfY/HbC/KAvBQ==
X-YMail-OSG: .wwfhL4VM1mFysl4.ZiPIwdq4g9G4Z6TBfmg.V03M.Hi7KR2sSdVjciKqg6q5sa
 AC7S9q5GgUGdOU_3DWytFjS3wF5IsbsXdmU6xXVYR.F4xSGdvJ3nUBVm0HMGHvDlAjeVPPBj2dr3
 KcmlPoTuOEOnsE70Ji1emGYgLP.Uc0Du84k6l3jFw6rWTF_dFXUhj4Rpq86CPpCnVmnf6ohpUc5H
 cJov2atABQntZPawGD386zZ8Coidg4vvl5Hrl0YnVPwR6crscWwTSbnTCMSI4Sj6Z4doHRrw9B.b
 vVOBg2t6672tkJtM3073rTDqqZh5B3fh2nieQBNnu10nB5bEVglUMqF1G9tXhx7h0v3..5f4oVeM
 MFR1Ycrxe2J2FY7k9s5tIZP2g4CgEIZYLS9G.M_i4evjvyLDV2XwRc54i4uClA0PLkgg1e38k.4f
 m8YK7b_uprZRnO3h7FB2wGStwF_5dxK5FC2reTJtmlrFelJfzL9bbyxvNbQeXwdmxEPMq6MWUVNa
 t_jc3xZ8aHFhh90eLGBxYNZq1wkR_50z9FsfR0RIOthTjE00NQwiTuJRCxXAcibtRg1Bg4jEhOHV
 LmXumwHCF.Bg6qWR648CfR2EGjNSDJOv_HD1maz8CF_ysOVWauzrKRyXtOUMSUktGvs8PZsguGJc
 g9oLuyP4caq2YHlXiUjsOEGU4tnWvYukXuj8Jq6gbOlZlC7mmg1WqoIz0jEqjlZD2ziqTru2blop
 v1tQavhYEh5MPIt6yq28oy51I_uWvOvRusRVNLP7.D6gs2_DLJOlCT21its5_baYneWPVXob2ioy
 vgTyuiwawanu1Cqc3GBJ6d9q47I3PCfvBFv2S4YkGaFDyj9r3bXnpHRakc1_a_O_g6DOeMs20DQ6
 b45rN4rcDCnuh1vlDYi0BoR75IBB8KnhAPTl_ii5kGlXM4KqBz7RPrdXtgIe5Yp8xEoATYPxNeK4
 PqRVpN1zY3WTYALJON8cMs1N6bNT7qZc0elfQqEnDxKn4aF34zdiaZadtPn9BJ1n9IhXWN0oV0xi
 .dkA7KmEf3vxN9wnHgjbXC8z8PaffJWw3lcAXGVbEkpPhvyINOUU8QO.AyuNDzqJ3o9W__zPsKWX
 408lur9HkHBX6NySXbWEmSxjjV08jfw7IG2kYIqLL2_sdDPQ_JFsXCBxU_697zWy4Du6Wte7x7HA
 4pSWWfJj_VnxfcEHpvSreWrIxMU0r6rkiAAvOPWqPr.F3N9D3kMBlHnGDAPHLbvrpcjfpsFMdTvx
 qkcljnWGl6sI0A6jTc.HwqxppsBrznS96CMCXnPAL9GDHYHBbWeOP67uqpSHZ5YODsM4rJQBUYp1
 fEBzV.C_vp3MjnsGdrGKa3i8UWLYMQymH.6rQnsTMsDJ3AdnA8fh4cv..EsM_gyIMh9pb__F68bU
 Ip2Xx.BM7p9QWPS.Gm6iFWd44.ryIHAlG3psTJWQtVyk5OSn_qmXp5cqd
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.sg3.yahoo.com with HTTP; Wed, 7 Oct 2020 14:29:12 +0000
Date:   Wed, 7 Oct 2020 14:29:06 +0000 (UTC)
From:   MONICA BROWN <monicabrown4098@gmail.com>
Reply-To: monicabrown4098@gmail.com
Message-ID: <299125442.250641.1602080946847@mail.yahoo.com>
Subject: FROM SERGEANT MONICA BROWN
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <299125442.250641.1602080946847.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Sergeant Monica Brown, originally from Lake Jackson Texas. I have 
personally conducted a special research on the internet and came across 
your information. I am writing you this mail from US Military Base Kabul 
Afghanistan. I have a secured business proposal for you. If you are 
interested in my private email (monicabrown4098@gmail.com), please contact me 
immediately for more information.
Thank you.







