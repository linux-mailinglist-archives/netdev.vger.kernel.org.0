Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91357BF3AD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfIZNGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:06:17 -0400
Received: from foss.arm.com ([217.140.110.172]:49152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfIZNGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 09:06:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58226142F;
        Thu, 26 Sep 2019 06:06:16 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B6E63F763;
        Thu, 26 Sep 2019 06:06:14 -0700 (PDT)
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
Message-ID: <2f338b57-b0b2-e439-6089-72e5f5e4f017@arm.com>
Date:   Thu, 26 Sep 2019 14:06:12 +0100
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

Hi Jianyong,

On 26/09/2019 12:42, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which includs
> large part of arch-specific code.  This patch move all of those code
> into new arch related file in the same directory.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>   drivers/ptp/Makefile                 |  1 +
>   drivers/ptp/{ptp_kvm.c => kvm_ptp.c} | 77 ++++++------------------
>   drivers/ptp/ptp_kvm_x86.c            | 87 ++++++++++++++++++++++++++++
>   include/asm-generic/ptp_kvm.h        | 12 ++++
>   4 files changed, 118 insertions(+), 59 deletions(-)
>   rename drivers/ptp/{ptp_kvm.c => kvm_ptp.c} (63%)

minor nit: Could we not skip renaming the file ? Given
you are following the ptp_kvm_* for the arch specific
files and the header files, wouldn't it be good to
keep ptp_kvm.c ?

Rest looks fine.

Cheers
Suzuki
