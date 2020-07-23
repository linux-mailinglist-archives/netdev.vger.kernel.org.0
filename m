Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33C622B58A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgGWSV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:21:28 -0400
Received: from sonic305-21.consmr.mail.ne1.yahoo.com ([66.163.185.147]:43871
        "EHLO sonic305-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbgGWSV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595528487; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=TNhbaI6cfC1gvCenfEodh3tHPYuU/HzdiSgVyzTRTOszYVUfVvk+/E/Sxlq6k1/avhZN99GnM+B/TMmPgKJXIhQN2p6sQxjYvrkvkImG4p7ACg7hh4magxNU90hAKdH3fMESqcuVM6MDfZtR1Wy9tzEKu9gyJ0YVBMakTiIzI2vErp4nB27URcKQBDbZKBJ3ZNAAb+LBEX/kpHB5ToaCr/x9IRQ12gvnoiimbEDoxHwxVxZnWALr77u1U7owsg8JgAZuBHHlr1N+X3MimcNKm4CSUWsAZ/MKwIuARcWVXGylpyYk73wYiQxiWcF+0DwHBzo7W6xGq4HFP40pvqyJcw==
X-YMail-OSG: Nd1XLXgVM1kXGFolj5lQIvsWZHjScr6pjL91krhon9C0bmeH3fcwcs0N.Clsjda
 FgLb7Mi3..KhYEWnr9ZmMN1qOpp5acb_wwvsHPe.TB2g.ZwKDtQaXStjH3VY3Z.G6I5d6kuBmP.8
 eX4L_qUVddjmEkULuOWx2Ov_TIMGUPbXN4Sbh48CAPJJZHKxjGuwBllODg2fAwg8XLMSnW6SBxDM
 STMxhtsAaZ7cUBbJZkwGnwjrHo3EqjPWA6cb9JUVx1Kck9SawaSjH.QzZGFmJ0RKr3RROreQV5sp
 75PVXldyrA660JR_fk_uY4xAD6pNm1C1e4EwfSUHJ8evRVB0JlWzxzRCVFHkNUN0KhGZehQCh6My
 RHCKGzFgwcLRpB2KZnRbX6vxg5pSM3AAsJb7eua17U1GG58LbJZS56QECaC0Qj7fX5uvuoUPyHKj
 q7IcDlwaKBHA6FlWZmGdj0vJFNDiC5PX33JuK7Df7XRDqy0e7DgT.pvDAhOVHtGVQ8KoMg0qo2MK
 eX1VwTg5jousEw5SWvH2ob8iMVUQUuFtEf2Ct4MowxBcFvm2aZuQ6ksZP5Hrbr0KDCcWKg1isEyw
 FA7.JTDR.WDzdNOYJKaasrJqMXcuzrmkpo7FWJmnKH.Eqt4Wy36gIiD4S7QTPGSLOxQxMzWvtl_o
 hyzRdu9if_E3drZy0th5CVK9GbiGNb7SqMbEae8hT0jZjGEdvyYqluGjKUW9Rd7jjxXOd9FpF0yh
 VwqHxbF28v5qYHIGe7tzhyGempqWs7oiirQhEWhiJEYfdTg4akQ0qksZ8RvwSs9V1MIzrKCenJi_
 PkyxZgSi3ZiW80fKVkd1aYldk.uJydpuWTghNXNi9vK.h08HEs2iolg_zJ6QkF_G2BqIWIt.9Abe
 NHe_uODLjoGAg1E3ClWICeFmfQ2QzuIjjqObSdCFq39u_4dw3pgIiclXp5fRROU04aEyuUvbtsWg
 _p1cELsGlSZwX5ONJPiw8WghXzWGQZ_wGQpEC.u12JgmJxDIcaSrgdFoFt2Te53T4ZE0J2WXEET.
 M4x5LiD3SDP5MjJZy_j9QIswzGQuOWdP8NB.Mv6R5W93xVUiF9jyUGGPGO6n8fG2JZjo03OG9dq9
 su0DgOcZ2jOlQFHDt7etOTPrPhADKh5Gx7yF5ke0XmuQKz.IUo_TkxhdckxJzGjrKUGwcQxYfcGB
 O5qLjXD68W6kPz06ISICsIix6BCqq_fSBo.qoB4XQ1wdbI1XqhNX.L0b3oyQ5u.mryVGMtZF5uX.
 rjMartVdsJsv3U3r9vVHFFsFzRsttSKdIrcQbmpfM26DT5kBAeIPytnm7w1jN4ZsxyjuZ4WJ43Fl
 pCg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Thu, 23 Jul 2020 18:21:27 +0000
Date:   Thu, 23 Jul 2020 18:21:26 +0000 (UTC)
From:   Mrs m compola <mmrsgrorvinte@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <88614274.6194615.1595528486587@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <88614274.6194615.1595528486587.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Dear Friend, My present internet connection is very slow in case you
received my email in your spam

How are you today?.With due respect to your person and much sincerity
of purpose,Well it is a pleasure to contact you on this regard and i
pray that this will turn out to be everlasting relationship for both
of us. However it's just my urgent need for a Foreign partner that
made me to contact you for this Transaction,I got your contact from
internet, while searching for a reliable someone that I can go into
partnership with. I am Mrs.mcompola, from BURKINA FASO, West
Africa .Presently i work in the Bank as bill and exchange manager.

I have the opportunity of transferring the left over fund $5.4 Million
us dollars of one of my Bank clients who died in the collapsing of the
world trade center on september 11th 2001.I have placed this fund to
and escrow account without name of beneficiary.i will use my position
here in the bank to effect a hitch free transfer of the fund to your
bank account and there will be no trace.

I agree that 40% of this money will be for you as my foriegn
partner,50% for me while 10% will be for the expenses that will occur
in this transaction .If you are really interested in my proposal
further details of the Transfer will be forwarded unto you as soon as
I receive your willingness mail for successful transfer.

Yours Faithfully,
Mrs.mcompola444@gmail.com
