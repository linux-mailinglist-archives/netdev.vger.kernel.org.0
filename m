Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D00D1C303E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 01:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgECXIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 19:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbgECXIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 19:08:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B14CC061A0E;
        Sun,  3 May 2020 16:08:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 900AB1211C987;
        Sun,  3 May 2020 16:08:45 -0700 (PDT)
Date:   Sun, 03 May 2020 16:08:44 -0700 (PDT)
Message-Id: <20200503.160844.1392977826698935408.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next v2 00/11] net/smc: add and delete link
 processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200503123850.57261-1-kgraul@linux.ibm.com>
References: <20200503123850.57261-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 May 2020 16:08:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Sun,  3 May 2020 14:38:39 +0200

> These patches add the 'add link' and 'delete link' processing as 
> SMC server and client. This processing allows to establish and
> remove links of a link group dynamically.
> 
> v2: Fix mess up with unused static functions. Merge patch 8 into patch 4.
>     Postpone patch 13 to next series.

Series applied, thanks.
