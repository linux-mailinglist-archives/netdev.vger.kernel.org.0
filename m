Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C2A1C20F2
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgEAWx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgEAWx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:53:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EB6C061A0C;
        Fri,  1 May 2020 15:53:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C696715007850;
        Fri,  1 May 2020 15:53:56 -0700 (PDT)
Date:   Fri, 01 May 2020 15:53:55 -0700 (PDT)
Message-Id: <20200501.155355.1482969929360119370.davem@davemloft.net>
To:     elder@linaro.org
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: ipa: don't cache channel state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430221323.5449-1-elder@linaro.org>
References: <20200430221323.5449-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:53:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu, 30 Apr 2020 17:13:21 -0500

> This series removes a field that holds a copy of a channel's state
> at the time it was last fetched.  In principle the state can change
> at any time, so it's better to just fetch it whenever needed.  The
> first patch is just preparatory, simplifying the arguments to 
> gsi_channel_state().

Series applied, thanks Alex.
