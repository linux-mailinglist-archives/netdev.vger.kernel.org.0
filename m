Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F14E15AF1A
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgBLRwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:52:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33566 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgBLRwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:52:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9600B13B3AC1F;
        Wed, 12 Feb 2020 09:52:44 -0800 (PST)
Date:   Wed, 12 Feb 2020 09:52:44 -0800 (PST)
Message-Id: <20200212.095244.2041379255661139484.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Re: [v2] ptp_qoriq: add initialization message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212101916.27085-1-yangbo.lu@nxp.com>
References: <20200212101916.27085-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2020 09:52:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Wed, 12 Feb 2020 18:19:16 +0800

> Current ptp_qoriq driver prints only warning or error messages.
> It may be loaded successfully without any messages.
> Although this is fine, it would be convenient to have an oneline
> initialization log showing success and PTP clock index.
> The goods are,
> - The ptp_qoriq driver users may know whether this driver is loaded
>   successfully, or not, or not loaded from the booting log.
> - The ptp_qoriq driver users don't have to install an ethtool to
>   check the PTP clock index for using. Or don't have to check which
>   /sys/class/ptp/ptpX is PTP QorIQ clock.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v2:
> 	- Added more in commit message.

I explained yesterday why your change is inappropriate and why I won't
be applying your patch.

It is not appropriate to send the same patch again with a different
commit message.

What might be appropriate is replying to my email and explaining your
side of the argument and why you think it is appropriate.

You must engage with other developers and discuss your change here on
the list if you want us to consider it still.

Thank you.
