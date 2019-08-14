Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED028DFEE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 23:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfHNVbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 17:31:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60466 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730126AbfHNVbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 17:31:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0322154FFFC0;
        Wed, 14 Aug 2019 14:31:44 -0700 (PDT)
Date:   Wed, 14 Aug 2019 14:31:41 -0700 (PDT)
Message-Id: <20190814.143141.178107876214573923.davem@davemloft.net>
To:     santosh.shilimkar@oracle.com
Cc:     dledford@redhat.com, gerd.rausch@oracle.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <53a6feaf-b48e-aadf-1bd7-4c82ddc36d1e@oracle.com>
References: <a7d09f3a-d01e-7cdb-98ec-8165b6312ffe@oracle.com>
        <20190814.142112.1080694155114782651.davem@davemloft.net>
        <53a6feaf-b48e-aadf-1bd7-4c82ddc36d1e@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 14:31:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: santosh.shilimkar@oracle.com
Date: Wed, 14 Aug 2019 11:36:19 -0700

> On 8/14/19 11:21 AM, David Miller wrote:
>> From: santosh.shilimkar@oracle.com
>> Date: Wed, 14 Aug 2019 11:01:36 -0700
>> 
>>> Some of the application software was released before 2009 and ended up
>>> using these proc entries from downstream kernel. The newer lib/app
>>> using RDS don't use these. Unfortunately lot of customer still use
>>> Oracle 9, 10, 11 which were released before 2007 and run these apps
>>> on modern kernels.
>> So those apps are using proc entries that were never upstream...
>>
>> Sorry, this is completely and utterly inappropriate.
>> 
> Agree. Unfortunately one of the legacy application library didn't
> get upgraded even after the ports were registered with IANA.
> Oracle 11 is still very active release and hence this patch.
> 
> It is fine to drop $subject patch from this series.

The appropriate procedure is to resubmit the series with the patch
removed.

Thank you.
