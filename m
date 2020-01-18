Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996931417C0
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 14:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgARNsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 08:48:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41720 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgARNsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 08:48:05 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F39DF153D30F7;
        Sat, 18 Jan 2020 05:48:03 -0800 (PST)
Date:   Sat, 18 Jan 2020 14:48:02 +0100 (CET)
Message-Id: <20200118.144802.948651720188977971.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
References: <1579239167-16362-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Jan 2020 05:48:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Fri, 17 Jan 2020 00:32:44 -0500

> 3 small bug fix patches.  The 1st two are aRFS fixes and the last one
> fixes a fatal driver load failure on some kernels without PCIe
> extended config space support enabled.

Applied.

> Please also queue these for -stable.  Thanks.

Done.
