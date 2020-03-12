Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0439B182954
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgCLGw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:52:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387831AbgCLGw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:52:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C54914DD5FBC;
        Wed, 11 Mar 2020 23:52:56 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:52:55 -0700 (PDT)
Message-Id: <20200311.235255.608477201434903797.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2020-03-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311170711.50376-1-jwi@linux.ibm.com>
References: <20200311170711.50376-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:52:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 11 Mar 2020 18:07:08 +0100

> please apply the following patch series for qeth to netdev's net tree.
> 
> Just one fix to get the RX buffer pool resizing right, with two
> preparatory cleanups.
> This is on the larger side given where we are in the -rc cycle, but a
> big chunk of the delta is just refactoring to make the fix look nice.
> 
> I intentionally split these off from yesterday's series. No objections
> if you'd rather punt them to net-next, the series should apply cleanly.

Series applied, thanks.
