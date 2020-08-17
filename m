Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2230924716F
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 20:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390970AbgHQS1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 14:27:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:21849 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390642AbgHQS1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 14:27:10 -0400
IronPort-SDR: HR4LeV7N2BZCj/1r30c9YwXFs8saOLgnKCcrstdw0MsNCEmSjamLyDQVFPMAxDPRsLTUhxukeC
 SQQCkqQlBPjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="154744676"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="154744676"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 11:27:09 -0700
IronPort-SDR: weHynqd/VG1QF6VPIaZSV5YF62aHFuJbljqBhoSY7cr8H+o7c3KFXfUy1ayq/zlJIOEzztHXBP
 nwQcAtnMiC4w==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="328711882"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.155.99])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 11:27:08 -0700
Date:   Mon, 17 Aug 2020 11:27:06 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Lee Jones <lee.jones@linaro.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        "Fabrice Bellet" <fabrice@bellet.info>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of
 coding style issues
Message-ID: <20200817112706.000000f2@intel.com>
In-Reply-To: <87a6ytmmhm.fsf@codeaurora.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
        <20200814113933.1903438-13-lee.jones@linaro.org>
        <87r1s9l0mc.fsf@codeaurora.org>
        <20200814163831.GN4354@dell>
        <87a6ytmmhm.fsf@codeaurora.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020 16:27:01 +0300
Kalle Valo <kvalo@codeaurora.org> wrote:

> I was surprised to see that someone was using this driver in 2015, so
> I'm not sure anymore what to do. Of course we could still just remove
> it and later revert if someone steps up and claims the driver is still
> usable. Hmm. Does anyone any users of this driver?

What about moving the driver over into staging, which is generally the
way I understood to move a driver slowly out of the kernel?

