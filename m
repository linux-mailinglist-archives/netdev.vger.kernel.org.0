Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96ACFD8DE0
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392414AbfJPK0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:26:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49627 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730972AbfJPK0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 06:26:24 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKgVU-0002kt-VI; Wed, 16 Oct 2019 12:26:17 +0200
Date:   Wed, 16 Oct 2019 12:26:16 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
In-Reply-To: <HE1PR0801MB1676B967505C44D385F21E6DF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <alpine.DEB.2.21.1910161224050.2046@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com> <20191015104822.13890-4-jianyong.wu@arm.com> <alpine.DEB.2.21.1910152047490.2518@nanos.tec.linutronix.de> <HE1PR0801MB1676B967505C44D385F21E6DF4920@HE1PR0801MB1676.eurprd08.prod.outlook.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019, Jianyong Wu (Arm Technology China) wrote:
> On Wed, 16 Oct 2019, Thomas Gleixner wrote:
> > On Tue, 15 Oct 2019, Jianyong Wu wrote:
> > +/* Enum to give clocksources a unique identifier */ enum
> > +clocksource_ids {
> > +	CSID_GENERIC		= 0,
> > +	CSID_ARM_ARCH_COUNTER,
> > +	CSID_MAX,
> > +};
> > +
> 
> Does this mean I must add clocksource id for all kinds of ARCHs and
> update all the code which have checked clocksource in the old way?

What is the old way? No code exists which can access the current
clocksource pointer because the core code does not expose it at all.

Thanks,

	tglx
