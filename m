Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B4A1D1EC9
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390454AbgEMTPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390350AbgEMTPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:15:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E373C061A0E;
        Wed, 13 May 2020 12:15:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D84A3127DFE0A;
        Wed, 13 May 2020 12:15:10 -0700 (PDT)
Date:   Wed, 13 May 2020 12:15:10 -0700 (PDT)
Message-Id: <20200513.121510.1691039001070810205.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, kgraul@linux.ibm.com,
        weiyongjun1@huawei.com
Subject: Re: [PATCH net 0/2] s390/net: updates 2020-05-13
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513074230.967-1-ubraun@linux.ibm.com>
References: <20200513074230.967-1-ubraun@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:15:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Wed, 13 May 2020 09:42:28 +0200

> please apply the fix from Wei Yongjun to netdev's net tree and
> add Karsten Graul as co-maintainer for drivers/s390/net.

Series applied, thanks.
