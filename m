Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6C382719
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbfHEVn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:43:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfHEVnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 17:43:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E0A81543B2B6;
        Mon,  5 Aug 2019 14:43:55 -0700 (PDT)
Date:   Mon, 05 Aug 2019 14:43:53 -0700 (PDT)
Message-Id: <20190805.144353.1304051964359404611.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Signed-off-by missing for commit in the net tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806073825.6e6ba393@canb.auug.org.au>
References: <20190806073825.6e6ba393@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 14:43:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 Aug 2019 07:38:25 +1000

> Commit
> 
>   c3953a3c2d31 ("NFC: nfcmrvl: fix gpio-handling regression")
> 
> is missing a Signed-off-by from its committer.

That has to be the first time that's ever happened to me :-)

And indeed as I check my command line history I forgot the --signoff
command line option.

