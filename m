Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A782D8DCDE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbfHNSVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:21:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbfHNSVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:21:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3CDC1154F3259;
        Wed, 14 Aug 2019 11:21:15 -0700 (PDT)
Date:   Wed, 14 Aug 2019 14:21:12 -0400 (EDT)
Message-Id: <20190814.142112.1080694155114782651.davem@davemloft.net>
To:     santosh.shilimkar@oracle.com
Cc:     dledford@redhat.com, gerd.rausch@oracle.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a7d09f3a-d01e-7cdb-98ec-8165b6312ffe@oracle.com>
References: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
        <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
        <a7d09f3a-d01e-7cdb-98ec-8165b6312ffe@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 11:21:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: santosh.shilimkar@oracle.com
Date: Wed, 14 Aug 2019 11:01:36 -0700

> Some of the application software was released before 2009 and ended up
> using these proc entries from downstream kernel. The newer lib/app
> using RDS don't use these. Unfortunately lot of customer still use
> Oracle 9, 10, 11 which were released before 2007 and run these apps
> on modern kernels.

So those apps are using proc entries that were never upstream...

Sorry, this is completely and utterly inappropriate.
