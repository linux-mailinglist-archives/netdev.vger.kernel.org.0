Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA173B945
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391107AbfFJQVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:21:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388996AbfFJQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:21:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 40C4F15051BBC;
        Mon, 10 Jun 2019 09:21:32 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:21:31 -0700 (PDT)
Message-Id: <20190610.092131.2236695647399216988.davem@davemloft.net>
To:     varun@chelsio.com
Cc:     netdev@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com,
        ganji.aravind@chelsio.com
Subject: Re: [PATCH v3 net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM
 page pods for iSCSI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560171994-9505-1-git-send-email-varun@chelsio.com>
References: <1560171994-9505-1-git-send-email-varun@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Jun 2019 09:21:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>
Date: Mon, 10 Jun 2019 18:36:34 +0530

> Page pods are used for direct data placement, this patch
> enables eDRAM page pods if firmware supports this feature.
> 
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>  v3: reordered local variable declarations in reverse christmas tree format
>  v2: fixed incorrect spelling of "contiguous"

Applied.
