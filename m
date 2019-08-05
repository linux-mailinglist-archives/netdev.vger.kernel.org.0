Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8528823FB
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbfHER2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:28:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59560 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729496AbfHER2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:28:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5F24515407F16;
        Mon,  5 Aug 2019 10:28:12 -0700 (PDT)
Date:   Mon, 05 Aug 2019 10:28:11 -0700 (PDT)
Message-Id: <20190805.102811.142667979127203692.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]][next] selftests: nettest: fix spelling mistake:
 "potocol" -> "protocol"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805105211.27229-1-colin.king@canonical.com>
References: <20190805105211.27229-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 10:28:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon,  5 Aug 2019 11:52:11 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an error messgae. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
