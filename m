Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C232716B5AE
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgBXXdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:33:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXXdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:33:54 -0500
Received: from localhost (unknown [50.226.181.18])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50CCD124CE3F3;
        Mon, 24 Feb 2020 15:33:53 -0800 (PST)
Date:   Mon, 24 Feb 2020 15:33:52 -0800 (PST)
Message-Id: <20200224.153352.364779446032996784.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     bhelgaas@google.com, nic_swsd@realtek.com, mlindner@marvell.com,
        stephen@networkplumber.org, clemens@ladisch.de, perex@perex.cz,
        tiwai@suse.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/9] PCI: add and use constant PCI_STATUS_ERROR_BITS
 and helper pci_status_get_and_clear_errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
References: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Feb 2020 15:33:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 24 Feb 2020 22:20:08 +0100

> Few drivers have own definitions for this constant, so move it to the
> PCI core. In addition there are several places where the following
> code sequence is used:
> 1. Read PCI_STATUS
> 2. Mask out non-error bits
> 3. Action based on set error bits
> 4. Write back set error bits to clear them
> 
> As this is a repeated pattern, add a helper to the PCI core.
> 
> Most affected drivers are network drivers. But as it's about core
> PCI functionality, I suppose the series should go through the PCI
> tree.

Heiner, something is up with this submission.

The subject line here says 0/9, but the patches say N/8 and patch #8 never
showed up on the list.

Sort out what this should be and resubmit, thank you.
