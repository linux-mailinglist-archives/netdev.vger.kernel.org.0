Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B388F3AD5F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfFJC45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:56:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfFJC45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:56:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5C1C14EAF62A;
        Sun,  9 Jun 2019 19:56:56 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:56:56 -0700 (PDT)
Message-Id: <20190609.195656.1117192578245223571.davem@davemloft.net>
To:     hariprasad.kelam@gmail.com
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_key: make use of BUG_ON macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190608090050.GA8339@hari-Inspiron-1545>
References: <20190608090050.GA8339@hari-Inspiron-1545>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:56:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date: Sat, 8 Jun 2019 14:30:50 +0530

> fix below warnings reported by coccicheck
> 
> net/key/af_key.c:932:2-5: WARNING: Use BUG_ON instead of if condition
> followed by BUG.
> net/key/af_key.c:948:2-5: WARNING: Use BUG_ON instead of if condition
> followed by BUG.
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>

Applied to net-next.
