Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CEA4BD10
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 17:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbfFSPiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 11:38:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35874 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfFSPiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 11:38:06 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BB57152568E1;
        Wed, 19 Jun 2019 08:38:05 -0700 (PDT)
Date:   Wed, 19 Jun 2019 11:38:04 -0400 (EDT)
Message-Id: <20190619.113804.1868092627351337937.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next 0/2] inet: fix defrag units dismantle races
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190618180900.88939-1-edumazet@google.com>
References: <20190618180900.88939-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 08:38:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 18 Jun 2019 11:08:58 -0700

> This series add a new pre_exit() method to struct pernet_operations
> to solve a race in defrag units dismantle, without adding extra
> delays to netns dismantles.

Series applied, thanks Eric.
