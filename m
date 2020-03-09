Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013BD17D8BD
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 06:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgCIFJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 01:09:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIFJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 01:09:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4013B158B8EA5;
        Sun,  8 Mar 2020 22:09:01 -0700 (PDT)
Date:   Sun, 08 Mar 2020 22:09:00 -0700 (PDT)
Message-Id: <20200308.220900.2003952585762736013.davem@davemloft.net>
To:     elder@linaro.org
Cc:     arnd@arndb.de, bjorn.andersson@linaro.org, agross@kernel.org,
        johannes@sipsolutions.net, dcbw@redhat.com, evgreen@google.com,
        ejcaruso@google.com, syadagir@codeaurora.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        robh+dt@kernel.org, mark.rutland@arm.com, ohad@wizery.com,
        sidgup@codeaurora.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver (UPDATED)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306042831.17827-1-elder@linaro.org>
References: <20200306042831.17827-1-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 08 Mar 2020 22:09:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu,  5 Mar 2020 22:28:14 -0600

> This series presents the driver for the Qualcomm IP Accelerator (IPA).

Series applied, thank you.
