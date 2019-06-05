Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6CC3638B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFEStQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:49:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38044 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFEStQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:49:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C369C1510C909;
        Wed,  5 Jun 2019 11:49:15 -0700 (PDT)
Date:   Wed, 05 Jun 2019 11:49:15 -0700 (PDT)
Message-Id: <20190605.114915.1446902922093174106.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH v3 net 0/4] s390/qeth: fixes 2019-06-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605114851.56641-1-jwi@linux.ibm.com>
References: <20190605114851.56641-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 11:49:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed,  5 Jun 2019 13:48:47 +0200

> one more shot...  now with patch 2 fixed up so that it uses the
> dst entry returned from dst_check().

Looks good, series applied, thanks.
