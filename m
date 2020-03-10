Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810DF17EE89
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgCJCZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:25:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34942 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgCJCZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:25:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2925315A0BE45;
        Mon,  9 Mar 2020 19:25:37 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:25:36 -0700 (PDT)
Message-Id: <20200309.192536.558429690765622744.davem@davemloft.net>
To:     sw@simonwunderlich.de
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/1] pull request for net: batman-adv 2020-03-06
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306120618.25714-1-sw@simonwunderlich.de>
References: <20200306120618.25714-1-sw@simonwunderlich.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:25:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri,  6 Mar 2020 13:06:17 +0100

> here is a bugfix which we would like to have integrated into net.
> 
> Please pull or let me know of any problem!

Pulled, thanks Simon.
