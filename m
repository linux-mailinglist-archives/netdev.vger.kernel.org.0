Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1DF104512
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfKTUaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:30:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59570 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKTUaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:30:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DECA14C1F40B;
        Wed, 20 Nov 2019 12:30:04 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:30:03 -0800 (PST)
Message-Id: <20191120.123003.1420968007513594046.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/2] s390/qeth: fixes 2019-11-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120132057.1788-1-jwi@linux.ibm.com>
References: <20191120132057.1788-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:30:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 20 Nov 2019 14:20:55 +0100

> please apply two late qeth fixes to your net tree.
> 
> The first fixes a deadlock that can occur if a qeth device is set
> offline while in the middle of processing deferred HW events.
> The second patch converts the return value of an error path to
> use -EIO, so that it can be passed back to userspace.

Series applied, thanks.
