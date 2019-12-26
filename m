Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609D612AFAD
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfLZXYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:24:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:24:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6AE471539D836;
        Thu, 26 Dec 2019 15:24:15 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:24:14 -0800 (PST)
Message-Id: <20191226.152414.315032656379968442.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/3] s390/qeth: updates 2019-12-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223142227.19500-1-jwi@linux.ibm.com>
References: <20191223142227.19500-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:24:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Mon, 23 Dec 2019 15:22:24 +0100

> please apply the following patch series for qeth to your net-next tree.
> 
> This reworks the RX code to use napi_gro_frags() when building non-linear
> skbs, along with some consolidation and cleanups.

Series applied to net-next.

> Happy holidays - and many thanks for all the effort & support over the past
> year, to both Jakub and you. It's much appreciated.

No problem :)
