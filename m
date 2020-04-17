Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1B1AE40F
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 19:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgDQRt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 13:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730008AbgDQRt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 13:49:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B34C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 10:49:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CAF61281077C;
        Fri, 17 Apr 2020 10:49:25 -0700 (PDT)
Date:   Fri, 17 Apr 2020 10:49:24 -0700 (PDT)
Message-Id: <20200417.104924.675136533926590542.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2020-04-17
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417084313.GA48142@oeltahan-mobl.ger.corp.intel.com>
References: <20200417084313.GA48142@oeltahan-mobl.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Apr 2020 10:49:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Fri, 17 Apr 2020 11:43:13 +0300

> Here's the first bluetooth-next pull request for the 5.8 kernel:
> 
>  - Added debugfs option to control MITM flag usage during pairing
>  - Added new BT_MODE socket option
>  - Added support for Qualcom QCA6390 device
>  - Added support for Realtek RTL8761B device
>  - Added support for mSBC audio codec over USB endpoints
>  - Added framework for Microsoft HCI vendor extensions
>  - Added new Read Security Information management command
>  - Fixes/cleanup to link layer privacy related code
>  - Various other smaller cleanups & fixes
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thank you.
