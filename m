Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3033B8ED
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403951AbfFJQFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:05:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403868AbfFJQF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:05:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6CB3615050C66;
        Mon, 10 Jun 2019 09:05:27 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:05:26 -0700 (PDT)
Message-Id: <20190610.090526.1763320783297544794.davem@davemloft.net>
To:     jian.w.wen@oracle.com
Cc:     netdev@vger.kernel.org, john.r.fastabend@intel.com
Subject: Re: [PATCH net] net_sched: sch_mqprio: handle return value of
 mqprio_queue_get
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190610063821.27007-1-jian.w.wen@oracle.com>
References: <20190610063821.27007-1-jian.w.wen@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 09:05:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Wen <jian.w.wen@oracle.com>
Date: Mon, 10 Jun 2019 14:38:21 +0800

> It may return NULL thus we can't ignore it.

Please repost with a proper signoff.
