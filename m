Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418224A68F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHSTI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHSTI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:08:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADADC061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:08:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8AE19129691B6;
        Wed, 19 Aug 2020 11:51:39 -0700 (PDT)
Date:   Wed, 19 Aug 2020 12:08:25 -0700 (PDT)
Message-Id: <20200819.120825.1842724640885158282.davem@davemloft.net>
To:     ljp@linux.ibm.com
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next 1/5] ibmvnic: print caller in several error
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200819053512.3619-2-ljp@linux.ibm.com>
References: <20200819053512.3619-1-ljp@linux.ibm.com>
        <20200819053512.3619-2-ljp@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 11:51:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>
Date: Wed, 19 Aug 2020 00:35:08 -0500

> The error messages in the changed functions are exactly the same.
> In order to differentiate them and make debugging easier,
> we print the function names in the error messages.
> 
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

I don't see any value in emitting function names in kernel
error log messages.

Sorry.
