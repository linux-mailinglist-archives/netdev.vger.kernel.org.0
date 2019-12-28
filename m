Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE612BEC6
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 20:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfL1T5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 14:57:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfL1T5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 14:57:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DF4815461F0B;
        Sat, 28 Dec 2019 11:57:39 -0800 (PST)
Date:   Sat, 28 Dec 2019 11:57:38 -0800 (PST)
Message-Id: <20191228.115738.611834296697018444.davem@davemloft.net>
To:     ttttabcd@protonmail.com
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] Improved handling of incorrect IP fragments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <NIK8V5mQHWZU7pO9H6W3BjBzlsZ-wjJOcqNEcRaDxLVswAF_ynPFCXOkIRKr-EF4EdDMMZ7Fa3cQEpoqa_Sjt0ZKUMqmZFHYI1FIVwPhJhs=@protonmail.com>
References: <NIK8V5mQHWZU7pO9H6W3BjBzlsZ-wjJOcqNEcRaDxLVswAF_ynPFCXOkIRKr-EF4EdDMMZ7Fa3cQEpoqa_Sjt0ZKUMqmZFHYI1FIVwPhJhs=@protonmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 28 Dec 2019 11:57:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ttttabcd <ttttabcd@protonmail.com>
Date: Sat, 28 Dec 2019 16:10:03 +0000

> @@ -111,6 +110,7 @@ static int ip6_frag_queue(struct frag_queue *fq, struct sk_buff *skb,
>  	struct net_device *dev;
>  	int err = -ENOENT;
>  	u8 ecn;
> +	u32 prob_offset = 0;
> 
>  	if (fq->q.flags & INET_FRAG_COMPLETE)
>  		goto err;

Please preserve the reverse christmas tree ordering of local variables
here.

Also, I don't think "Ttttabcd" is a real name.

The patch signoff is a legally binding certification, so you must
use your real name.

Explicitly in Documentation/process/submitting-patches.rst it states:

--------------------
By making a contribution to this project, I certify that:
 ...
then you just add a line saying::

	Signed-off-by: Random J Developer <random@developer.example.org>

using your real name (sorry, no pseudonyms or anonymous contributions.)
--------------------

Thank you.
