Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39A4D80C8
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbfJOUNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:13:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46370 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbfJOUNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:13:39 -0400
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iKTCF-0007g6-KH; Tue, 15 Oct 2019 22:13:31 +0200
Date:   Tue, 15 Oct 2019 22:13:30 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v5 3/6] timekeeping: Add clocksource to
 system_time_snapshot
In-Reply-To: <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
Message-ID: <alpine.DEB.2.21.1910152212580.2518@nanos.tec.linutronix.de>
References: <20191015104822.13890-1-jianyong.wu@arm.com> <20191015104822.13890-4-jianyong.wu@arm.com> <9274d21c-2c43-2e0d-f086-6aaba3863603@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Oct 2019, Paolo Bonzini wrote:
> On 15/10/19 12:48, Jianyong Wu wrote:
> >  
> > 
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

You're sure about having reviewed that in detail?

Thanks,

	tglx
