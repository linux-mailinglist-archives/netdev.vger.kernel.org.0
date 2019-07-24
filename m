Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1235740FD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388393AbfGXVlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:41:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52244 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388258AbfGXVlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:41:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B3D81543A7D7;
        Wed, 24 Jul 2019 14:41:44 -0700 (PDT)
Date:   Wed, 24 Jul 2019 14:41:43 -0700 (PDT)
Message-Id: <20190724.144143.2055459359936675888.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     cai@lca.pw, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] net/ixgbevf: fix a compilation error of
 skb_frag_t
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4b5abf35a7b78ceae788ad7c2609d84dd33e5e9e.camel@intel.com>
References: <1563985079-12888-1-git-send-email-cai@lca.pw>
        <4b5abf35a7b78ceae788ad7c2609d84dd33e5e9e.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 14:41:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 24 Jul 2019 09:39:26 -0700

> Dave I will pick this up and add it to my queue.

How soon will you get that to me?  The sooner this build fix is cured the
better.

Thanks.
