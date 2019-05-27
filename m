Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA982ADEA
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 07:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfE0FMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 01:12:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfE0FMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 01:12:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D051148F8198;
        Sun, 26 May 2019 22:12:19 -0700 (PDT)
Date:   Sun, 26 May 2019 22:12:18 -0700 (PDT)
Message-Id: <20190526.221218.594997463672055463.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] ipv4: remove redundant assignment to n
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524215658.25432-1-colin.king@canonical.com>
References: <20190524215658.25432-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 May 2019 22:12:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri, 24 May 2019 22:56:58 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer n is being assigned a value however this value is
> never read in the code block and the end of the code block
> continues to the next loop iteration. Clean up the code by
> removing the redundant assignment.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thanks Colin.
