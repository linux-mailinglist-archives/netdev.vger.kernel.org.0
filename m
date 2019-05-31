Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68CAA316C7
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfEaVuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:50:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaVuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:50:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BEDE15015E90;
        Fri, 31 May 2019 14:50:06 -0700 (PDT)
Date:   Fri, 31 May 2019 14:50:05 -0700 (PDT)
Message-Id: <20190531.145005.798440469894507477.davem@davemloft.net>
To:     elder@linaro.org
Cc:     arnd@arndb.de, bjorn.andersson@linaro.org,
        ilias.apalodimas@linaro.org, evgreen@chromium.org,
        benchan@google.com, ejcaruso@google.com, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, subashab@codeaurora.org,
        abhishek.esse@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 03/17] soc: qcom: ipa: main code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190531035348.7194-4-elder@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
        <20190531035348.7194-4-elder@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:50:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Thu, 30 May 2019 22:53:34 -0500

> +	void *route_virt;
 ...
> +	void *filter_virt;
 ...

If these are arrays of u64's, please declare them as "u64 *" instead of
the opaque "void *".
