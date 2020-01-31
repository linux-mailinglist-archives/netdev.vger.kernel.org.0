Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79CD14F1FD
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgAaSPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:15:09 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56521 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgAaSPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 13:15:09 -0500
Received: from 51.26-246-81.adsl-static.isp.belgacom.be ([81.246.26.51] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1ixaoh-0003Vm-I0; Fri, 31 Jan 2020 19:14:55 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 591E0105BDC; Fri, 31 Jan 2020 19:14:49 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     christopher.s.hall@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Cc:     Christopher Hall <christopher.s.hall@intel.com>
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO Driver with PHC interface changes to support additional H/W Features
In-Reply-To: <20191211214852.26317-1-christopher.s.hall@intel.com>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
Date:   Fri, 31 Jan 2020 19:14:49 +0100
Message-ID: <87eevf4hnq.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

christopher.s.hall@intel.com writes:
> From: Christopher Hall <christopher.s.hall@intel.com>
>
> Upcoming Intel platforms will have Time-Aware GPIO (TGPIO) hardware.
> The TGPIO logic is driven by the Always Running Timer (ART) that's
> related to TSC using CPUID[15H] (See Intel SDM Invariant
> Time-Keeping).
>
> The ART frequency is not adjustable. In order, to implement output
> adjustments an additional edge-timestamp API is added, as well, as
> a periodic output frequency adjustment API. Togther, these implement
> equivalent functionality to the existing SYS_OFFSET_* and frequency
> adjustment APIs.
>
> The TGPIO hardware doesn't implement interrupts. For TGPIO input, the
> output edge-timestamp API is re-used to implement a user-space polling
> interface. For periodic input (e.g. PPS) this is fairly efficient,
> requiring only a marginally faster poll rate than the input event
> frequency.

I really have a hard time to understand why this is implemented as part
of PTP while you talk about PPS at the same time.

Proper information about why this approach was chosen and what that
magic device is used for would be really helpful.

Thanks,

        tglx

