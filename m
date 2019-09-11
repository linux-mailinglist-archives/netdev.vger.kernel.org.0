Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD268AF7B1
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfIKIYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:24:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40134 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfIKIYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:24:05 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77ABE15567B23;
        Wed, 11 Sep 2019 01:24:03 -0700 (PDT)
Date:   Wed, 11 Sep 2019 10:24:02 +0200 (CEST)
Message-Id: <20190911.102402.1190991958573233070.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     alexander.h.duyck@linux.intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, gleventhal@janestreet.com,
        andrewx.bowers@intel.com
Subject: Re: [net-next 11/14] ixgbe: Prevent u8 wrapping of ITR value to
 something less than 10us
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910163434.2449-12-jeffrey.t.kirsher@intel.com>
References: <20190910163434.2449-1-jeffrey.t.kirsher@intel.com>
        <20190910163434.2449-12-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 01:24:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 10 Sep 2019 09:34:31 -0700

> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> There were a couple cases where the ITR value generated via the adaptive
> ITR scheme could exceed 126. This resulted in the value becoming either 0
> or something less than 10. Switching back and forth between a value less
> than 10 and a value greater than 10 can cause issues as certain hardware
> features such as RSC to not function well when the ITR value has dropped
> that low.
> 
> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Please remove this from the series, add the Fixes: tag, and submit for 'net'
since Alexander says it is -stable material.

Thanks.
