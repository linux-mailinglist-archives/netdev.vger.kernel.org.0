Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72CE212EF1
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgGBVht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGBVhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 17:37:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51E1C08C5C1;
        Thu,  2 Jul 2020 14:37:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E685B12845373;
        Thu,  2 Jul 2020 14:37:47 -0700 (PDT)
Date:   Thu, 02 Jul 2020 14:37:47 -0700 (PDT)
Message-Id: <20200702.143747.827041018046186172.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, kuba@kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xen-netfront: remove redundant assignment to
 variable 'act'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702142223.48178-1-colin.king@canonical.com>
References: <20200702142223.48178-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jul 2020 14:37:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu,  2 Jul 2020 15:22:23 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable act is being initialized with a value that is
> never read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you.
