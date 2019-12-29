Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8204E12CA94
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 20:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfL2TOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 14:14:38 -0500
Received: from einhorn-mail.in-berlin.de ([217.197.80.20]:48003 "EHLO
        einhorn-mail.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfL2TOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 14:14:38 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Dec 2019 14:14:36 EST
X-Envelope-From: willi@hobbit.in-berlin.de
Received: from authenticated.user (localhost [127.0.0.1]) by einhorn.in-berlin.de  with ESMTPSA id xBTJ4fHi013399
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sun, 29 Dec 2019 20:04:42 +0100
To:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
From:   Winfried Winkler <willi@hobbit.in-berlin.de>
Subject: Realtek Network Driver - r8168-dkms needed
Autocrypt: addr=willi@hobbit.in-berlin.de; prefer-encrypt=mutual; keydata=
 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
 EQ923REaRP0=
Message-ID: <58a8d231-9ef9-47a1-7368-04737237270e@hobbit.in-berlin.de>
Date:   Sun, 29 Dec 2019 20:04:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sirs,
the Debian ReadMe told to me to write this EMail, sorry if this might be
considered spam...

It said:
 "If no version of the in-kernel driver r8169 supports your NIC,
  please report this to the r8169 maintainers, so that this can
  be fixed"

My new Asus motherboard has an RTL8117 network chip that is NOT working
with the in-kernel 8169 driver, it needs the external 8168-dkms driver.

Board:
https://www.asus.com/Motherboards/Pro-WS-X570-ACE/specifications/

"lspci" Output is:
05:00.1 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 1a)

Tested with latest stable kernel (5.4.6) at the time of this writing.

Feel free to request any additional info needed that I might be able to
supply -- thanks for listening.

Happy new year and thanks for all the work you're doing,
 Winfried Winkler
