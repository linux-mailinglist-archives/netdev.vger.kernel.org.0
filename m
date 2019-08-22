Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC7C9A2F2
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390664AbfHVWcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:32:31 -0400
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47178 "EHLO
        emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731886AbfHVWcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:32:31 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2019 18:32:30 EDT
Received: from darkstar.musicnaut.iki.fi (85-76-87-181-nat.elisa-mobile.fi [85.76.87.181])
        by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 2343DB0028;
        Fri, 23 Aug 2019 01:25:50 +0300 (EEST)
Date:   Fri, 23 Aug 2019 01:25:50 +0300
From:   Aaro Koskinen <aaro.koskinen@iki.fi>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mips@vger.kernel.org
Subject: r8169: regression on MIPS/Loongson
Message-ID: <20190822222549.GF30291@darkstar.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

After upgrading from v5.2 to v5.3-rc5 on MIPS/Loongson board, copying
large files from network with scp started to fail with "Integrity error".
Bisected to:

f072218cca5b076dd99f3dfa3aaafedfd0023a51 is the first bad commit
commit f072218cca5b076dd99f3dfa3aaafedfd0023a51
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Thu Jun 27 23:19:09 2019 +0200

    r8169: remove not needed call to dma_sync_single_for_device

Any idea what goes wrong? Should this change be reverted?

A.
