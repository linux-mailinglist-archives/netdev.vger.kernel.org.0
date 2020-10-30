Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171AB2A1044
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgJ3ViE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3ViD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 17:38:03 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DA1F22227;
        Fri, 30 Oct 2020 21:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604093883;
        bh=Fr3uhZQqfUvLpOJtTZYPOZ73Scwwd1jPlmKG5rQh848=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VxaDHjWyTKmO/66+6ntPkcRAfhYF5VAyoMJZTJirsuXTcT6og2Wv1z2hegVjYa2Cg
         7PO0rxPdlCibDcIC2XFniDxjheM4dnD9Yt1+pLGz1ctRHvXBZLAXcQcoCeRWUnve9+
         lfW8OYSQV7/XRXTzmqd4+CE4uPzp9B7lIZ7zLRYo=
Date:   Fri, 30 Oct 2020 14:38:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/1] ptp: idt82p33: add adjphase support
Message-ID: <20201030143802.3c7520d2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1604080532-22410-1-git-send-email-min.li.xe@renesas.com>
References: <1604080532-22410-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 13:55:32 -0400 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjwritephase() to support PHC write phase mode.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Doesn't build on 32bit.

make[2]: *** Deleting file 'Module.symvers'
ERROR: modpost: "__divdi3" [drivers/ptp/ptp_idt82p33.ko] undefined!
make[2]: *** [Module.symvers] Error 1
make[1]: *** [modules] Error 2
make: *** [__sub-make] Error 2
