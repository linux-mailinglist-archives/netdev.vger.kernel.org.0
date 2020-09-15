Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E10726AEA7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgIOUZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbgIOUXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:23:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D947C06178B;
        Tue, 15 Sep 2020 13:22:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8810E136821B9;
        Tue, 15 Sep 2020 13:05:19 -0700 (PDT)
Date:   Tue, 15 Sep 2020 13:22:05 -0700 (PDT)
Message-Id: <20200915.132205.83625953736297072.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com, wintera@linux.ibm.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        ivecera@redhat.com
Subject: Re: [PATCH net-next 0/8] s390/qeth: updates 2020-09-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910172351.5622-1-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 13:05:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu, 10 Sep 2020 19:23:43 +0200

> subject to positive review by the bridge maintainers on patch 5,
> please apply the following patch series to netdev's net-next tree.
> 
> Alexandra adds BR_LEARNING_SYNC support to qeth. In addition to the
> main qeth changes (controlling the feature, and raising switchdev
> events), this also needs
> - Patch 1 and 2 for some s390/cio infrastructure improvements
>   (acked by Heiko to go in via net-next), and
> - Patch 5 to introduce a new switchdev_notifier_type, so that a driver
>   can clear all previously learned entries from the bridge FDB in case
>   things go out-of-sync later on.

Series applied, thank you.
