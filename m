Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5710119FB47
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgDFRU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:20:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbgDFRU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:20:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B7BAD15DA6701;
        Mon,  6 Apr 2020 10:20:28 -0700 (PDT)
Date:   Mon, 06 Apr 2020 10:20:27 -0700 (PDT)
Message-Id: <20200406.102027.658947559034471738.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: remove some redundant assignments to variable
 result
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200405120603.369405-1-colin.king@canonical.com>
References: <20200405120603.369405-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 10:20:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Sun,  5 Apr 2020 13:06:02 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> In function i2400m_bm_buf_alloc there is no need to use a variable
> 'result' to return -ENOMEM, just return the literal value. In the
> function i2400m_setup the variable 'result' is initialized with a
> value that is never read, it is a redundant assignment that can
> be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks.
