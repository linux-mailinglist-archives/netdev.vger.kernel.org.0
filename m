Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713F0123929
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfLQWLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:11:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43594 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfLQWLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:11:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6CB6147098F2;
        Tue, 17 Dec 2019 14:11:10 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:11:10 -0800 (PST)
Message-Id: <20191217.141110.248388410704029559.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com
Subject: Re: [PATCH net v2] dpaa2-ptp: fix double free of the ptp_qoriq IRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576510350-28660-1-git-send-email-ioana.ciornei@nxp.com>
References: <1576510350-28660-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 14:11:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Mon, 16 Dec 2019 17:32:30 +0200

> Upon reusing the ptp_qoriq driver, the ptp_qoriq_free() function was
> used on the remove path to free any allocated resources.
> The ptp_qoriq IRQ is among these resources that are freed in
> ptp_qoriq_free() even though it is also a managed one (allocated using
> devm_request_threaded_irq).
> 
> Drop the resource managed version of requesting the IRQ in order to not
> trigger a double free of the interrupt as below:
 ...
> Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
> Cc: Yangbo Lu <yangbo.lu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied and queued up for v5.3 -stable.

Thanks.
