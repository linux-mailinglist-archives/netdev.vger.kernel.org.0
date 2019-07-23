Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEB472129
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388867AbfGWUzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:55:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbfGWUzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:55:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 479E6153BE464;
        Tue, 23 Jul 2019 13:55:24 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:55:23 -0700 (PDT)
Message-Id: <20190723.135523.2171455317152193121.davem@davemloft.net>
To:     tiwai@suse.de
Cc:     netdev@vger.kernel.org, mlindner@marvell.com,
        stephen@networkplumber.org, m.seyfarth@gmail.com
Subject: Re: [PATCH] sky2: Disable MSI on ASUS P6T
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723151525.6526-1-tiwai@suse.de>
References: <20190723151525.6526-1-tiwai@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:55:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Tue, 23 Jul 2019 17:15:25 +0200

> The onboard sky2 NIC on ASUS P6T WS PRO doesn't work after PM resume
> due to the infamous IRQ problem.  Disabling MSI works around it, so
> let's add it to the blacklist.
> 
> Unfortunately the BIOS on the machine doesn't fill the standard
> DMI_SYS_* entry, so we pick up DMI_BOARD_* entries instead.
> 
> BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1142496
> Reported-and-tested-by: Marcus Seyfarth <m.seyfarth@gmail.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Applied and queued up for -stable, thanks.
