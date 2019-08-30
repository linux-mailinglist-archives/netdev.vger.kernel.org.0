Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61250A3E72
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 21:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfH3Tcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 15:32:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728180AbfH3Tcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 15:32:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79143154F93C5;
        Fri, 30 Aug 2019 12:32:34 -0700 (PDT)
Date:   Fri, 30 Aug 2019 12:32:31 -0700 (PDT)
Message-Id: <20190830.123231.792067088434189707.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] wimax/i2400m: remove debug containing bogus
 calculation of index
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830090711.15300-1-colin.king@canonical.com>
References: <20190830090711.15300-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 12:32:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 30 Aug 2019 10:07:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The subtraction of the two pointers is automatically scaled by the
> size of the size of the object the pointers point to, so the division
> by sizeof(*i2400m->barker) is incorrect.  This has been broken since
> day one of the driver and is only debug, so remove the debug completely.
> 
> Also move && in condition to clean up a checkpatch warning.
> 
> Addresses-Coverity: ("Extra sizeof expression")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> 
> V2: completely remove debug, clean up checkpatch warning, change subject line

Applied to net-next, thanks Colin.
