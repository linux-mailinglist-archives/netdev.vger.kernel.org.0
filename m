Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D904D3AD39
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbfFJCvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:51:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730397AbfFJCvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:51:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8A6714EADFAE;
        Sun,  9 Jun 2019 19:51:42 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:51:42 -0700 (PDT)
Message-Id: <20190609.195142.1682704505275200436.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 0/3] ibmvnic: Fixes for device reset handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559941435-30124-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1559941435-30124-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:51:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Fri,  7 Jun 2019 16:03:52 -0500

> This series contains three unrelated fixes to issues seen during
> device resets. The first patch fixes an error when the driver requests
> to deactivate the link of an uninitialized device, resulting in a 
> failure to reset. Next, a patch to fix multicast transmission 
> failures seen after a driver reset. The final patch fixes mishandling
> of memory allocation failures during device initialization, which
> caused a kernel oops.

Series applied, thanks.
