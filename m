Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8829D10D891
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 17:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfK2QeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 11:34:01 -0500
Received: from sonic313-19.consmr.mail.sg3.yahoo.com ([106.10.240.78]:36235
        "EHLO sonic313-19.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbfK2QeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 11:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.ph; s=s2048; t=1575045237; bh=u+w+4enpSfCcELgOGbyxJo9ZBxERk39tL4f9H54lgiY=; h=Date:From:Reply-To:Subject:From:Subject; b=NmJTqgiY5Urm6G91aGCH+pbAkxuIEHes21PnNMblj+R9nFIFMQtiLDszhcYvSIgmysq1bKFJuYbhyoDTrRrLgbCUP+D0Ed0rn9/XqBnSDgMf2v3qDKciMWKZ9GH/xEVC3QdSmuDnZVOpDzWjohQ52Fnqibk1L+ZAOkC2TqL3e8u2vYQFKxoCQdZJ7q2CtODwP43+Kv3NPocm4QJUZU45eSMTySUjiI684c1Rml4Qzo8XqAReZEU/9CMMWUB/daiqsi15aIwykhhYeOLKwzHh6IciLUvNDvXzxGEhhxbSBuXAj9YtCDN7Z/orLAAA+UxYRWNh59H2fTTSNY2A0Y4PDg==
X-YMail-OSG: 3U5YZV8VM1kFXPKWeHUBIxDpDAuLlwidVDiBr5kt9zXOsILwHfr0_4.XSz0BlEs
 1JKuhJfgzH1vD2h8.zhbWcWksPh5OFbfsLt9uBEXN96pszTzwRwE1hhVabxqmDSSxyJcmYnZpad8
 WzIj7eE5mkftYAb5XMKINKqqsZvKtDo_V1fNw8ZHpGnQNI6brhHJJpBlqeQmEpwnaWRicgsAdSA_
 H9FFKT5_mZ2wMObVePn06kGHmBJwtbJXwRj5C0MB3SDiJ1L1OtLRxcWIvCskDay5LrbNnfYJGmLm
 aJjawaU2_EjjkWfJ_HpgffUCJ4o85K52c_9teIciJB.O7guzzX_w7x_uc0HYSOuCGPHlD3us2Eio
 xm.VZq7cwpWzvNID0O0DpnQhHa73ch_a0_oZAFCF_0Eg8uzuLoTyts4OOWX5IUQpNRzqPWSNP0np
 B12Nc7osyosNdNi7f9lemDlmvhA70Hs6.dljHclYcHWbJ7mXyO02Klw91v5aRru1SOfu8RuqzA5e
 Sd4ba_d_vdBfp6Oaf4Gk3ZDbR3i.AueJwK.8tk45QuGup3YO3ULHdvVRyOjc0ULOgyGBmz4R4duz
 yKGs.WnQmKeXWwV8csXSea8Alg89ebvG3pypRxSCq5SpyQJJpXCzPSk_NXx8_LSzE5TA121QIVqV
 wrUS7q3LksxOTTaG3HT2Bz_FFyUesneARH6dhLaNc0W5EsRdwsAbMq4XhBJ.qSzdne4FmtBD1P8m
 lHjtixhus_qQXI4uMANLoqM0joXPiqo9z_bOQ0SOThi7oYV53MRsA5I3fD2EH2.gI2KJhK_8bp.m
 z2Cs9fax1lkrhWeOQHvfq_fcajCwjwFHqpmy7tCnEQ6nxMy5FWS8OcQad3KO0U3hIWiXqbZGON60
 eo6S8hX_f1jaF_mgnoNY39l3ZRampwaEJ_WPMwd3pKwLaxcVksEa0EMes_bgDmNurmU9yEbSquSk
 QXHnfNxNsYXhIFimnwmhJAlx16_IF4i73dv6g2jFUjnB2ZO9TXwSEpTDbqD9MuewCtE9itGTvfn0
 nITy1HM6qlTczuoY4v6XMcvUyQzvAcQGQUmvpvKc0E2ALHQenRoDNTvjOgYFsq1PPXkYkmREI.Pz
 _Xhm4xRCmenU_ugO22IIEq35JQQCckgqd_seXvVzdgqNA2uVMlVFQlQydzDEElJ5METedQwqT0hL
 IX_zwF9RYCDBXt2L_WMyCmqPSoUA0_LZpB._FJiRNtfdWwRgFcbLDLGwKdSoLevxdR7t1WoNAjXE
 nUdBqbmGyRIuhx6mFxTUMh8MFOzhSTergSVXalrNZcq8qBoV8vGBH9avjdcJROk6S8UOwHfS2OGA
 qpukbgw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.sg3.yahoo.com with HTTP; Fri, 29 Nov 2019 16:33:57 +0000
Date:   Fri, 29 Nov 2019 16:33:56 +0000 (UTC)
From:   Mayveline Bote <alice00631@yahoo.com.ph>
Reply-To: mayveline631@aol.com
Message-ID: <1733016258.1379542.1575045236679@mail.yahoo.com>
Subject: Hello Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,
 My name is Mayveline P. Bote, Please I will like to discuss a very important issue that will be of a benefit to you so please if you are interested, I will like you to respond to me in urgently,
 Please do respond to me very urgently so that we can discuss the issue in private. then nobody can read our mails or know what we are discussing.
 Thanks and I wait to hear from you urgently
 Best regards
 Mayveline


DISCLAIMER:

The message and its attachments are for designated recipient(s) only and may contain privileged, proprietary and private information. If you have received it in error, kindly delete it and notify the sender immediately.
Mrs. Mayveline P. Bote, accepts no liability for any loss or damage resulting directly and indirectly from the transmission of this e-mail message.
