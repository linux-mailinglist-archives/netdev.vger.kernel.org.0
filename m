Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 593481541D9
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 11:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgBFK2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 05:28:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbgBFK2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 05:28:06 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7AD71489E4DF;
        Thu,  6 Feb 2020 02:28:05 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:28:04 +0100 (CET)
Message-Id: <20200206.112804.287425809381915422.davem@davemloft.net>
To:     shiva@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com,
        vinay.yadav@chelsio.com
Subject: Re: [net] cxgb4: Added tls stats prints.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200206083443.19461-1-shiva@chelsio.com>
References: <20200206083443.19461-1-shiva@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 02:28:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Devulapally Shiva Krishna <shiva@chelsio.com>
Date: Thu,  6 Feb 2020 14:04:43 +0530

> Added debugfs entry to show the tls stats.
> 
> Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied.
