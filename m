Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590B110108C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKSBPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:15:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfKSBPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:15:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C575F150FA115;
        Mon, 18 Nov 2019 17:15:38 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:15:38 -0800 (PST)
Message-Id: <20191118.171538.421891218632979728.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/9] bnxt_en: Updates.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
References: <1574067403-4344-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:15:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 18 Nov 2019 03:56:34 -0500

> This series has the firmware interface update that changes the aRFS/ntuple
> interface on 57500 chips.  The 2nd patch adds a counter and improves
> the hardware buffer error handling on the 57500 chips.  The rest of the
> series is mainly enhancements on error recovery and firmware reset.

All looks pretty sane, series applied, thanks.
