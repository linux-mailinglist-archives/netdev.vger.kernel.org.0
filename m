Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433243FA28E
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhH1Aoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhH1Ao3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:44:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F59060ED5;
        Sat, 28 Aug 2021 00:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630111420;
        bh=BDY2+Yx3tWW4yHY4p0X7NCyWDftZPOrupXysv7YhqN0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S4qs1tAo5tkN2nOk14PC+H2DV0xcqluNSs5qslqKAF0/OyV9Co2aQrwUd/Um8KcvU
         OsQfpKmN31kRZ3DjOUY84hwvIAxZhJLXD10oe1Y+01JDm4H+t23WGujA0isT9IHKsT
         9QS/aqRcY7q5ULbLDIE9fcA1hIa8z7l7YUyiu22sT0aKZBqKPxSw0AyrleJiqJfK86
         1TI4MDTzRsDetrgjuzNSnFEAi/Auti+GQ+pfpYK/iB3PS7dO+FQqXb9GzbhjtJ96+J
         AfwDWSVV8S/VZ5cFFRTOUcN2G63f78PmcL4M+ZguFodF8hf+/Qz09UbN2fuxvUn+6u
         zI46MhXtjpIrw==
Date:   Fri, 27 Aug 2021 17:43:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        maciej.machnikowski@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/5] ice: remove dead code for allocating pin_config
Message-ID: <20210827174339.5db00f54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210827204358.792803-3-anthony.l.nguyen@intel.com>
References: <20210827204358.792803-1-anthony.l.nguyen@intel.com>
        <20210827204358.792803-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 13:43:55 -0700 Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> We have code in the ice driver which allocates the pin_config structure
> if n_pins is > 0, but we never set n_pins to be greater than zero.
> There's no reason to keep this code until we actually have pin_config
> support. Remove this. We can re-add it properly when we implement
> support for pin_config for E810-T devices.
> 
> Fixes: 172db5f91d5f ("ice: add support for auxiliary input/output pins")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Removing dead code is not really a fix. Let's see if Linus cuts 5.14
this weekend, in which case it won't matter.
