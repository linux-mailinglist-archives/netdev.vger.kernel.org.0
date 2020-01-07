Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D2E1334F1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgAGVgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:36:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgAGVgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:36:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A01AC15A17310;
        Tue,  7 Jan 2020 13:36:22 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:36:22 -0800 (PST)
Message-Id: <20200107.133622.761302983434230321.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 0/2] vlan: rtnetlink newlink fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107094225.21243-1-edumazet@google.com>
References: <20200107094225.21243-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:36:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  7 Jan 2020 01:42:23 -0800

> First patch fixes a potential memory leak found by syzbot
> 
> Second patch makes vlan_changelink() aware of errors
> and report them to user.

Series applied and queued up for -stable, thanks Eric.
