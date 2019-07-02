Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1AA5D68C
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGBTCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:02:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBTCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:02:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1D50C136DDD34;
        Tue,  2 Jul 2019 12:02:35 -0700 (PDT)
Date:   Tue, 02 Jul 2019 12:02:34 -0700 (PDT)
Message-Id: <20190702.120234.492147786406295758.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     tglx@linutronix.de, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: st-nci: remove redundant assignment to variable r
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702131642.9865-1-colin.king@canonical.com>
References: <20190702131642.9865-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jul 2019 12:02:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Tue,  2 Jul 2019 14:16:42 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable r is being initialized with a value that is never
> read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next.
