Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE24149B12
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 15:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgAZO2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 09:28:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbgAZO2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 09:28:03 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6FBA15BF3419;
        Sun, 26 Jan 2020 06:28:01 -0800 (PST)
Date:   Sun, 26 Jan 2020 15:27:57 +0100 (CET)
Message-Id: <20200126.152757.1376333579798530411.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/5] s390/qeth: updates 2020-01-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125155303.40971-1-jwi@linux.ibm.com>
References: <20200125155303.40971-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 06:28:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Sat, 25 Jan 2020 16:52:58 +0100

> please apply the following patch series for qeth to your net-next tree.
> 
> This brings a number of cleanups for the init/teardown code paths.

Series applied, thank you.
