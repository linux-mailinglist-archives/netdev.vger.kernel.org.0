Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4525C362F00
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 11:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbhDQJtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 05:49:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16134 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhDQJtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 05:49:49 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FMpB965xkzpVg3;
        Sat, 17 Apr 2021 17:46:25 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 17:49:11 +0800
Subject: Re: [PATCH v19 1/7] arm/arm64: Probe for the presence of KVM
 hypervisor
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
 <20210330145430.996981-2-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <41707ee7-da5e-896b-6362-18cfcf272b5c@huawei.com>
Date:   Sat, 17 Apr 2021 17:49:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210330145430.996981-2-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/30 22:54, Marc Zyngier wrote:
>  #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1

I think it'd be better to keep this definition together with other
wa Function IDs. It's only a cosmetic comment anyway.


Zenghui
