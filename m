Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E061B6491
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgDWTh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgDWTh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:37:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33E2C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:37:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51D27127789FA;
        Thu, 23 Apr 2020 12:37:27 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:37:26 -0700 (PDT)
Message-Id: <20200423.123726.1072926390352019555.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, irusskikh@marvell.com,
        mkalderon@marvell.com
Subject: Re: [PATCH net-next 0/2] qed*: Add support for pcie advanced error
 recovery.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422131322.7147-1-skalluru@marvell.com>
References: <20200422131322.7147-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:37:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Wed, 22 Apr 2020 06:13:20 -0700

> The patch series adds qed/qede driver changes for PCIe Advanced Error
> Recovery (AER) support.
> Patch (1) adds qed changes to enable the device to send error messages
> to root port when detected.
> Patch (2) adds qede support for handling the detected errors (AERs).
> 
> Changes from previous version:
> -------------------------------
> v2: use pci_num_vf() instead of caching the value in edev.
> 
> Please consider applying this to "net-next".

Series applied, thank you.
