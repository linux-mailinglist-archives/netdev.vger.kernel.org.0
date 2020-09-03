Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D43A25CE82
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 01:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgICXws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 19:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgICXwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 19:52:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0422C061244;
        Thu,  3 Sep 2020 16:52:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3D86128967DA;
        Thu,  3 Sep 2020 16:36:00 -0700 (PDT)
Date:   Thu, 03 Sep 2020 16:52:46 -0700 (PDT)
Message-Id: <20200903.165246.626786206174168805.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net 0/4] net/smc: fixes 2020-09-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200903195318.39288-1-kgraul@linux.ibm.com>
References: <20200903195318.39288-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 16:36:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Thu,  3 Sep 2020 21:53:14 +0200

> Please apply the following patch series for smc to netdev's net tree.
> 
> Patch 1 fixes the toleration of older SMC implementations. Patch 2
> takes care of a problem that happens when SMCR is used after SMCD
> initialization failed. Patch 3 fixes a problem with freed send buffers,
> and patch 4 corrects refcounting when SMC terminates due to device
> removal.

Series applied, thank you.
