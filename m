Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BD4233C46
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbgG3Xt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgG3Xt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:49:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E158CC061574;
        Thu, 30 Jul 2020 16:49:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1DC5126C06D8;
        Thu, 30 Jul 2020 16:33:12 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:49:57 -0700 (PDT)
Message-Id: <20200730.164957.117753738942479389.davem@davemloft.net>
To:     lkmlabelt@gmail.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        parri.andrea@gmail.com, skarade@microsoft.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Add validation for untrusted Hyper-V values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728225321.26570-1-lkmlabelt@gmail.com>
References: <20200728225321.26570-1-lkmlabelt@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:33:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andres Beltran <lkmlabelt@gmail.com>
Date: Tue, 28 Jul 2020 18:53:21 -0400

> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest in the host-to-guest ring buffer. Ensure that
> invalid values cannot cause indexing off the end of an array, or
> subvert an existing validation via integer overflow. Ensure that
> outgoing packets do not have any leftover guest memory that has not
> been zeroed out.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>

I need hyperv maintainer reviews before I will apply this.

Thank you.
