Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F82AE535
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbgKKBAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKKBAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:00:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B38621741;
        Wed, 11 Nov 2020 01:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605056454;
        bh=qZcSZhfA5h13Su5Lmd0qP28DKQxMEDIE6EFD9WX1W4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dmvgQQO/Z55JTZt7PCpAPXJaFBulDoPZenqBLYhVWuA9aXb60LDSHqof8QSxB9CRD
         Ocf8LtcweCDygClzG5CGYzvBd52jsoyrelxSqHLBDmMScilTW0sbvkwt8X+YK0KTST
         Ddj7lnNTnzFAJY+jDe9w3rRDLzCwxO5T9zzdOeyk=
Date:   Tue, 10 Nov 2020 17:00:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: sched: fix misspellings using misspell-fixer tool
Message-ID: <20201110170052.4f471497@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5fa8e9d4.1c69fb81.5d889.5c64@mx.google.com>
References: <5fa8e9d4.1c69fb81.5d889.5c64@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 02:02:17 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Some typos are found out by misspell-fixer tool:
> 
> $ misspell-fixer -rnv ./net/sched/
> ./net/sched/act_api.c:686
> ./net/sched/act_bpf.c:68
> ./net/sched/cls_rsvp.h:241
> ./net/sched/em_cmp.c:44
> ./net/sched/sch_pie.c:408
> 
> Fix typos found by misspell-fixer.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied, thanks.
