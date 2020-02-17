Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD40216086B
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBQDCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:02:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48068 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:02:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14F7A13B52F79;
        Sun, 16 Feb 2020 19:02:08 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:02:07 -0800 (PST)
Message-Id: <20200216.190207.1866082797316332373.davem@davemloft.net>
To:     sebastien.boeuf@intel.com
Cc:     netdev@vger.kernel.org, sgarzare@redhat.com, stefanha@redhat.com
Subject: Re: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214114802.23638-1-sebastien.boeuf@intel.com>
References: <20200214114802.23638-1-sebastien.boeuf@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:02:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastien Boeuf <sebastien.boeuf@intel.com>
Date: Fri, 14 Feb 2020 12:48:00 +0100

> This series improves the semantics behind the way virtio-vsock server
> accepts connections coming from the client. Whenever the server
> receives a connection request from the client, if it is bound to the
> socket but not yet listening, it will answer with a RST packet. The
> point is to ensure each request from the client is quickly processed
> so that the client can decide about the strategy of retrying or not.
> 
> The series includes along with the improvement patch a new test to
> ensure the behavior is consistent across all hypervisors drivers.

Series applied to net-next, thanks Sebastien.
