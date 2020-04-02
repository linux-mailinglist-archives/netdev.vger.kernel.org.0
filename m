Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0C19C316
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732522AbgDBNv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:51:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731579AbgDBNv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:51:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 854E9128A0360;
        Thu,  2 Apr 2020 06:51:27 -0700 (PDT)
Date:   Thu, 02 Apr 2020 06:51:26 -0700 (PDT)
Message-Id: <20200402.065126.1342599499039366040.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     irusskikh@marvell.com, mstarovoitov@marvell.com,
        dbogdanov@marvell.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: atlantic: fix missing | operator when
 assigning rec->llc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200401232736.410028-1-colin.king@canonical.com>
References: <20200401232736.410028-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Apr 2020 06:51:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  2 Apr 2020 00:27:36 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> rec->llc is currently being assigned twice, once with the lower 8 bits
> from packed_record[8] and then re-assigned afterwards with data from
> packed_record[9].  This looks like a type, I believe the second assignment
> should be using the |= operator rather than a direct assignment.
> 
> Addresses-Coverity: ("Unused value")
> Fixes: b8f8a0b7b5cb ("net: atlantic: MACSec ingress offload HW bindings")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
