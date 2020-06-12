Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2027C1F71A7
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 03:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgFLBZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 21:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgFLBZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 21:25:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4F6C03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 18:25:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DDDBE128B13FC;
        Thu, 11 Jun 2020 18:25:36 -0700 (PDT)
Date:   Thu, 11 Jun 2020 18:25:35 -0700 (PDT)
Message-Id: <20200611.182535.1488594378013153333.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net 0/4][pull request] Intel Wired LAN Driver Updates
 2020-06-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
References: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 18:25:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Jun 2020 15:50:56 -0700

> This series contains fixes to the iavf driver.
> 
> Brett fixes the supported link speeds in the iavf driver, which was only
> able to report speeds that the i40e driver supported and was missing the
> speeds supported by the ice driver.  In addition, fix how 2.5 and 5.0
> GbE speeds are reported.
> 
> Alek fixes a enum comparison that was comparing two different enums that
> may have different values, so update the comparison to use matching
> enums.
> 
> Paul increases the time to complete a reset to allow for 128 VFs to
> complete a reset.

Pulled, thanks Jeff.
