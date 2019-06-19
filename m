Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C14C2DF
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbfFSVUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:20:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFSVUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:20:51 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF3781473348A;
        Wed, 19 Jun 2019 14:20:50 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:20:49 -0400 (EDT)
Message-Id: <20190619.172049.1213955048688003122.davem@davemloft.net>
To:     nhuck@google.com
Cc:     maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH v2] net: mvpp2: debugfs: Add pmap to fs dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619181715.253903-1-nhuck@google.com>
References: <20190619084921.7e1310e0@bootlin.com>
        <20190619181715.253903-1-nhuck@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:20:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Huckleberry <nhuck@google.com>
Date: Wed, 19 Jun 2019 11:17:15 -0700

> There was an unused variable 'mvpp2_dbgfs_prs_pmap_fops'
> Added a usage consistent with other fops to dump pmap
> to userspace.
> 
> Cc: clang-built-linux@googlegroups.com
> Link: https://github.com/ClangBuiltLinux/linux/issues/529
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Applied.
