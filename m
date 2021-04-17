Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801D7362EDB
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 11:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbhDQJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 05:27:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16597 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhDQJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 05:27:50 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FMnjW26hXz17Qt9;
        Sat, 17 Apr 2021 17:25:03 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Sat, 17 Apr 2021 17:27:13 +0800
Subject: Re: [PATCH v19 4/7] time: Add mechanism to recognize clocksource in
 time_get_snapshot
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
 <20210330145430.996981-5-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <6e5fb440-156d-2b18-b3cd-89b1a09b0239@huawei.com>
Date:   Sat, 17 Apr 2021 17:27:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210330145430.996981-5-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/30 22:54, Marc Zyngier wrote:
> -	u64		cycles;
> -	ktime_t		real;
> -	ktime_t		raw;
> -	unsigned int	clock_was_set_seq;
> -	u8		cs_was_changed_seq;
> +	u64			cycles;
> +	ktime_t			real;
> +	ktime_t			raw;
> +	enum clocksource_ids	cs_id;

nit: worth adding a description for it (on top of the structure)?

> +	unsigned int		clock_was_set_seq;
> +	u8			cs_was_changed_seq;
