Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE851BACFE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgD0Skw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgD0Skw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:40:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0FDC0610D5;
        Mon, 27 Apr 2020 11:40:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C03F15D5536F;
        Mon, 27 Apr 2020 11:40:51 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:40:50 -0700 (PDT)
Message-Id: <20200427.114050.2017715904275832358.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     nikolay@cumulusnetworks.com, jiri@resnulli.us, ivecera@redhat.com,
        kuba@kernel.org, roopa@cumulusnetworks.com, olteanv@gmail.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v4 00/11] net: bridge: mrp: Add support for
 Media Redundancy Protocol(MRP)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200426132208.3232-1-horatiu.vultur@microchip.com>
References: <20200426132208.3232-1-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:40:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sun, 26 Apr 2020 15:21:57 +0200

> Media Redundancy Protocol is a data network protocol standardized by
> International Electrotechnical Commission as IEC 62439-2. It allows rings of
> Ethernet switches to overcome any single failure with recovery time faster than
> STP. It is primarily used in Industrial Ethernet applications.
> 
> Based on the previous RFC[1][2][3][4][5], and patches[6][7][8], the MRP state
> machine and all the timers were moved to userspace, except for the timers used
> to generate MRP Test frames.  In this way the userspace doesn't know and should
> not know if the HW or the kernel will generate the MRP Test frames. The
> following changes were added to the bridge to support the MRP:
> - the existing netlink interface was extended with MRP support,
> - allow to detect when a MRP frame was received on a MRP ring port
> - allow MRP instance to forward/terminate MRP frames
> - generate MRP Test frames in case the HW doesn't have support for this
> 
> To be able to offload MRP support to HW, the switchdev API  was extend.
 ...

Series applied, thank you.
