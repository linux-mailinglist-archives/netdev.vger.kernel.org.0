Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598CD179BB0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388486AbgCDWVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:21:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46816 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388026AbgCDWVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 17:21:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C34C15AD790A;
        Wed,  4 Mar 2020 14:21:34 -0800 (PST)
Date:   Wed, 04 Mar 2020 14:21:33 -0800 (PST)
Message-Id: <20200304.142133.2297314858740854355.davem@davemloft.net>
To:     helgaas@kernel.org
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, mlindner@marvell.com,
        stephen@networkplumber.org, clemens@ladisch.de, perex@perex.cz,
        tiwai@suse.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v4 00/10] PCI: Add and use constant
 PCI_STATUS_ERROR_BITS and helper pci_status_get_and_clear_errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304165904.GA231103@google.com>
References: <20200303.185937.1365050844508788930.davem@davemloft.net>
        <20200304165904.GA231103@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 14:21:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <helgaas@kernel.org>
Date: Wed, 4 Mar 2020 10:59:04 -0600

> On Tue, Mar 03, 2020 at 06:59:37PM -0800, David Miller wrote:
>> 
>> Bjorn, please review and let me know if it is OK to merge this via the
>> networking tree.
> 
> I acked the relevant patches and you're welcome to merge it via
> networking.  Thanks!

Ok, thanks.

Series applied to net-next.

Thanks again everyone.
