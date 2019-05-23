Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A382273BE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfEWBDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:03:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:03:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6133815043944;
        Wed, 22 May 2019 18:03:35 -0700 (PDT)
Date:   Wed, 22 May 2019 18:03:34 -0700 (PDT)
Message-Id: <20190522.180334.1162792880871636064.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/4] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
References: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 18:03:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Wed, 22 May 2019 19:12:53 -0400

> There are 4 driver fixes in this series:
> 
> 1. Fix RX buffer leak during OOM condition.
> 2. Call pci_disable_msix() under correct conditions to prevent hitting BUG.
> 3. Reduce unneeded mmeory allocation in kdump kernel to prevent OOM.
> 4. Don't read device serial number on VFs because it is not supported.

Series applied.

> Please queue #1, #2, #3 for -stable as well.  Thanks.

Queued up, thank you.
