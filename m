Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8A01788D1
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387675AbgCDC7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 21:59:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387532AbgCDC7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 21:59:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 93D9F15AFD85F;
        Tue,  3 Mar 2020 18:59:39 -0800 (PST)
Date:   Tue, 03 Mar 2020 18:59:37 -0800 (PST)
Message-Id: <20200303.185937.1365050844508788930.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     bhelgaas@google.com, nic_swsd@realtek.com, mlindner@marvell.com,
        stephen@networkplumber.org, clemens@ladisch.de, perex@perex.cz,
        tiwai@suse.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v4 00/10] PCI: Add and use constant
 PCI_STATUS_ERROR_BITS and helper pci_status_get_and_clear_errors
From:   David Miller <davem@davemloft.net>
In-Reply-To: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
References: <adeb9e6e-9be6-317f-3fc0-a4e6e6af5f81@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 18:59:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Bjorn, please review and let me know if it is OK to merge this via the
networking tree.

Thank you.
