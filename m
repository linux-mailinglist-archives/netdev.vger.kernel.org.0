Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFED1785DD
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgCCWqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:46:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgCCWqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 17:46:46 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8566715A0AA72;
        Tue,  3 Mar 2020 14:46:45 -0800 (PST)
Date:   Tue, 03 Mar 2020 14:46:42 -0800 (PST)
Message-Id: <20200303.144642.2262725800150863799.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH net 0/3] Fix IPv6 peer route update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200303063736.4904-1-liuhangbin@gmail.com>
References: <20200303063736.4904-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 14:46:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue,  3 Mar 2020 14:37:33 +0800

> Currently we have two issues for peer route update on IPv6.
> 1. When update peer route metric, we only updated the local one.
> 2. If peer address changed, we didn't remove the old one and add new one.
> 
> The first two patches fixed these issues and the third patch add new
> tests to cover it.
> 
> With the fixes and updated test:
> ]# ./fib_tests.sh
 ...

Series applied and queued up for -stable, thanks.
