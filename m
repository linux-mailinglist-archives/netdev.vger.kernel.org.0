Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88011C212B
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgEAXVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 19:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726045AbgEAXVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 19:21:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C200C061A0C;
        Fri,  1 May 2020 16:21:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 796001504FE79;
        Fri,  1 May 2020 16:20:59 -0700 (PDT)
Date:   Fri, 01 May 2020 16:20:58 -0700 (PDT)
Message-Id: <20200501.162058.1644504393259832631.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 00/13] net/smc: extent buffer mapping and port
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501104813.76601-1-kgraul@linux.ibm.com>
References: <20200501104813.76601-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 16:20:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Fri,  1 May 2020 12:48:00 +0200

> Add functionality to map/unmap and register/unregister memory buffers for
> specific SMC-R links and for the whole link group. Prepare LLC layer messages
> for the support of multiple links and extent the processing of adapter events.
> And add further small preparations needed for the SMC-R failover support.

Series applied, thanks.
