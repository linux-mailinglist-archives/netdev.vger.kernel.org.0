Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7003D856D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 03:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfJPBTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 21:19:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42900 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfJPBTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 21:19:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1873511F5F798;
        Tue, 15 Oct 2019 18:19:37 -0700 (PDT)
Date:   Tue, 15 Oct 2019 18:19:36 -0700 (PDT)
Message-Id: <20191015.181936.1206475589133546355.davem@davemloft.net>
To:     jgross@suse.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/2] xen/netback: bug fix and cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014090910.9701-1-jgross@suse.com>
References: <20191014090910.9701-1-jgross@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 18:19:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juergen Gross <jgross@suse.com>
Date: Mon, 14 Oct 2019 11:09:08 +0200

> One bugfix (patch 1) I stumbled over while doing a cleanup (patch 2)
> of the xen-netback init/deinit code.

Please do not mix cleanups and genuine bug fixes.

Submit the bug fix targetting the 'net' GIT tree, and once that eventually
gets merged into 'net-next' you can submit the cleanup against that.

Thanks.
