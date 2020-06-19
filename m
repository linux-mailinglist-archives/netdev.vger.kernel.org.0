Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E6200ACC
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbgFSN5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731794AbgFSN5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:57:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461BCC06174E;
        Fri, 19 Jun 2020 06:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LAV5/s/2D5B3lhz5CBbE1JjwfKpleg8M/EZQLJv3gY0=; b=JyJL+hT/3UDxfhF0s3aTnfKjXz
        4WDgwcRLMVoKg+qSDE9yLxzSco+H+pQ5Wb81Ou3fMfUQ/D/PUj99vJvG8DVfHMK7Xit5EUflkCXHg
        NVjSoMF1iXJkFyunmO4bT0bhYKqy8plu+KhCaWDYL5rTcS+0HqBZ2l2cO31jrjswYnTHix3XxuIdh
        CLa7YNXieoKzxyNI69zTga5BeVIp2nuN6JUkyNZVDF48paS3Z97GcqjEXS4SbkETaMrcC7oCiPtz7
        ebga12ePId6FrnHzkZ06/ly0HjW7/bElp6nlinv8nqqvH/e7fLXCA9LkJfD50awg4CtQOX9My32fH
        tAIxb96w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmHW8-0000yl-Di; Fri, 19 Jun 2020 13:57:16 +0000
Date:   Fri, 19 Jun 2020 06:57:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com, justin.he@arm.com,
        Wei.Chen@arm.com, kvm@vger.kernel.org, Steve.Capper@arm.com,
        linux-kernel@vger.kernel.org, Kaly.Xin@arm.com, nd@arm.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 3/9] smccc: Export smccc conduit get helper.
Message-ID: <20200619135716.GA14308@infradead.org>
References: <20200619130120.40556-1-jianyong.wu@arm.com>
 <20200619130120.40556-4-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619130120.40556-4-jianyong.wu@arm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 09:01:14PM +0800, Jianyong Wu wrote:
> Export arm_smccc_1_1_get_conduit then modules can use smccc helper which
> adopts it.
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/firmware/smccc/smccc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
> index 4e80921ee212..b855fe7b5c90 100644
> --- a/drivers/firmware/smccc/smccc.c
> +++ b/drivers/firmware/smccc/smccc.c
> @@ -24,6 +24,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
>  
>  	return smccc_conduit;
>  }
> +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);

EXPORT_SYMBOL_GPL, please.

