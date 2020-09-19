Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47DF270984
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgISAti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISAti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:49:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F821C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 17:49:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90A6715B4166B;
        Fri, 18 Sep 2020 17:32:50 -0700 (PDT)
Date:   Fri, 18 Sep 2020 17:49:36 -0700 (PDT)
Message-Id: <20200918.174936.302102308649495615.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com, olteanv@gmail.com
Subject: Re: [v2, 0/2] ptp_qoriq: support FIPER3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918094801.37514-1-yangbo.lu@nxp.com>
References: <20200918094801.37514-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 17:32:50 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Fri, 18 Sep 2020 17:47:59 +0800

> The FIPER3 (fixed interval period pulse generator) is supported on
> DPAA2 and ENETC network controller hardware. This patch-set is to
> support it in ptp_qoriq driver and dt-binding.
> 
> Changes for v2:
> - Some improvement in code.
> - Added ACK from Vladimir.

Series applied, thanks.
