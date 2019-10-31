Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F666EB766
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbfJaSms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:42:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59008 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbfJaSms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:42:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1338914FC6CF7;
        Thu, 31 Oct 2019 11:42:48 -0700 (PDT)
Date:   Thu, 31 Oct 2019 11:42:45 -0700 (PDT)
Message-Id: <20191031.114245.2134716408449327353.davem@davemloft.net>
To:     cmclachlan@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        brouer@redhat.com
Subject: Re: [PATCH net-next v4 0/6] sfc: Add XDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 11:42:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Charles McLachlan <cmclachlan@solarflare.com>
Date: Thu, 31 Oct 2019 10:21:14 +0000

> Supply the XDP callbacks in netdevice ops that enable lower level processing
> of XDP frames.

If Jesper et al. could do a quick review of this to make sure all of the feedback
from previous versions was addressed properly, I'd really appreciate it.

Thanks.
