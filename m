Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8C72478FD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHQVkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:40:51 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:57878 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQVkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:40:51 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Aug 2020 17:40:49 EDT
Received: from [192.168.0.2] (188-167-68-178.dynamic.chello.sk [188.167.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id C1C277A0198;
        Mon, 17 Aug 2020 23:35:06 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding style issues
Date:   Mon, 17 Aug 2020 23:35:02 +0200
User-Agent: KMail/1.9.10
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        "Fabrice Bellet" <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org> <87a6ytmmhm.fsf@codeaurora.org> <20200817112706.000000f2@intel.com>
In-Reply-To: <20200817112706.000000f2@intel.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202008172335.02988.linux@zary.sk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 17 August 2020 20:27:06 Jesse Brandeburg wrote:
> On Mon, 17 Aug 2020 16:27:01 +0300
> Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> > I was surprised to see that someone was using this driver in 2015, so
> > I'm not sure anymore what to do. Of course we could still just remove
> > it and later revert if someone steps up and claims the driver is still
> > usable. Hmm. Does anyone any users of this driver?
> 
> What about moving the driver over into staging, which is generally the
> way I understood to move a driver slowly out of the kernel?

Please don't remove random drivers. I still have the Aironet PCMCIA card and can test the driver.

-- 
Ondrej Zary
