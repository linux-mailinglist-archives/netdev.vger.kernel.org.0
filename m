Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39AA7C0359
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfI0KXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:23:08 -0400
Received: from foss.arm.com ([217.140.110.172]:48276 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfI0KXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 06:23:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB44528;
        Fri, 27 Sep 2019 03:23:07 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D4163F534;
        Fri, 27 Sep 2019 03:23:05 -0700 (PDT)
Subject: Re: [RFC PATCH v4 2/5] ptp: Reorganize ptp_kvm modules to make it
 arch-independent.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-3-jianyong.wu@arm.com>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <47ceb25c-c9ff-e284-43bf-6cac7e128a98@arm.com>
Date:   Fri, 27 Sep 2019 11:23:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20190926114212.5322-3-jianyong.wu@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/09/2019 12:42, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which includs
> large part of arch-specific code.  This patch move all of those code
> into new arch related file in the same directory.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>

...

> +int kvm_arch_ptp_get_clock_fn(unsigned long *cycle, struct timespec64 *tspec,
> +			      struct clocksource **cs)


> diff --git a/include/asm-generic/ptp_kvm.h b/include/asm-generic/ptp_kvm.h
> new file mode 100644
> index 000000000000..208e842bfa64
> --- /dev/null
> +++ b/include/asm-generic/ptp_kvm.h

> +int kvm_arch_ptp_get_clock_fn(long *cycle,
> +		struct timespec64 *tspec, void *cs);
> 

Conflicting types for kvm_arch_ptp_get_clock_fn() ?

Suzuki
