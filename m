Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B17B614420
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfEFEmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:42:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFEmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:42:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4099112D6D451;
        Sun,  5 May 2019 21:42:33 -0700 (PDT)
Date:   Sun, 05 May 2019 21:42:32 -0700 (PDT)
Message-Id: <20190505.214232.1757348285490810941.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/11] bnxt_en: Driver updates.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:42:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun,  5 May 2019 07:16:57 -0400

> This patch series adds some extended statistics available with the new
> firmware interface, package version from firmware, aRFS support on
> 57500 chips, new PCI IDs, and some miscellaneous fixes and improvements.

Series applied.
