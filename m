Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F27215DA66
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgBNPOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:14:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729475AbgBNPOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:14:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB0F515C42F09;
        Fri, 14 Feb 2020 07:14:00 -0800 (PST)
Date:   Fri, 14 Feb 2020 07:14:00 -0800 (PST)
Message-Id: <20200214.071400.1992303683626175409.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/2] net/smc: fixes for -net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214075900.31624-1-kgraul@linux.ibm.com>
References: <20200214075900.31624-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2020 07:14:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Fri, 14 Feb 2020 08:58:58 +0100

> Fix a syzbot finding and a problem with the CLC handshake content.

Series applied, thank you.
