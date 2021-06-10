Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FA53A3166
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhFJQy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFJQyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:54:22 -0400
X-Greylist: delayed 463 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Jun 2021 09:52:25 PDT
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a00:c38:11e:ffff::a032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4313C061574;
        Thu, 10 Jun 2021 09:52:25 -0700 (PDT)
Subject: Re: [PATCH -next] dccp: tfrc: fix doc warnings in tfrc_equation.c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1623343478;
        bh=uZE8Th48OJiDQ9WnoC2cT/ZZKeuF68wKkFGlFE6GfyM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kO1CMB4/qrYS5j+GDCiNhE6VsJiP4E+JGBINvxBsv1d4GlfpzbA9pJ+clT7wpu5fU
         512fMEhyqGLNoXVbTkUJnZvibizz0505/A4ITz1NS9Lrg41Qp4TEhWJ8OFy6ZfGQ7a
         ACysX5sS/gz8FHE+J1W+EwMLK76NlptyHRBLmdqvWAdl09BWvHt+WyUjt6T5KIZ3Ih
         fRlF04R3HX5cfPJxtYY1iYzv1mX2sqgbX8Kue8LiBbCnMCBg7kf6fNAC6WuFta4fwE
         QZduAHYrrhQdjJFxuBr5ptFtrDCO/QXXyKp2BVWQG7E8aVweZED4Sa6lDEGWqgDSU/
         4Oon8JiheHTjA==
To:     Baokun Li <libaokun1@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     weiyongjun1@huawei.com, yuehaibing@huawei.com,
        yangjihong1@huawei.com, yukuai3@huawei.com
References: <20210610132603.597563-1-libaokun1@huawei.com>
From:   Richard Sailer <richard_siegfried@systemli.org>
Message-ID: <1ef2e838-5cf9-c121-624d-3c6e5d5f1649@systemli.org>
Date:   Thu, 10 Jun 2021 18:44:35 +0200
MIME-Version: 1.0
In-Reply-To: <20210610132603.597563-1-libaokun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just adds a correct comment. Looks fine to me.

Reviewed-by: Richard Sailer <richard_siegfried@systemli.org>

On 10/06/2021 15:26, Baokun Li wrote:
> Add description for `tfrc_invert_loss_event_rate` to fix the W=1 warnings:
> 
>   net/dccp/ccids/lib/tfrc_equation.c:695: warning: Function parameter or
>    member 'loss_event_rate' not described in 'tfrc_invert_loss_event_rate'
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>   net/dccp/ccids/lib/tfrc_equation.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/dccp/ccids/lib/tfrc_equation.c b/net/dccp/ccids/lib/tfrc_equation.c
> index e2a337fa9ff7..92a8c6bea316 100644
> --- a/net/dccp/ccids/lib/tfrc_equation.c
> +++ b/net/dccp/ccids/lib/tfrc_equation.c
> @@ -688,6 +688,7 @@ u32 tfrc_calc_x_reverse_lookup(u32 fvalue)
>   
>   /**
>    * tfrc_invert_loss_event_rate  -  Compute p so that 10^6 corresponds to 100%
> + * @loss_event_rate: loss event rate to invert
>    * When @loss_event_rate is large, there is a chance that p is truncated to 0.
>    * To avoid re-entering slow-start in that case, we set p = TFRC_SMALLEST_P > 0.
>    */
> 
