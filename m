Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46146CA9C6
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405516AbfJCQrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:47:40 -0400
Received: from ms.lwn.net ([45.79.88.28]:33140 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405322AbfJCQrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:39 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 8A6C22D4;
        Thu,  3 Oct 2019 16:47:38 +0000 (UTC)
Date:   Thu, 3 Oct 2019 10:47:37 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     linux-doc@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: networking: device drivers: Remove stray
 asterisks
Message-ID: <20191003104737.3774a00f@lwn.net>
In-Reply-To: <20191002150956.16234-1-j.neuschaefer@gmx.net>
References: <20191002150956.16234-1-j.neuschaefer@gmx.net>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Oct 2019 17:09:55 +0200
Jonathan Neuschäfer <j.neuschaefer@gmx.net> wrote:

> These asterisks were once references to a line that said:
>   "* Other names and brands may be claimed as the property of others."
> But now, they serve no purpose; they can only irritate the reader.
> 
> Fixes: de3edab4276c ("e1000: update README for e1000")
> Fixes: a3fb65680f65 ("e100.txt: Cleanup license info in kernel doc")
> Fixes: da8c01c4502a ("e1000e.txt: Add e1000e documentation")
> Fixes: f12a84a9f650 ("Documentation: fm10k: Add kernel documentation")
> Fixes: b55c52b1938c ("igb.txt: Add igb documentation")
> Fixes: c4e9b56e2442 ("igbvf.txt: Add igbvf Documentation")
> Fixes: d7064f4c192c ("Documentation/networking/: Update Intel wired LAN driver documentation")
> Fixes: c4b8c01112a1 ("ixgbevf.txt: Update ixgbevf documentation")
> Fixes: 1e06edcc2f22 ("Documentation: i40e: Prepare documentation for RST conversion")
> Fixes: 105bf2fe6b32 ("i40evf: add driver to kernel build system")
> Fixes: 1fae869bcf3d ("Documentation: ice: Prepare documentation for RST conversion")
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

So just FYI: as I applied this, I removed most of the "Fixes" tags.  The
cited commits were adding documentation as plain-text files, so the extra
asterisk was *not* an error to be fixed at that point.  The RST-conversion
patches, instead, should have caught that...

Thanks,

jon
