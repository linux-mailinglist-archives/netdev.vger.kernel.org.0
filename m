Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF2121F21
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 00:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfLPX45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 18:56:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57320 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLPX45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 18:56:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B107C153935BA;
        Mon, 16 Dec 2019 15:56:56 -0800 (PST)
Date:   Mon, 16 Dec 2019 15:56:53 -0800 (PST)
Message-Id: <20191216.155653.1808476779145011704.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com
Subject: Re: [PATCH 0/3] dpaa2-ptp: support external trigger event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212100806.17447-1-yangbo.lu@nxp.com>
References: <20191212100806.17447-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 15:56:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Thu, 12 Dec 2019 18:08:03 +0800

> This patch-set is to add external trigger event support for
> dpaa2-ptp driver since MC firmware has supported external
> trigger interrupt with a new v2 dprtc_set_irq_mask() API.
> And extts_clean_up() function in ptp_qoriq driver needs to be
> exported with minor fixes for dpaa2-ptp reusing.

Series applied to net-next.
