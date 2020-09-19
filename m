Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304B927109E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 23:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgISVRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 17:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISVRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 17:17:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CBBC0613CE;
        Sat, 19 Sep 2020 14:17:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C591511E3E4CF;
        Sat, 19 Sep 2020 14:00:14 -0700 (PDT)
Date:   Sat, 19 Sep 2020 14:17:01 -0700 (PDT)
Message-Id: <20200919.141701.631873638009742060.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: neterion: Remove set but not used
 variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200919074047.26278-1-zhengyongjun3@huawei.com>
References: <20200919074047.26278-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 14:00:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Sat, 19 Sep 2020 15:40:47 +0800

> @@ -179,7 +175,7 @@ enum vxge_hw_status vxge_hw_vpath_intr_disable(
>  		(u32)VXGE_HW_INTR_MASK_ALL,
>  		&vp_reg->vpath_general_int_mask);
>  
> -	val64 = VXGE_HW_TIM_CLR_INT_EN_VP(1 << (16 - vpath->vp_id));
> +	VXGE_HW_TIM_CLR_INT_EN_VP(1 << (16 - vpath->vp_id));

This makes no sense, this macro is calculating an integer value.

This looks like a mechanical change made without considering what
the code is actually doing or should be doing.
