Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E17A0E11
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfH1XJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:09:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38530 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfH1XJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:09:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0616153B0C96;
        Wed, 28 Aug 2019 16:09:37 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:09:37 -0700 (PDT)
Message-Id: <20190828.160937.1788181909547435040.davem@davemloft.net>
To:     tiwai@suse.de
Cc:     mlindner@marvell.com, stephen@networkplumber.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, swm@swm1.com
Subject: Re: [PATCH] sky2: Disable MSI on yet another ASUS boards (P6Xxxx)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828063119.22248-1-tiwai@suse.de>
References: <20190828063119.22248-1-tiwai@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 16:09:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 28 Aug 2019 08:31:19 +0200

> A similar workaround for the suspend/resume problem is needed for yet
> another ASUS machines, P6X models.  Like the previous fix, the BIOS
> doesn't provide the standard DMI_SYS_* entry, so again DMI_BOARD_*
> entries are used instead.
> 
> Reported-and-tested-by: SteveM <swm@swm1.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Applied, but this is getting suspicious.

It looks like MSI generally is not restored properly on resume on these
boards, so maybe there simply needs to be a generic PCI quirk for that?
