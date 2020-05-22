Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD01DE7C3
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 15:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgEVNMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 09:12:17 -0400
Received: from foss.arm.com ([217.140.110.172]:35444 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729365AbgEVNMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 09:12:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86F36D6E;
        Fri, 22 May 2020 06:12:16 -0700 (PDT)
Received: from bogus (unknown [10.37.12.95])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C23A03F68F;
        Fri, 22 May 2020 06:12:12 -0700 (PDT)
Date:   Fri, 22 May 2020 14:12:06 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com, justin.he@arm.com,
        Wei.Chen@arm.com, kvm@vger.kernel.org, Steve.Capper@arm.com,
        linux-kernel@vger.kernel.org, Kaly.Xin@arm.com, nd@arm.com,
        Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Message-ID: <20200522131206.GA15171@bogus>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-4-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522083724.38182-4-jianyong.wu@arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:37:16PM +0800, Jianyong Wu wrote:
> Export arm_smccc_1_1_get_conduit then modules can use smccc helper which
> adopts it.
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/firmware/psci/psci.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
> index 2937d44b5df4..fd3c88f21b6a 100644
> --- a/drivers/firmware/psci/psci.c
> +++ b/drivers/firmware/psci/psci.c
> @@ -64,6 +64,7 @@ enum arm_smccc_conduit arm_smccc_1_1_get_conduit(void)
>
>  	return psci_ops.conduit;
>  }
> +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
>

I have moved this into drivers/firmware/smccc/smccc.c [1]
Please update this accordingly.

Also this series is floating on the list for a while now, it is time to
drop "RFC" unless anyone has strong objection to the idea here.

--
Regards,
Sudeep

[1] https://git.kernel.org/arm64/c/f2ae97062a48
