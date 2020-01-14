Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 463D313B2FA
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgANT3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:29:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANT3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:29:34 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E322153564CF;
        Tue, 14 Jan 2020 11:29:33 -0800 (PST)
Date:   Tue, 14 Jan 2020 11:29:33 -0800 (PST)
Message-Id: <20200114.112933.1530142161419619766.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 0/3] netns: Optimise netns ID lookups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1578950227.git.gnault@redhat.com>
References: <cover.1578950227.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 11:29:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Mon, 13 Jan 2020 22:39:19 +0100

> Netns ID lookups can be easily protected by RCU, rather than by holding
> a spinlock.
> 
> Patch 1 prepares the code, patch 2 does the RCU conversion, and finally
> patch 3 stops disabling BHs on updates (patch 2 makes that unnecessary).

Series applied, thanks.
