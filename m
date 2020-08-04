Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B940023BDEA
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgHDQR4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Aug 2020 12:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgHDQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 12:17:52 -0400
Received: from mail.mimuw.edu.pl (mail.mimuw.edu.pl [IPv6:2001:6a0:5001::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB3EC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 09:17:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by duch.mimuw.edu.pl (Postfix) with ESMTP id 74FC361A3AEDB;
        Tue,  4 Aug 2020 18:17:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mimuw.edu.pl
Received: from duch.mimuw.edu.pl ([127.0.0.1])
        by localhost (mail.mimuw.edu.pl [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id S3y-5HxWS3V9; Tue,  4 Aug 2020 18:17:47 +0200 (CEST)
Received: from debian.mimuw.edu.pl (unknown [176.221.123.130])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by duch.mimuw.edu.pl (Postfix) with ESMTPSA;
        Tue,  4 Aug 2020 18:17:46 +0200 (CEST)
From:   jsbien@mimuw.edu.pl (Janusz S. =?utf-8?Q?Bie=C5=84?=)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org
Subject: Re: The card speed limited to 100 Mb/s
References: <86sgd2g2vo.fsf@mimuw.edu.pl>
Reply-to: jsbien@mimuw.edu.pl
Date:   Tue, 04 Aug 2020 18:17:46 +0200
In-Reply-To: <86sgd2g2vo.fsf@mimuw.edu.pl> ("Janusz S. \=\?utf-8\?Q\?Bie\=C5\=84\?\=
 \=\?utf-8\?Q\?\=22's\?\= message of
        "Tue, 04 Aug 2020 11:46:19 +0200")
Message-ID: <86wo2eo05x.fsf@mimuw.edu.pl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I apologize for a false alarm - the cable had to be replaced.

Regards

Janusz

On Tue, Aug 04 2020 at 11:46 +02, Janusz S. Bień wrote:
> Hi!
>
> I follow the instruction from the README.Debian file in
> r8168-dkms_8.048.03-1_all.deb.
>
> This is a HP laptop connected to a 150 Mb/s. The HP service claims the
> card should be working with the speed up to 300 Mb/s. Both tests and
> Setting show the speed of 100 Mb/s only. For videoconferences the
> difference can be quite essential.
>
> Best regards
>
> Janusz
>
> root@debian:~# lshw -class network -short
> H/W path               Device     Class          Description
> ============================================================
> /0/100/2.2/0           enp2s0     network        RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
> /0/100/2.4/0                      network        Realtek Semiconductor Co., Ltd.
> /2                     docker0    network        Ethernet interface
> root@debian:~# ethtool -i enp2s0 
> driver: r8168
> version: 8.046.00-NAPI
> firmware-version: 
> expansion-rom-version: 
> bus-info: 0000:02:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: yes
> supports-priv-flags: no

-- 
             ,   
Janusz S. Bien
emeryt (emeritus)
https://sites.google.com/view/jsbien
