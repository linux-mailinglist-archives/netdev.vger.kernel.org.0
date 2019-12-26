Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9912AEEB
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfLZVZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:25:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43616 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfLZVZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:25:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8F971518C31B;
        Thu, 26 Dec 2019 13:25:17 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:25:17 -0800 (PST)
Message-Id: <20191226.132517.1836028878387000330.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH v7 net-next 0/9] ipv6: Extension header infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALx6S36EUz_KiZ=q-uT-+NYSymBN+LsnmWG5=uMUVkrQKvBnJQ@mail.gmail.com>
References: <1577210148-7328-1-git-send-email-tom@herbertland.com>
        <20191225.161927.1679721474728857271.davem@davemloft.net>
        <CALx6S36EUz_KiZ=q-uT-+NYSymBN+LsnmWG5=uMUVkrQKvBnJQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:25:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Thu, 26 Dec 2019 13:12:11 -0800

> The fundamental rationale here is to make various TLVs, in particular
 ...

Don't tell me, put it in the introductory commit message.
