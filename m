Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D6213CFBB
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgAOWGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:06:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgAOWGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:06:43 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7093815A0EE0A;
        Wed, 15 Jan 2020 14:06:41 -0800 (PST)
Date:   Wed, 15 Jan 2020 14:06:40 -0800 (PST)
Message-Id: <20200115.140640.367212385869999160.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     qiang.zhao@nxp.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/wan/fsl_ucc_hdlc: fix out of bounds write on array
 utdm_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114145448.361888-1-colin.king@canonical.com>
References: <20200114145448.361888-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Jan 2020 14:06:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue, 14 Jan 2020 14:54:48 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> Array utdm_info is declared as an array of MAX_HDLC_NUM (4) elements
> however up to UCC_MAX_NUM (8) elements are potentially being written
> to it.  Currently we have an array out-of-bounds write error on the
> last 4 elements. Fix this by making utdm_info UCC_MAX_NUM elements in
> size.
> 
> Addresses-Coverity: ("Out-of-bounds write")
> Fixes: c19b6d246a35 ("drivers/net: support hdlc function for QE-UCC")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied and queued up for -stable.
