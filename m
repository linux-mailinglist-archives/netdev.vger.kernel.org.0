Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F30480372
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 19:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhL0SmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 13:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhL0SmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 13:42:21 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51ECC06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 10:42:20 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 4CB3258A88A5A; Mon, 27 Dec 2021 19:42:18 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4173760F94760
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 19:42:18 +0100 (CET)
Date:   Mon, 27 Dec 2021 19:42:18 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netdev@vger.kernel.org
Subject: Re: e1000e: abysmal performance of 8086:15fb rev 20 Ethernet
In-Reply-To: <74r22ns-61qo-rqn3-n41-9or5n96qq89@vanv.qr>
Message-ID: <81r4o6s1-45n4-75ps-nr67-q66r2p3q9o37@vanv.qr>
References: <74r22ns-61qo-rqn3-n41-9or5n96qq89@vanv.qr>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Saturday 2021-08-14 22:16, Jan Engelhardt wrote:

>I have here the following machine:
>
>  Fujitsu Lifebook U7311 laptop (2021)
>  product code VFY:U7311MF5AMDE
>  Family 6 Model 140 Intel "11th gen" Core i5-1135G7
>  i219-LM rev 20 Ethernet chip
>
>and this TGL Eternet performs absolutely miserably, achieving only
>like 1/100th of the supposed RX speed most of the time.
>
>[    0.000000] Linux version 5.14.0-rc5-1-default+ (root@localhost.localdomain) (gcc (SUSE Linux) 11.1.1 20210721 [revision 076930b9690ac3564638636f6b13bbb6bc608aea], GNU ld (GNU Binutils; openSUSE Tumbleweed) 2.36.1.20210326-4) #3 SMP Sat Aug 14 19:29:53 CEST 2021

I find that this is fixed in 5.15(.8).
