Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA0313B7BE
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgAOCiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:38:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51656 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOCiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 21:38:08 -0500
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9836B15809987;
        Tue, 14 Jan 2020 18:37:56 -0800 (PST)
Date:   Tue, 14 Jan 2020 18:37:48 -0800 (PST)
Message-Id: <20200114.183748.275989716164464774.davem@davemloft.net>
To:     bjorn.andersson@linaro.org
Cc:     aneela@codeaurora.org, clew@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] QRTR flow control improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
References: <20200114075703.2145718-1-bjorn.andersson@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 18:38:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Mon, 13 Jan 2020 23:56:58 -0800

> In order to prevent overconsumption of resources on the remote side QRTR
> implements a flow control mechanism.
> 
> Move the handling of the incoming confirm_rx to the receiving process to
> ensure incoming flow is controlled. Then implement outgoing flow
> control, using the recommended algorithm of counting outstanding
> non-confirmed messages and blocking when hitting a limit. The last three
> patches refactors the node assignment and port lookup, in order to
> remove the worker in the receive path.

Series applied to net-next, thank you.
