Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61222195426
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0Jg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:36:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgC0Jg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 05:36:57 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0474A20714;
        Fri, 27 Mar 2020 09:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585301817;
        bh=Z8y2Z5aEeF+z9UOEIWaU8xA4AEeVbeYYGfvUFYkg0N4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cwitNcsR3Ct67Sr55iKtAw9SxJA30nXNJKETVqhxJqd970o26YqHvJSwiOqSnyGBT
         XCFW3wgR1/MBWJ5fdT/mZHozpIQ3j3cCDYrGm1nnOJKc09cXfQLukeS+wnYq76CVDh
         5nSJEZ9rpGBc5JFG2Ndxa1OGJWIED6eQhxfmjeX4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jHlQ7-00G8Ze-BG; Fri, 27 Mar 2020 09:36:55 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 Mar 2020 09:36:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: Re: [RFC PATCH v10 0/9] Enable ptp_kvm for arm/arm64
In-Reply-To: <HE1PR0801MB167659B867202B6D4B1695BFF4CC0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
 <HE1PR0801MB1676DA6F1AE78462CB524D6AF4160@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <HE1PR0801MB167659B867202B6D4B1695BFF4CC0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Message-ID: <91361abbe0a6550cdc3d10f41729a452@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-27 09:35, Jianyong Wu wrote:
> Hi ,
> 
> Ping ...
> Is there any comments.
> Need some comments to move forward.

Damn, I dropped the ball on this. Sorry about that.

I'll have a look over the weekend.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
