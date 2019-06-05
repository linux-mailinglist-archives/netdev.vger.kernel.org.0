Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 270DB3559A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 05:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFEDRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 23:17:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEDRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 23:17:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D56BB15047810;
        Tue,  4 Jun 2019 20:17:41 -0700 (PDT)
Date:   Tue, 04 Jun 2019 20:17:41 -0700 (PDT)
Message-Id: <20190604.201741.2198584533127418560.davem@davemloft.net>
To:     varun@chelsio.com
Cc:     netdev@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com,
        ganji.aravind@chelsio.com
Subject: Re: [PATCH v2 net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM
 page pods for iSCSI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1559643109-3397-1-git-send-email-varun@chelsio.com>
References: <1559643109-3397-1-git-send-email-varun@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 20:17:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>
Date: Tue,  4 Jun 2019 15:41:49 +0530

> +static int setup_ppod_edram(struct adapter *adap)
> +{
> +	int ret;
> +	unsigned int param, val;

Reverse christmas tree please.
