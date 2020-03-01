Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C7F174B61
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCAF2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:28:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgCAF2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:28:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40AEC15BD950A;
        Sat, 29 Feb 2020 21:28:00 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:27:59 -0800 (PST)
Message-Id: <20200229.212759.1192215762119235356.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com, jeffrey.t.kirsher@intel.com,
        QLogic-Storage-Upstream@cavium.com, michael.chan@broadcom.com
Subject: Re: [PATCH 1/5] pci: introduce pci_get_dsn
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200227223635.1021197-3-jacob.e.keller@intel.com>
References: <20200227223635.1021197-1-jacob.e.keller@intel.com>
        <20200227223635.1021197-3-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:28:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu, 27 Feb 2020 14:36:31 -0800

> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
> +{
> +	u32 dword;
> +	int pos;
> +
> +

Just one empty line after the local variable declarations please.

Thank you.
