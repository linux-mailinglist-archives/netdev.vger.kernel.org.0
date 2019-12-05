Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7634711480A
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfLEUZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:25:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47102 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfLEUZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:25:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BFC11503D3DC;
        Thu,  5 Dec 2019 12:25:23 -0800 (PST)
Date:   Thu, 05 Dec 2019 12:25:22 -0800 (PST)
Message-Id: <20191205.122522.618665603577837878.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2019-12-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205133304.58895-1-jwi@linux.ibm.com>
References: <20191205133304.58895-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 12:25:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Thu,  5 Dec 2019 14:33:01 +0100

> please apply the following fixes to your net tree.
> 
> The first two patches target the RX data path, the third fixes a memory
> leak when shutting down a qeth device.

Series applied, thanks Julian.
