Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D73A1C28EF
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 01:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgEBXcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 19:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726375AbgEBXcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 19:32:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA571C061A0C;
        Sat,  2 May 2020 16:32:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DD051513DD3F;
        Sat,  2 May 2020 16:32:02 -0700 (PDT)
Date:   Sat, 02 May 2020 16:31:59 -0700 (PDT)
Message-Id: <20200502.163159.1994318394817516336.davem@davemloft.net>
To:     vincent.cheng.xh@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/3] ptp: Add adjust phase to support phase
 offset.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 02 May 2020 16:32:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <vincent.cheng.xh@renesas.com>
Date: Fri, 1 May 2020 23:35:35 -0400

> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> This series adds adjust phase to the PTP Hardware Clock device interface.
> 
> Some PTP hardware clocks have a write phase mode that has
> a built-in hardware filtering capability.  The write phase mode
> utilizes a phase offset control word instead of a frequency offset 
> control word.  Add adjust phase function to take advantage of this
> capability.
> 
> Changes since v1:
> - As suggested by Richard Cochran:
>   1. ops->adjphase is new so need to check for non-null function pointer.
>   2. Kernel coding style uses lower_case_underscores.
>   3. Use existing PTP clock API for delayed worker.

Series applied.
