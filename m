Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEF0C8E2A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfJBQVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:21:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33780 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJBQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:21:23 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 21FB81540A47B;
        Wed,  2 Oct 2019 09:21:22 -0700 (PDT)
Date:   Wed, 02 Oct 2019 12:21:18 -0400 (EDT)
Message-Id: <20191002.122118.97058861403796789.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] ptp_qoriq: Initialize the registers' spinlock
 before calling ptp_qoriq_settime
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001190701.5754-1-olteanv@gmail.com>
References: <20191001190701.5754-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 09:21:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  1 Oct 2019 22:07:01 +0300

> Because ptp_qoriq_settime is being called prior to spin_lock_init, the
> following stack trace can be seen at driver probe time:
 ...
> Fixes: ff54571a747b ("ptp_qoriq: convert to use ptp_qoriq_init/free")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable.
