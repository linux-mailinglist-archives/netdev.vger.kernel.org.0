Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1271B4A7E4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfFRRID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:08:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50184 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfFRRIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:08:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D45E150B74CC;
        Tue, 18 Jun 2019 10:08:02 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:08:01 -0700 (PDT)
Message-Id: <20190618.100801.2026737630386139646.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, mkubecek@suse.cz
Subject: Re: [PATCH net-next v4 2/2] ipoib: show VF broadcast address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617085341.51592-4-dkirjanov@suse.com>
References: <20190617085341.51592-1-dkirjanov@suse.com>
        <20190617085341.51592-4-dkirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 10:08:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Mon, 17 Jun 2019 10:53:41 +0200

> in IPoIB case we can't see a VF broadcast address for but
> can see for PF

I just want to understand why this need to see the VF broadcast
address is IPoIB specific?
