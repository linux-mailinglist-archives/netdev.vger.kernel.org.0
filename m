Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A42C11799F
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLIWop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:44:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36790 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfLIWop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:44:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8EC5154A52B3;
        Mon,  9 Dec 2019 14:44:44 -0800 (PST)
Date:   Mon, 09 Dec 2019 14:44:44 -0800 (PST)
Message-Id: <20191209.144444.177065739418276110.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mrv@mojatatu.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] tc-testing: unbreak full listing of tdc testcases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <153a41008e46c78aab655edd0e7e1b27db1b7813.1575910628.git.dcaratti@redhat.com>
References: <153a41008e46c78aab655edd0e7e1b27db1b7813.1575910628.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 14:44:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Mon,  9 Dec 2019 17:58:52 +0100

> the following command currently fails:
> 
>  [root@fedora tc-testing]# ./tdc.py -l
>  The following test case IDs are not unique:
>  {'6f5e'}
>  Please correct them before continuing.
> 
> this happens because there are two tests having the same id:
> 
>  [root@fedora tc-testing]# grep -r 6f5e tc-tests/*
>  tc-tests/actions/pedit.json:        "id": "6f5e",
>  tc-tests/filters/basic.json:        "id": "6f5e",
> 
> fix it replacing the latest duplicate id with a brand new one:
> 
>  [root@fedora tc-testing]# sed -i 's/6f5e//1' tc-tests/filters/basic.json
>  [root@fedora tc-testing]# ./tdc.py -i
> 
> Fixes: 4717b05328ba ("tc-testing: Introduced tdc tests for basic filter")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
