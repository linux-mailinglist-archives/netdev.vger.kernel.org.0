Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A8623134A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgG1T5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgG1T5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:57:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D047C061794;
        Tue, 28 Jul 2020 12:57:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C0A6128A1DBC;
        Tue, 28 Jul 2020 12:40:19 -0700 (PDT)
Date:   Tue, 28 Jul 2020 12:57:03 -0700 (PDT)
Message-Id: <20200728.125703.1154756600985752474.davem@davemloft.net>
To:     vaibhavgupta40@gmail.com
Cc:     helgaas@kernel.org, bhelgaas@google.com, bjorn@helgaas.com,
        vaibhav.varodek@gmail.com, kuba@kernel.org,
        kevin.curtis@farsite.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v1] farsync: use generic power management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
References: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 12:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date: Tue, 28 Jul 2020 09:58:10 +0530

> The .suspend() and .resume() callbacks are not defined for this driver.
> Still, their power management structure follows the legacy framework. To
> bring it under the generic framework, simply remove the binding of
> callbacks from "struct pci_driver".
> 
> Change code indentation from space to tab in "struct pci_driver".
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Applied.
