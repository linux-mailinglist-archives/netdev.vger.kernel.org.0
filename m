Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22AED2697D0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgINVig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgINVif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:38:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01019C06174A;
        Mon, 14 Sep 2020 14:38:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD3861282972E;
        Mon, 14 Sep 2020 14:21:46 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:38:33 -0700 (PDT)
Message-Id: <20200914.143833.1403433161550913976.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com, wintera@linux.ibm.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        ivecera@redhat.com
Subject: Re: [PATCH net-next 5/8] bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE
 notifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910172351.5622-6-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
        <20200910172351.5622-6-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 14:21:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 10 Sep 2020 19:23:48 +0200

> From: Alexandra Winter <wintera@linux.ibm.com>
> 
> so the switchdev can notifiy the bridge to flush non-permanent fdb entries
> for this port. This is useful whenever the hardware fdb of the switchdev
> is reset, but the netdev and the bridgeport are not deleted.
> 
> Note that this has the same effect as the IFLA_BRPORT_FLUSH attribute.
> 
> CC: Jiri Pirko <jiri@resnulli.us>
> CC: Ivan Vecera <ivecera@redhat.com>
> CC: Roopa Prabhu <roopa@nvidia.com>
> CC: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

This still needs review by bridge experts.

Thank you.
