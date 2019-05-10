Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04041A515
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 00:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfEJWLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 18:11:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfEJWLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 18:11:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 27C86133E9747;
        Fri, 10 May 2019 15:11:54 -0700 (PDT)
Date:   Fri, 10 May 2019 15:11:53 -0700 (PDT)
Message-Id: <20190510.151153.978484247986344582.davem@davemloft.net>
To:     tlfalcon@linux.ibm.com
Cc:     netdev@vger.kernel.org, julietk@linux.ibm.com
Subject: Re: [PATCH net] net/ibmvnic: Update MAC address settings after
 adapter reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557461624-21959-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1557461624-21959-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 15:11:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>
Date: Thu,  9 May 2019 23:13:43 -0500

> It was discovered in testing that the underlying hardware MAC
> address will revert to initial settings following a device reset,
> but the driver fails to resend the current OS MAC settings. This
> oversight can result in dropped packets should the scenario occur.
> Fix this by informing hardware of current MAC address settings 
> following any adapter initialization or resets.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Applied.
