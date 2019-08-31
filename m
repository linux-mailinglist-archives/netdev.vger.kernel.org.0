Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB02A4615
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfHaUPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:15:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfHaUPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:15:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 667DB14B87778;
        Sat, 31 Aug 2019 13:15:53 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:15:52 -0700 (PDT)
Message-Id: <20190831.131552.2238215337254700030.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/1] pull request for net-next: batman-adv 2019-08-30
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830072736.18535-1-sw@simonwunderlich.de>
References: <20190830072736.18535-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 13:15:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri, 30 Aug 2019 09:27:35 +0200

> here is a small maintenance pull request of batman-adv to go into net-next.
> 
> Please pull or let me know of any problem!

Pulled, but generally speaking MAINTAINERS updates are always legitimate
for 'net'.
