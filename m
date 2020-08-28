Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED4625627E
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 23:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgH1VeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 17:34:25 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:32958 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgH1VeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 17:34:21 -0400
Received: from [192.168.0.2] (188-167-68-178.dynamic.chello.sk [188.167.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id CF3E37A0188;
        Fri, 28 Aug 2020 23:34:18 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding style issues
Date:   Fri, 28 Aug 2020 23:34:15 +0200
User-Agent: KMail/1.9.10
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        "Fabrice Bellet" <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org> <202008272223.57461.linux@zary.sk> <87lfhz9mdi.fsf@codeaurora.org>
In-Reply-To: <87lfhz9mdi.fsf@codeaurora.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202008282334.15902.linux@zary.sk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 28 August 2020 10:59:37 Kalle Valo wrote:
> Ondrej Zary <linux@zary.sk> writes:
> 
> > On Thursday 27 August 2020 09:49:12 Kalle Valo wrote:
> >> Ondrej Zary <linux@zary.sk> writes:
> >> 
> >> > On Monday 17 August 2020 20:27:06 Jesse Brandeburg wrote:
> >> >> On Mon, 17 Aug 2020 16:27:01 +0300
> >> >> Kalle Valo <kvalo@codeaurora.org> wrote:
> >> >> 
> >> >> > I was surprised to see that someone was using this driver in 2015, so
> >> >> > I'm not sure anymore what to do. Of course we could still just remove
> >> >> > it and later revert if someone steps up and claims the driver is still
> >> >> > usable. Hmm. Does anyone any users of this driver?
> >> >> 
> >> >> What about moving the driver over into staging, which is generally the
> >> >> way I understood to move a driver slowly out of the kernel?
> >> >
> >> > Please don't remove random drivers.
> >> 
> >> We don't want to waste time on obsolete drivers and instead prefer to
> >> use our time on more productive tasks. For us wireless maintainers it's
> >> really hard to know if old drivers are still in use or if they are just
> >> broken.
> >> 
> >> > I still have the Aironet PCMCIA card and can test the driver.
> >> 
> >> Great. Do you know if the airo driver still works with recent kernels?
> >
> > Yes, it does.
> 
> Nice, I'm very surprised that so old and unmaintained driver still
> works. Thanks for testing.

Thanks to great work of all kernel maintainers most of the old drivers still work so Linux users aren't forced to throw away hardware just because it stopped working after a software update.

-- 
Ondrej Zary
