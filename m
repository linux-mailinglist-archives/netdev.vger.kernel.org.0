Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 023D6AE4D0
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391115AbfIJHpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:45:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfIJHpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 03:45:41 -0400
Received: from localhost (unknown [88.214.187.83])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0DB715449D9E;
        Tue, 10 Sep 2019 00:45:38 -0700 (PDT)
Date:   Tue, 10 Sep 2019 09:45:37 +0200 (CEST)
Message-Id: <20190910.094537.964213793959104412.davem@davemloft.net>
To:     msuchanek@suse.de
Cc:     netdev@vger.kernel.org, julietk@linux.vnet.ibm.com,
        benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        tlfalcon@linux.ibm.com, jallen@linux.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ibmvnic: Fix missing { in __ibmvnic_reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190909204451.7929-1-msuchanek@suse.de>
References: <20190907.173714.1400426487600521308.davem@davemloft.net>
        <20190909204451.7929-1-msuchanek@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 00:45:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>
Date: Mon,  9 Sep 2019 22:44:51 +0200

> Commit 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
> adds a } without corresponding { causing build break.
> 
> Fixes: 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>

Applied.
