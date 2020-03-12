Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8511828EF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbgCLGXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:23:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387784AbgCLGXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:23:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1098B14DA84BB;
        Wed, 11 Mar 2020 23:23:03 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:23:02 -0700 (PDT)
Message-Id: <20200311.232302.1442236068172575398.davem@davemloft.net>
To:     joe@perches.com
Cc:     borisp@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 001/491] MELLANOX ETHERNET INNOVA DRIVERS: Use
 fallthrough;
From:   David Miller <davem@davemloft.net>
In-Reply-To: <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
        <605f5d4954fcb254fe6fc5c22dc707f29b3b7405.1583896347.git.joe@perches.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:23:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Joe, please use Subject line subsystem prefixes consistent with what would
be used for other changes to these drivers.

Thank you.
