Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D7822F97A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgG0Ttn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgG0Ttn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:49:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9499DC061794;
        Mon, 27 Jul 2020 12:49:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 762A71277773A;
        Mon, 27 Jul 2020 12:32:57 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:49:42 -0700 (PDT)
Message-Id: <20200727.124942.1829978531845134184.davem@davemloft.net>
To:     wenhu.wang@vivo.com
Cc:     elder@kernel.org, kuba@kernel.org, kvalo@codeaurora.org,
        agross@kernel.org, bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        ath11k@lists.infradead.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        srinivas.kandagatla@linaro.org, sibis@codeaurora.org
Subject: Re: [PATCH] soc: qmi: allow user to set handle wq to hiprio
From:   David Miller <davem@davemloft.net>
In-Reply-To: <AMoAtwB9DXJsyd-1khUpzqq9.1.1595862196133.Hmail.wenhu.wang@vivo.com>
References: <AMoAtwB9DXJsyd-1khUpzqq9.1.1595862196133.Hmail.wenhu.wang@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:32:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 王文虎 <wenhu.wang@vivo.com>
Date: Mon, 27 Jul 2020 23:03:16 +0800 (GMT+08:00)

> Currently the qmi_handle is initialized single threaded and strictly
> ordered with the active set to 1. This is pretty simple and safe but
> sometimes ineffency. So it is better to allow user to decide whether
> a high priority workqueue should be used.
> 
> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>

Every caller sets the new value to "0", so you should submit this when
you have a cast that actually sets it to "1".

Also, the new argument should be "bool" instead of "unsigned int" and
use "true" and "false" in the callers.

Thank you.
