Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D55225B695
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 00:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIBWrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 18:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgIBWra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 18:47:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCEFC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 15:47:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 403B0157347B8;
        Wed,  2 Sep 2020 15:30:43 -0700 (PDT)
Date:   Wed, 02 Sep 2020 15:47:29 -0700 (PDT)
Message-Id: <20200902.154729.1098548527536487315.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/6] ionic: struct cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200901182024.64101-1-snelson@pensando.io>
References: <20200901182024.64101-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:30:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Tue,  1 Sep 2020 11:20:18 -0700

> This patchset has a few changes for better cacheline use,
> to cleanup a page handling API, and to streamline the
> Adminq/Notifyq queue handling.  Lastly, we also have a couple
> of fixes pointed out by the friendly kernel test robot.
> 
> v2: dropped change to irq coalesce default
>     fixed Neel's attributions to Co-developed-by
>     dropped the unnecessary new call to dma_sync_single_for_cpu()
>     added 2 patches from kernel test robot results

Series applied, thank you.
