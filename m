Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD93D1896AE
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgCRILR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727384AbgCRILK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B134E148F63C3;
        Wed, 18 Mar 2020 01:11:09 -0700 (PDT)
Date:   Tue, 17 Mar 2020 23:40:05 -0700 (PDT)
Message-Id: <20200317.234005.365698908064063570.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 11/17] net: core: dev.c: fix a documentation warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <23cd1652cbe7009f25993786c91460543e8a8a41.1584456635.git.mchehab+huawei@kernel.org>
References: <cover.1584456635.git.mchehab+huawei@kernel.org>
        <23cd1652cbe7009f25993786c91460543e8a8a41.1584456635.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Tue, 17 Mar 2020 15:54:20 +0100

> There's a markup for link with is "foo_". On this kernel-doc
> comment, we don't want this, but instead, place a literal
> reference. So, escape the literal with ``foo``, in order to
> avoid this warning:
> 
> 	./net/core/dev.c:5195: WARNING: Unknown target name: "page_is".
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Applied.
