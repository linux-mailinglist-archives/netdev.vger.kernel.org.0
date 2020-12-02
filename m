Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B732E2CB2C0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 03:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgLBCRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 21:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:52922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgLBCRh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 21:17:37 -0500
Date:   Tue, 1 Dec 2020 18:16:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606875417;
        bh=xLP+4T3ykiobk+5EmqGvnkWSmjape4r4udwMBo+s5d4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=zFVbCzUShSG+KImLTLDBCZyoeULRjpdTHY92dTGytPQwl+ZBj2KLnpuxDU5MHAExh
         7t1k12j4VKnh9jJfADzk55hT67h/gTj0hMv74/iYS5FxG09DXcHZnjWIu4osoWlIjK
         p7PfxYmghQK2wlW6tHCdSYiCVfiusNgGaaRUMsNU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net: ipa: IPA v4.5 aggregation and Qtime
Message-ID: <20201201181655.6ddbc44a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130233712.29113-1-elder@linaro.org>
References: <20201130233712.29113-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 17:37:08 -0600 Alex Elder wrote:
> This series updates some IPA register definitions that change in
> substantive ways for IPA v4.5.
> 
> One register defines parameters used by an endpoint to aggregate
> multiple packets into a buffer.  The size and position of most
> fields in that register have changed with this new hardware version,
> and consequently the function that programs it needs to be done a
> bit differently.  The first patch takes care of this.
> 
> Second, IPA v4.5 introduces a unified time keeping component to be
> used in several places by the IPA hardware.  A main clock divider
> provides a fundamental tick rate, and several timestamped features 
> now define their granularity based on that.  There is also a set of
> "pulse generators" derived from the main tick, and these are used
> to implement timers used for aggregation and head-of-line block
> avoidance.  The second patch adds IPA register updates to support
> Qtime along with its configuration, and the last two patches
> configure the timers that use it.

Applied, thanks!
