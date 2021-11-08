Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98521449EBB
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 23:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbhKHWrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:47:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhKHWrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 17:47:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBE8B6134F;
        Mon,  8 Nov 2021 22:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636411460;
        bh=Cv6/NH7miMVkWzIxv+M+4e6cGqvbYoabkOSuh8B6w0k=;
        h=Date:From:To:Cc:Subject:From;
        b=Uqd0Xqs3NU6jRwhCBMOXfI+Ep9TukvF/ZI5cTYGsFQN2dUcy9ZUh/2UXplxpYNsiJ
         nv6za0sSN30v3XtXhgEhQugz4nllWoFWtppAdl7QfwMbNPL5DYOovdYchMqJtEslOI
         oxl0bVxHwBLh/gVBqpz5frEws/EmTbzZw/I+2R1zoP9i7zAf4p13W92xA3+Pwi65Fi
         aa+Sj/7VG7oge+x3e1XEKiXZMbtj2rm2xZoLrVTqeTvrJXvCHx0GnE29osWpv1WwDj
         DSyz73I7Bxwo7IUB/z9Ce9hw7S4d8wUu7hMCo/LdOgzgQHn0aOM68v9ic63N1lgD9z
         xygRmoKuPsR+g==
Date:   Mon, 8 Nov 2021 23:44:16 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: about "net: mvpp2: increase MTU limit when XDP enabled"
Message-ID: <20211108234416.660a29b1@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

I am writing regarding your suggestion on the patch I sent 6 months ago:

https://www.mail-archive.com/netdev@vger.kernel.org/msg380830.html

Sorry about the delay :-( I forgot about this patch.

Anyway I don't think it can be done, at least not in a simple way.

Would it be sufficient if I added the maximum MTU
(MVPP2_MAX_RX_BUF_SIZE) to the first error message, in
mvpp2_change_mtu()) ?

+    netdev_err(dev, "Illegal MTU value %d (> %d) for XDP mode\n",
+               mtu, (int)MVPP2_MAX_RX_BUF_SIZE);

Thanks.

Marek
