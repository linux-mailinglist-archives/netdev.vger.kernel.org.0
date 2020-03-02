Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC6117520C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgCBDR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:17:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgCBDR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:17:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5461E13EA945D;
        Sun,  1 Mar 2020 19:17:27 -0800 (PST)
Date:   Sun, 01 Mar 2020 19:17:26 -0800 (PST)
Message-Id: <20200301.191726.2066352230110487395.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] bnxt_en: 2 bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
References: <1583118438-18829-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Mar 2020 19:17:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun,  1 Mar 2020 22:07:16 -0500

> This first patch fixes a rare but possible crash in pci_disable_msix()
> when the MTU is changed.  The 2nd patch fixes a regression in error
> code handling when flashing a file to NVRAM.

Applied.

> Please also queue these for -stable.  Thanks.

Queued up, thanks Michael.
