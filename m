Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68F281FDE
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 02:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgJCAxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 20:53:40 -0400
Received: from sonic316-21.consmr.mail.ne1.yahoo.com ([66.163.187.147]:38580
        "EHLO sonic316-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgJCAxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 20:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601686418; bh=LcsgbWrTWSmcOJf9EzyjatKhkQkt0sGuPVxdgUAFysc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Hbt/LlIIdq5/aqY3M7SF+gJ9yllvBAv2uW0SMRXUadhbb3g9G7Hp7L4xND9TZkYAHvwi4nwNwsK+21sLnZ/sV19Qm43DJsujUqHctmJKc4XBNBchBHXP0FaGa/EsMYIQzzyl88JujLVXRn4o/I4+B+2fPMey2UxcSh2X66aKXaWIZga/wnrWJHRB2wu+WvI/2yubHhA9vqaj54onBVmSyqHrT1pljN2iJNi0xcZXzHURnlh2BF1cs4LLiDcec/kNerT1r4YqKI1yUhuCE6f28cK0k56lbbJlzrwJ5T9TNLwHHj3rGEYx0I7AuWFvCptaa4r/TQJRPWxqTv2wDUzYtw==
X-YMail-OSG: l6F7PtMVM1m8tyxyBr20EtFYQM0flK7VISSf7OYMokopaGYpGdqNF.T8oL1qFqA
 HJ1x8LcTdF5JJn9OPeaMh.O4Vp.dR20mK0Huvr.AzgBjzgi3fVid915yJheiUcmjuxBtE3kIBFCK
 BNQSDMfLFCELBx4CfORveJiblP1aYncOFKzDY7fmgCs6l7LyI7Gbax3hs7ZLKfB0Q2fmHx7Xc6D2
 fSaXhoe83eOuHGyyP22QT5lJN6aVPaHKecfmBLhDNQiAAX09ZLSqeBYPzMyd6CFjvBnqDmRyQO91
 1l5ehfrncw07nKQo5Slm20epRdvl8_z6ELOmTGNF.sNoXkys1aeVWXmn141RfX28QJzrPPmUT71e
 A8F6TvVbRxb0TfQyQSUYmliV8F88CXaOffkJuvQEod6rKXH.N4tYihFKNSjfZbNbT59xwkmHYsLr
 gOHZLzdBa9a_0F9AMguOUc43Yc.cTInUrH0wB5sqQVqMzO5vFmqDagiKx3iD3.u6dtBs5Vjv2iQH
 VmbyFbi0I9kDlfm3sRr5piZ0LX9v44bbuRNkUTPoI2FZe5cWkgTvk3I1qcj1EW_Og5oWc93fh_px
 JRg51sEumLittDl0UDXOUGUlKIoQ40r1pYJSWw9L5OF0paB6ZWzlGa.t9nPGKB9v1kR_c3Eo10DG
 9_sWzyoMyfuOH_gMNoqTFb_1kIgP308YhkzM58ebLoSx6Do9RpoW2leZy2.xQZEhcSWgvFsoYt7M
 n.GXsrbycP4QYHJ6T9z8mGo44QTjl8OEbh.QYOXW0qs2rQGQt8sOWOYATyHf7H7FJvorqiF7B8Sk
 8MjW8aslr9Q6MeonYGI93vp7RX2ygQbISHUOmu5vAQcXRrCs0T3okJSxNOo_Oszvhf6SepSUyK34
 XaJ8vVzSD2RXm.3DA1xI2wfsgii2yIVfYb4SLOetLV.GPhV9Y.g4pp370iVS7NFsRYgF5QScGFZj
 6t6.l3F1wADT2eSuiP6m.gYwJn542KxBxuf0Z8r5oHacIE4lwEJG.Nk6gfyX59eWAsiO3LYgGB6t
 5gt2EHYO9.LyDj1m5MLgQBSQnE5kBEQAMncUEFPs3uVJBBgXAgRNk48V50aPx1aQUsgR4KbNGjkR
 jxTvloemtLm2FdzXZ_qiQEDo1tpxUyRNpeqRhieLtGrafWlQr5pCHOrtHXKVH7NIhKHMCb60h8xk
 3qgt.aU.FKXQdiQe_Zqjjo2TP8c0l_jGVclz1lzNbTWcwnOdqq84Tk76v9PrBXg9FwX76UbKWBOS
 KiRuFY6GHnGf9HCAJdsOpgIcXcU3sYCAJiTUcukKb4coyee88KcEz.Haftr7uWdbhdY1ibiOuRXY
 kt0VT3pGj2lJYfu4By00QOnsfHYPbrzq2PYgegHZUpF73HoKA0xigwXvGYSMSg4toRn1tAGB_ihX
 rhJCWA.y9mhc5nJYrniiQlrggHHAevb7XMaRvhnmrQgIk
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Sat, 3 Oct 2020 00:53:38 +0000
Date:   Sat, 3 Oct 2020 00:53:37 +0000 (UTC)
From:   "Mrs. Aisha Gaddafi." <mj2643979@gmail.com>
Reply-To: aisha208g@gmail.com
Message-ID: <484536879.1457564.1601686417569@mail.yahoo.com>
Subject: hello
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
References: <484536879.1457564.1601686417569.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkFzc2FsYW11IGFsYWlrdW0sDQoNCkkgaGF2ZSBhIGJ1c2luZXNzIFByb3Bvc2FsIGZvciB5
b3UgYW5kIEkgbmVlZCBtdXR1YWwgcmVzcGVjdCwgdHJ1c3QsDQpob25lc3R5LCB0cmFuc3BhcmVu
Y3ksIGFkZXF1YXRlIHN1cHBvcnQgYW5kIGFzc2lzdGFuY2UsIEhvcGUgdG8gaGVhcg0KZnJvbSB5
b3UgZm9yIG1vcmUgZGV0YWlscy4NCg0KV2FybWVzdCByZWdhcmRzDQpNcnMgQWlzaGEgR2FkZGFm
aQ0KDQrYp9mE2LPZhNin2YUg2LnZhNmK2YPZhdiMDQoNCtmE2K/ZiiDYp9mC2KrYsdin2K0g2LnZ
hdmEINmE2YMg2YjYo9mG2Kcg2KjYrdin2KzYqSDYpdmE2Ykg2KfZhNin2K3Yqtix2KfZhSDYp9mE
2YXYqtio2KfYr9mEINmI2KfZhNir2YLYqSDZiNin2YTYo9mF2KfZhtipDQrZiNin2YTYtNmB2KfZ
gdmK2Kkg2YjYp9mE2K/YudmFINin2YTZg9in2YHZiiDZiNin2YTZhdiz2KfYudiv2Kkg2Iwg2YjZ
htij2YXZhCDYo9mGINmG2LPZhdi5INmF2YbZgyDZhNmF2LLZitivINmF2YYNCtin2YTYqtmB2KfY
tdmK2YQuDQoNCtij2K3YsSDYp9mE2KrYrdmK2KfYqg0K2KfZhNiz2YrYr9ipINi52KfYpti02Kkg
2KfZhNmC2LDYp9mB2Yo=
