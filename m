Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFC69C10A
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfHXXjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:39:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48628 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfHXXjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:39:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B9A91526007D;
        Sat, 24 Aug 2019 16:39:34 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:39:34 -0700 (PDT)
Message-Id: <20190824.163934.1752882295039249516.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/7] s390/qeth: updates 2019-08-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190823094853.63814-1-jwi@linux.ibm.com>
References: <20190823094853.63814-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:39:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Fri, 23 Aug 2019 11:48:46 +0200

> please apply one more round of qeth patches. These implement support for
> a bunch of TX-related features - namely TX NAPI, BQL and xmit_more.
> 
> Note that this includes two qdio patches which lay the necessary
> groundwork, and have been acked by Vasily.

Series applied, thanks.
