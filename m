Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C29151293
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 23:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgBCWv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 17:51:28 -0500
Received: from sonic312-26.consmr.mail.ir2.yahoo.com ([77.238.178.97]:45289
        "EHLO sonic312-26.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgBCWv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 17:51:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580770286; bh=srSSudHe1RrXYdGiaelsLUbrzyx8PFKN4IDnMPfNsF8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=DWSpin45vxNXMPgAHG92VulNLgkt0fhbL2qUP4IfRYCZGXL9dVj7SKZdJEeqzUmQL0IZe0CAZRDZuchpQNBd4sSPTSGsTR+xtdqbzl7yxpqLCK7pf0g2bVBZgLQ1PdVJa/O2KV2A/k0GNxyHrCax7IvXLKszr0zyZgPg9E+M3hmuC4FgSvAFsoOx/ZfDpYKUde1jhlnVSiPwFCHJdvIQmn2sL9XSBK2uEd8slmipDFQ8U9ptEvVMoZAdzIEnJkYf2xEQmQhm6yHBdHkq1B9eqr5NQiZn1xitiTKV/e4FT9bhH935JasZUXjz31x/2QyK0cq7VKtJLicIdU7IWUgZtg==
X-YMail-OSG: Z5GVWmMVM1kWStEyWhiwodohuw3OFGcV8W.OUtA_2Dqk.H1qxTFRrflc630OoQa
 w8qZIFdIF7LW3AAocGgYuc4zL3le_B3XBnsHumSLeENvISQ7Iw0LWUvHGWFsvYMrekylY88RWhyr
 aZVWsWxl6iQm3lFUOuV5RETewjzbUNqjDZbtrO_fMx5BuR7xNUtjdTGH5mTRlkqn782jrch3R3BG
 AIRrE5JcsT9f3oLqxRwsHNV2AOWgOnp4D1UrIe.wC67uSpPm7hQuLcfSY1f6X9W2KpaCSMidsZ2t
 l41P4le3j4_rFP0hcN2AOPFz2ZjbBoBgNYr_WIZE1dVrCWiuDqhBvpP90GlxVhHuGubst4skG2jP
 SQ1Sz.yDbAO2LFdliu9XckZZ30KZu.qNoTcRLZlZGoycijO17SszxVKSfahVKbuRtKF8eon9SuzY
 oa3qk.N9whqvD2uc0HDjHYEs_RCX7fs7F3U0XicAMCUjWe7kzHNHHp8SgXNEASfenwVa7y1paiCR
 BIewcEoN34W.6MiCApZo14Mp69AQ_vDqzhs6knBHI_TOPCSYHqKK1OSgPvH1T21yQ1uLID57_517
 NhlhD8Cfn4KTKFQVfe1RgJ23zqwf4dbFWdwXhGBOzhgaRXo7zl15831aUHfD6Wv6yVugnYQyJqjR
 rHahfu.CY.uZgaE84CkVKOCErXwqgx1liuziZ6OlYOSq_V0kgcEQWNhvUEAPP1FEJLmMgot8GxsS
 Rguu_6Rdda0rhfUvuJhA2gqEedMx6xcKRM1n2WM4YjloTyfd_j3qzdttcjX3lVB7V4mvPZoXwmPG
 asp9eM6gVbDJAuyaUM9ZlEcU1CI4Am_a5cCK7jBTvjRyLnyeXOpICJs.JK4wZZsyNW2587_Rk1V4
 3yCf0K.y6Fl6G5l1xR0pjy3l4Aq9pziCEEwlbLRHnaRe2jyl.22AxE1kCbkclP.kD4kdwjGAW19A
 rBEI.y.1fEAqNksLegqQl4K2xdTsISzIhc6vU2wfGXFgkb6F6WDRvwdzl1VUygIHoipcNiLYGEs6
 LxuE3awrLZUn1dWchucEF_ElgZ_SZ5P2WWMfyJnUvKw.Z1veohKuiRynuBDnEHUphzQAS87Y_hiI
 qETqtx5BMhlOm6kR77kMqkq32sc9TULxGsOV0.qj8rdCPVxGlx6C.tQO6ud5EKMBVnWP0aKR8ujk
 Na9zaZczDey6JAYZHljZev.D3UUJAKXH2nh_efyPOcdocTtteJI6Sw51hINfMLHhZR8K6hqVAGkd
 lJQDe9lvQ5w7yndaLK40DcZl8VPJ21kmE9RAohOPkrG5dCQnEwMA6BVzkAWZVAruPyxEtnppIVss
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ir2.yahoo.com with HTTP; Mon, 3 Feb 2020 22:51:26 +0000
Date:   Mon, 3 Feb 2020 22:51:23 +0000 (UTC)
From:   Pamela Render <sgt.prrender@gmail.com>
Reply-To: sgt.prender@gmail.com
Message-ID: <2142678201.2066840.1580770283490@mail.yahoo.com>
Subject: Hi
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2142678201.2066840.1580770283490.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15149 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi dear friend, Good day to you, I'm Pamela Render, from united states, please do you speak english. With Love.

Thanks and regards.
Pamela Render


Sent From United Nations Wireless Device Server==================
