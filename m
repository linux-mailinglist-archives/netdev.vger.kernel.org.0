Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EDD234EAF
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 01:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGaXo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 19:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgGaXo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 19:44:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6872C06174A;
        Fri, 31 Jul 2020 16:44:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99BF011E58FA1;
        Fri, 31 Jul 2020 16:28:11 -0700 (PDT)
Date:   Fri, 31 Jul 2020 16:44:56 -0700 (PDT)
Message-Id: <20200731.164456.1479099850550140032.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net-next 0/4] s390/qeth: updates 2020-07-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730150121.18005-1-jwi@linux.ibm.com>
References: <20200730150121.18005-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 16:28:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 30 Jul 2020 17:01:17 +0200

> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This primarily brings some modernization to the RX path, laying the
> groundwork for smarter RX refill policies.
> Some of the patches are tagged as fixes, but really target only rare /
> theoretical issues. So given where we are in the release cycle and that we
> touch the main RX path, taking them through net-next seems more appropriate.

Series applied to net-next, thanks.
