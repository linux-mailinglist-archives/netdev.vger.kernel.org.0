Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16B0180C07
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCJXIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:08:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJXIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:08:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0D4E14CD0E72;
        Tue, 10 Mar 2020 16:08:42 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:08:42 -0700 (PDT)
Message-Id: <20200310.160842.1259774022339854727.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2020-03-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310173803.91602-1-jwi@linux.ibm.com>
References: <20200310173803.91602-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:08:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Tue, 10 Mar 2020 18:38:00 +0100

> please apply the following patch series for qeth to netdev's net tree.
> 
> This fixes three minor issues:
> 1) a setup parameter gets cleared unnecessarily when the HW config
>    changes,
> 2) insufficient error handling when initially filling the RX ring, and
> 3) a rarely used worker that needs to be cancelled during tear down.

Series applied and queued up for -stable, thank you.
