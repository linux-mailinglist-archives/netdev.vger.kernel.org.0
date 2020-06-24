Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591A8206AAB
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388705AbgFXDdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388187AbgFXDde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 23:33:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C7CC061573;
        Tue, 23 Jun 2020 20:33:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B10A12986338;
        Tue, 23 Jun 2020 20:33:33 -0700 (PDT)
Date:   Tue, 23 Jun 2020 20:33:31 -0700 (PDT)
Message-Id: <20200623.203331.577057867637454372.davem@davemloft.net>
To:     vaibhavgupta40@gmail.com
Cc:     helgaas@kernel.org, bhelgaas@google.com, bjorn@helgaas.com,
        kuba@kernel.org, vaibhav.varodek@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] ethernet: dec: tulip: use generic power
 management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
References: <20200622114228.60027-1-vaibhavgupta40@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 20:33:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date: Mon, 22 Jun 2020 17:12:23 +0530

> Linux Kernel Mentee: Remove Legacy Power Management.
> 
> The purpose of this patch series is to remove legacy power management
> callbacks and invocation of PCI helper functions, from tulip ethernet drivers.
> 
> With legacy PM, drivers themselves are responsible for handling the device's
> power states. And they do this with the help of PCI helper functions like
> pci_enable/disable_device(), pci_set/restore_state(), pci_set_powr_state(), etc.
> which is not recommended.
> 
> In generic PM, all the required tasks are handled by PCI core and drivers need
> to perform device-specific operations only.
> 
> All patches are compile-tested only.

Series applied to net-next, thanks.
