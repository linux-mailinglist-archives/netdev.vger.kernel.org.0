Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA40C1B4DC0
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgDVTzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725779AbgDVTzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:55:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80FFC03C1A9;
        Wed, 22 Apr 2020 12:55:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CF35120ED563;
        Wed, 22 Apr 2020 12:55:18 -0700 (PDT)
Date:   Wed, 22 Apr 2020 12:55:17 -0700 (PDT)
Message-Id: <20200422.125517.1989980731519724241.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jgg@ziepe.ca, parav@mellanox.com,
        galpress@amazon.com, selvin.xavier@broadcom.com,
        sriharsha.basavapatna@broadcom.com, benve@cisco.com,
        bharat@chelsio.com, xavier.huwei@huawei.com, yishaih@mellanox.com,
        leonro@mellanox.com, mkalderon@marvell.com, aditr@vmware.com,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com
Subject: Re: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-04-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D940449866D71D@ORSMSX112.amr.corp.intel.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
        <61CC2BC414934749BD9F5BF3D5D940449866D71D@ORSMSX112.amr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 12:55:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Date: Tue, 21 Apr 2020 08:15:59 +0000

> David Miller, I know we have heard from Greg KH and Jason Gunthorpe on the patch
> series and have responded accordingly, I would like your personal opinion on the
> patch series.  I respect your opinion and would like to make sure we appease all the
> maintainers and users involved to get this accepted into the 5.8 kernel.

No major objections from me once you properly and fully address Greg KH et al.'s
feedback.

Thanks.
