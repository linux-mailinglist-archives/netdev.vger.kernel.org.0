Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DF518A93F
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 00:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgCRXeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 19:34:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRXeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 19:34:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 930EB15528E2B;
        Wed, 18 Mar 2020 16:34:00 -0700 (PDT)
Date:   Wed, 18 Mar 2020 16:34:00 -0700 (PDT)
Message-Id: <20200318.163400.1408546620540008446.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 00/11] s390/qeth: updates 2020-03-18
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200318125455.5838-1-jwi@linux.ibm.com>
References: <20200318125455.5838-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 16:34:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 18 Mar 2020 13:54:44 +0100

> please apply the following patch series for qeth to netdev's net-next
> tree.
> 
> This consists of three parts:
> 1) support for __GFP_MEMALLOC,
> 2) several ethtool enhancements (.set_channels, SW Timestamping),
> 3) the usual cleanups.

Series applied, thanks.
