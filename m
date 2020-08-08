Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD2423F88A
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHHTHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 15:07:19 -0400
Received: from sonic316-46.consmr.mail.bf2.yahoo.com ([74.6.130.220]:42691
        "EHLO sonic316-46.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726346AbgHHTHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 15:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596913638; bh=MbAMqu5FypJmtqD/TC/uu0UluiqB+GFRbYPQkAprldc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=ISGdHUGzfwCXJFwww8MrATeKVfVPYayG8PUofICPXFotDICGnmSKHJyJSijr0HjCk08fbSmKsoRJz8h2/m/DL1Ox1R+jPZwyRNl/Mnjz891BPdDNfzLM0HKqu/R4j0FHaumwj0aSLI2snKZ4h31DMpBzoCrMXWOMH7UI54KxrQ9nJp1gYAw5q9fLnL3JNjPnMt8troXxkL7BOoe8uqMNpHWhg20NQHZKcUKcasOngitnkrHY3cQOsDln8b83fNXQCTVPe38UOG2cEsmPiRQNOfv0xFcO4f4/4di3PyVk43lJT9Z/v61+u/JWc8tZcwKhtYfDLoj2rBLEOmWc52q8Ig==
X-YMail-OSG: ozTjmnAVM1m8wmwa5rKeQJwUDSoAh1w43jD89MqkGqbwp.W__YUJg4zwcnRVY_I
 YiXQlS2O.kXzfI.yrfd_RcG8zd3eH1dPu8NL6smdpjnlyVQ8Jqdjd5oSIqsuh4sK7eE7T8XBpZV5
 G7Hm9ARSKyTdRLvDfXhLbSuk5v52Q2IdjkWE_6VsQVWQfEugO0T0__AFMKl5QUzCtfR5ELjOnCc0
 sQX1IKJZnD_n14Y9e1CatJqhbpEleJQB_7v8NbkdN80WVBfF_hJBfNff1IX.ZdYuvn0.qbfsMk4i
 Kbm0sxZWlpTdSQkkT4d6rQRaW0ZpKDNyrf8qEngYDerEgMLRSYt71dE5zrMGauF8qUfaCMZMpaha
 1SDJLuINuZA6gXWGYYb83pqzFWGoO9wGtY.YznzoHHv.Bj4QhPKBWXU8AmdinWAG9VIrdNlpKLK6
 2RVdIuKHt_xlePRpeGli7jhQMokM0zoA8OJXI1Wzj9yY.zq4KrTnRjWXN1jG5OIO6LcMsHumGOZz
 skrKRHTxRn3TEuQVd.P0GU8LeyBUT7.AUbUDPRXZH76b7N9FprDy_LJGpBDAezPr_lqGrIiMKQFS
 pj4G9T.X6vYqk9Su2e9yUVvHQW4EeAeBuMLM6gVft5xXwRRCtqAnXVCW7ZgEsyfblbfZHDsjjRRi
 tn_0oe6xCgp8w_sAifnHOQ.0C6pAlxm2QpfMfO.Jdki52XYT5sG.YFT_MaW4pMKHU0gnFIj6dmb8
 gnBvwz6zAe12sJIr_6bQNW6BA1C3Rxo5rekhXwPwsJLt9UOlupR0a2jQjTzUo1MxgmKc1PY0RAI6
 wTXZe.1EPgkdz79wrbX2BlrkmVXME6z2d59yYPQMhIUqUeAOpYzm3t.PFi9rrJk7DKD.UXhueo8o
 isUsBOopqSMKZmSWo5k1Pny_VEbhrVJNFvP5kt_bEGpwjuuqNtEAe1H2thCP9IRMgCQKf4BwCeHe
 IKg_mmGGInyiZ9GxFCm7fvcvmssseiVomcTEakzC__DGU8kzcoiWGAhdGbDVSDgiVl06QY.tlkG.
 tPGqpMbzUQZn8BpBe40jMMCbKXlZCi3tSMSjquos2HLHqwVCpxqkH71qTm2lShk77c2CqWGE9NLU
 zaSRyhBEWe2alyvuA9nho_b37SqEuVWRy9Ofdc_dmpyGUCT0Oe0wlIHolLps.QQ8aNytxa2u4MFD
 RcKqndPGFTLYM3XlhlL46hfFRMFUnikf9yKnyGiKL.HwZ6aeZe0nCRpwqEDf.f6RXZV_olA.620j
 cnZ0p8wOOFmL1z2.F4a9dTJoxRR6dRIDMhCklpz7ZZVKZCRN8wO1aAghPsmomjep.Gbz.pxOglQz
 Sq4W.MeVnsmxh5HJAaRTDc8U.d9_IAZgC2JzpiAO7YgME3jZKcoMLF9xX_HGu_0a_Tp2XbH1iYHW
 8KQyfSjvDz_j1hYbqWWvizWWA1lCfNRUfHSI.oFy9zdhh7Zc-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Sat, 8 Aug 2020 19:07:18 +0000
Date:   Sat, 8 Aug 2020 19:05:17 +0000 (UTC)
From:   Unilever Chain <webse15@ukc.org.in>
Reply-To: supply@unileverchainsupplier.com
Message-ID: <2053881190.1377785.1596913517685@mail.yahoo.com>
Subject: Hospital Equipment Tender
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2053881190.1377785.1596913517685.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16436 YMailNodin Mozilla/5.0 (Windows NT 6.3; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Attention

Unilever Austria Chain urgently looking for a reliable supplier that can supply and delivery hospital equipments; we have been commissioned to source the equipment's for hospital upgrade due to the ongoing COVID-19 PANDEMIC in Vienna, therefore, would like to extend an
Invitation Bid Tender to you or your company to supply and deliver hospital equipment.

If this falls out of your scope, outsource the Equipment (s). Please send your details or company profile for us to issue you more details and the RFQ.

Kindly submit your details to: E-mail: supply@unileverchainsupplier.com

Sincerely,
Gunnar Widhalm
Supply Chain Manager

Tel: +43 1 2675392
Tel: +43 6 703081140
UNILEVER AUSTRIA SUPPLY CHAIN
E-mail: supply@unileverchainsupplier.com
