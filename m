Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477261E6DF9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436712AbgE1VoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436581AbgE1VoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:44:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30FFC08C5C6;
        Thu, 28 May 2020 14:43:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4CBEE129654F2;
        Thu, 28 May 2020 14:43:59 -0700 (PDT)
Date:   Thu, 28 May 2020 14:43:58 -0700 (PDT)
Message-Id: <20200528.144358.1981651162176500485.davem@davemloft.net>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/4] vmxnet3: add geneve and vxlan tunnel
 offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528213204.29803-4-doshir@vmware.com>
References: <20200528213204.29803-1-doshir@vmware.com>
        <20200528213204.29803-4-doshir@vmware.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 14:43:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>
Date: Thu, 28 May 2020 14:32:02 -0700

> +			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
> +			BUG_ON(gdesc->rcd.frg &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
 ...
> +			BUG_ON(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
> +			BUG_ON(gdesc->rcd.frg &&
> +			       !(le32_to_cpu(gdesc->dword[0]) &
> +				 (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));

Just to be clear I'm not applying stuff like this.
