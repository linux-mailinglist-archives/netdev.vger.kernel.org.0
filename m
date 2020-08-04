Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332F823B83F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgHDJzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgHDJzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:55:18 -0400
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Aug 2020 02:55:17 PDT
Received: from mail.mimuw.edu.pl (mail.mimuw.edu.pl [IPv6:2001:6a0:5001::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E180FC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 02:55:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by duch.mimuw.edu.pl (Postfix) with ESMTP id 2EDFE61A2018B;
        Tue,  4 Aug 2020 11:46:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mimuw.edu.pl
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
Received: from duch.mimuw.edu.pl ([127.0.0.1])
        by localhost (mail.mimuw.edu.pl [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ivJ-rn9kRvMT; Tue,  4 Aug 2020 11:46:20 +0200 (CEST)
Received: from debian.mimuw.edu.pl (unknown [176.221.123.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by duch.mimuw.edu.pl (Postfix) with ESMTPSA;
        Tue,  4 Aug 2020 11:46:19 +0200 (CEST)
From:   jsbien@mimuw.edu.pl (Janusz S. =?utf-8?Q?Bie=C5=84?=)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     netdev@vger.kernel.org
Subject: The card speed limited to 100 Mb/s
Reply-to: jsbien@mimuw.edu.pl
Date:   Tue, 04 Aug 2020 11:46:19 +0200
Message-ID: <86sgd2g2vo.fsf@mimuw.edu.pl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi!

I follow the instruction from the README.Debian file in
r8168-dkms_8.048.03-1_all.deb.

This is a HP laptop connected to a 150 Mb/s. The HP service claims the
card should be working with the speed up to 300 Mb/s. Both tests and
Setting show the speed of 100 Mb/s only. For videoconferences the
difference can be quite essential.

Best regards

Janusz

root@debian:~# lshw -class network -short
H/W path               Device     Class          Description
============================================================
/0/100/2.2/0           enp2s0     network        RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
/0/100/2.4/0                      network        Realtek Semiconductor Co., Ltd.
/2                     docker0    network        Ethernet interface
root@debian:~# ethtool -i enp2s0 
driver: r8168
version: 8.046.00-NAPI
firmware-version: 
expansion-rom-version: 
bus-info: 0000:02:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no


-- 
             ,   
Janusz S. Bien
emeryt (emeritus)
https://sites.google.com/view/jsbien
