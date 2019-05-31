Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B51EE316AB
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfEaVhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:37:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaVhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:37:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E711415010A34;
        Fri, 31 May 2019 14:37:11 -0700 (PDT)
Date:   Fri, 31 May 2019 14:37:11 -0700 (PDT)
Message-Id: <20190531.143711.1406359688787927167.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     wei.liu2@citrix.com, paul.durrant@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-netback: remove redundant assignment to err
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530190438.9571-1-colin.king@canonical.com>
References: <20190530190438.9571-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 May 2019 14:37:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 30 May 2019 20:04:38 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is assigned with the value -ENOMEM that is never
> read and it is re-assigned a new value later on.  The assignment is
> redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
