Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71A8CD223
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfJFNYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:24:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfJFNYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:24:22 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B78F1425BD92;
        Sun,  6 Oct 2019 06:24:22 -0700 (PDT)
Date:   Sun, 06 Oct 2019 15:24:19 +0200 (CEST)
Message-Id: <20191006.152419.755624128185649732.davem@davemloft.net>
To:     yihung.wei@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] openvswitch: Allow attaching helper in
 later commit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570206404-10565-1-git-send-email-yihung.wei@gmail.com>
References: <1570206404-10565-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 06:24:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>
Date: Fri,  4 Oct 2019 09:26:44 -0700

> This patch allows to attach conntrack helper to a confirmed conntrack
> entry.  Currently, we can only attach alg helper to a conntrack entry
> when it is in the unconfirmed state.  This patch enables an use case
> that we can firstly commit a conntrack entry after it passed some
> initial conditions.  After that the processing pipeline will further
> check a couple of packets to determine if the connection belongs to
> a particular application, and attach alg helper to the connection
> in a later stage.
> 
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> ---
> v1->v2, Use logical OR instead of bitwise OR as Dave suggested.

Applied.
