Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF552E2F3E
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 22:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgLZV4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 16:56:04 -0500
Received: from h1.fbrelay.privateemail.com ([131.153.2.42]:45658 "EHLO
        h1.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgLZV4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 16:56:03 -0500
X-Greylist: delayed 775 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Dec 2020 16:56:03 EST
Received: from MTA-08-4.privateemail.com (mta-08.privateemail.com [68.65.122.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 01B7A805EF
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 16:42:28 -0500 (EST)
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id 3435D60068
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 16:41:47 -0500 (EST)
Received: from [192.168.0.46] (unknown [10.20.151.227])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id D89AF60051
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 21:41:46 +0000 (UTC)
Date:   Sat, 26 Dec 2020 16:41:40 -0500
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Solidrun ClearFog Base and Huawei MA5671A SFP
To:     netdev@vger.kernel.org
Message-Id: <GXUYLQ.NU2JKDF3FRP51@effective-light.com>
X-Mailer: geary/3.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey, has anyone got the ClearFog (ARMADA 388 SoC) to work with the 
MA5671A? I've to been trying to get the ClearFog to read the MA5671A's 
EEPROM however it always throws the following error:

 > # dmesg | grep sfp
 > [ 4.550651] sfp sfp: Host maximum power 2.0W
 > [ 5.875047] sfp sfp: please wait, module slow to respond
 > [ 61.295045] sfp sfp: failed to read EEPROM: -6

I've tried to increase the retry timeout in `/drivers/net/phy/sfp.c` 
(i.e. T_PROBE_RETRY_SLOW) so far, any suggestions would be appreciated. 
Also, I'm on kernel version 5.9.13.


