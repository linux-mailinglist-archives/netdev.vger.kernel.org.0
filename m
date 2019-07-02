Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8985C762
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGBCgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:36:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGBCgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:36:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 166EA14DEC61A;
        Mon,  1 Jul 2019 19:36:54 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:36:53 -0700 (PDT)
Message-Id: <20190701.193653.440393422470294107.davem@davemloft.net>
To:     csully@google.com
Cc:     netdev@vger.kernel.org, lkp@intel.com, julia.lawall@lip6.fr
Subject: Re: [PATCH net-next v4 0/4] Add gve driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190701225755.209250-1-csully@google.com>
References: <20190701225755.209250-1-csully@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:36:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>
Date: Mon,  1 Jul 2019 15:57:51 -0700

> This patch series adds the gve driver which will support the
> Compute Engine Virtual NIC that will be available in the future.
 ...

Series applied to net-next, thanks.
