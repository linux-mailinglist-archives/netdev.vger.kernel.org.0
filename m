Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9973D215F50
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGFT1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgGFT1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:27:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBB2C061755;
        Mon,  6 Jul 2020 12:27:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 193CD1277EA61;
        Mon,  6 Jul 2020 12:27:49 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:27:48 -0700 (PDT)
Message-Id: <20200706.122748.828248704525141203.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        kuba@kernel.org, jiri@resnulli.us, ivecera@redhat.com,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 02/12] bridge: uapi: mrp: Extend MRP
 attributes for MRP interconnect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706091842.3324565-3-horatiu.vultur@microchip.com>
References: <20200706091842.3324565-1-horatiu.vultur@microchip.com>
        <20200706091842.3324565-3-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:27:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Mon, 6 Jul 2020 11:18:32 +0200

> +struct br_mrp_in_state {
> +	__u16 in_id;
> +	__u32 in_state;
> +};

Put the __u32 first then the __u16.

> +struct br_mrp_in_role {
> +	__u16 in_id;
> +	__u32 ring_id;
> +	__u32 in_role;
> +	__u32 i_ifindex;
> +};

Likewise.

> +struct br_mrp_start_in_test {
> +	__u16 in_id;
> +	__u32 interval;
> +	__u32 max_miss;
> +	__u32 period;
> +};

Likewise.

> +struct br_mrp_in_test_hdr {
> +	__be16 id;
> +	__u8 sa[ETH_ALEN];
> +	__be16 port_role;
> +	__be16 state;
> +	__be16 transitions;
> +	__be32 timestamp;
> +};

Likewise.  Put the larger members first.  There is lots of unnecessary
padding in this structure.

