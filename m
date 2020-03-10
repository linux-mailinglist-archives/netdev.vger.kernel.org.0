Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C792617EDE5
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCJBQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:16:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34474 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgCJBQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:16:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3DBE15A05C09;
        Mon,  9 Mar 2020 18:16:34 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:16:34 -0700 (PDT)
Message-Id: <20200309.181634.1145606871494987543.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/2] s390/qeth: updates 2020-03-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306081311.50635-1-jwi@linux.ibm.com>
References: <20200306081311.50635-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:16:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Fri,  6 Mar 2020 09:13:09 +0100

> please apply the following patch series for qeth to netdev's net-next
> tree.
> 
> Just a small update to take care of a regression wrt to IRQ handling in
> net-next, reported by Qian Cai. The fix needs some qdio layer changes,
> so you will find Vasily's Acked-by in that patch.

Series applied, thank you.
