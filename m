Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0847D1EAEBA
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgFAS4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgFAS4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:56:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2237FC061A0E;
        Mon,  1 Jun 2020 11:56:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 256E1120ED483;
        Mon,  1 Jun 2020 11:56:29 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:56:28 -0700 (PDT)
Message-Id: <20200601.115628.932125543367472654.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/3] bridge: mrp: Add support for MRA role
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
References: <20200530180948.1194569-1-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:56:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sat, 30 May 2020 18:09:45 +0000

> This patch series extends the MRP with the MRA role.
> A node that has the MRA role can behave as a MRM or as a MRC. In case there are
> multiple nodes in the topology that has the MRA role then only one node can
> behave as MRM and all the others need to be have as MRC. The node that has the
> higher priority(lower value) will behave as MRM.
> A node that has the MRA role and behaves as MRC, it just needs to forward the
> MRP_Test frames between the ring ports but also it needs to detect in case it
> stops receiving MRP_Test frames. In that case it would try to behave as MRM.
> 
> v2:
>  - add new patch that fixes sparse warnings
>  - fix parsing of prio attribute

Series applied, thank you.
