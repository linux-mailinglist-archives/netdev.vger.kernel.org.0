Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D265AFD2A5
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfKOCAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:00:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfKOCAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:00:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7880114B79EAF;
        Thu, 14 Nov 2019 18:00:02 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:00:01 -0800 (PST)
Message-Id: <20191114.180001.1389706230869754572.davem@davemloft.net>
To:     cforno12@linux.vnet.ibm.com
Cc:     netdev@vger.kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH net-net v2] ibmveth: Detect unsupported packets before
 sending to the hypervisor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113210616.55737-1-cforno12@linux.vnet.ibm.com>
References: <20191113210616.55737-1-cforno12@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:00:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cris Forno <cforno12@linux.vnet.ibm.com>
Date: Wed, 13 Nov 2019 15:06:16 -0600

> Currently, when ibmveth receive a loopback packet, it reports an
> ambiguous error message "tx: h_send_logical_lan failed with rc=-4"
> because the hypervisor rejects those types of packets. This fix
> detects loopback packet and assures the source packet's MAC address
> matches the driver's MAC address before transmitting to the
> hypervisor.
> 
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
> changes in v2
> -demoted messages to netdev_dbg
> -reversed christmas tree ordering for local variables

Applied, thank you.
