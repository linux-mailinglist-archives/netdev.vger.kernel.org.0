Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D38B3166B44
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 01:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgBUAGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 19:06:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729353AbgBUAGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 19:06:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DD0812350D3F;
        Thu, 20 Feb 2020 16:06:02 -0800 (PST)
Date:   Thu, 20 Feb 2020 16:06:01 -0800 (PST)
Message-Id: <20200220.160601.680326741427052464.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] bnxt_en: shutdown and kexec/kdump related
 fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
References: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 16:06:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Thu, 20 Feb 2020 17:26:33 -0500

> 2 small patches to fix kexec shutdown and kdump kernel driver init issues.

Applied.

> Please also queue these for -stable.  Thanks.

Queued up.

Thank you.
