Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2ECC4D3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbfJDVa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:30:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJDVa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:30:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ABAC314F0FAAC;
        Fri,  4 Oct 2019 14:30:58 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:30:58 -0700 (PDT)
Message-Id: <20191004.143058.258657015686358341.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: make sock_prot_memory_pressure() return "const
 char *"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003214440.GA19784@avx2>
References: <20191003214440.GA19784@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:30:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 4 Oct 2019 00:44:40 +0300

> This function returns string literals which are "const char *".
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied.
