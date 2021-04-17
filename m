Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD7C362F30
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhDQKZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 06:25:36 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17010 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhDQKZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 06:25:35 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FMpzP41D7zPr3L;
        Sat, 17 Apr 2021 18:22:09 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 18:24:55 +0800
Subject: Re: [PATCH v19 6/7] KVM: arm64: Add support for the KVM PTP service
To:     Marc Zyngier <maz@kernel.org>
CC:     <netdev@vger.kernel.org>, <yangbo.lu@nxp.com>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <richardcochran@gmail.com>, <Mark.Rutland@arm.com>,
        <will@kernel.org>, <suzuki.poulose@arm.com>,
        <Andre.Przywara@arm.com>, <steven.price@arm.com>,
        <lorenzo.pieralisi@arm.com>, <sudeep.holla@arm.com>,
        <justin.he@arm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@android.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
References: <20210330145430.996981-1-maz@kernel.org>
 <20210330145430.996981-7-maz@kernel.org>
 <5aadf0b4-b9e5-8521-db60-52a0f319cf28@huawei.com>
 <87v98ls2co.wl-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e4130244-10a6-3251-227b-6f99c3c5899b@huawei.com>
Date:   Sat, 17 Apr 2021 18:24:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87v98ls2co.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/17 17:10, Marc Zyngier wrote:
> On Sat, 17 Apr 2021 09:59:39 +0100,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> On 2021/3/30 22:54, Marc Zyngier wrote:
>>> +PTP_KVM support for arm/arm64
>>> +=============================
>>> +
>>> +PTP_KVM is used for high precision time sync between host and guests.
>>> +It relies on transferring the wall clock and counter value from the
>>> +host to the guest using a KVM-specific hypercall.
>>> +
>>> +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
>>
>> Per include/linux/arm-smccc.h, this should be
>> ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID.
> 
> Well spotted. Care to send a patch on top of my kvm-arm64/ptp branch?

Okay. I'll have a patch for that.


Zenghui
