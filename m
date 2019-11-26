Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E5E10A5DE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfKZVSF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 16:18:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42418 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:18:05 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 064F514CEC90A;
        Tue, 26 Nov 2019 13:18:04 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:18:04 -0800 (PST)
Message-Id: <20191126.131804.458866733856788598.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: Fix a documentation bug wrt.
 ip_unprivileged_port_start
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125224800.147072-1-zenczykowski@gmail.com>
References: <20191125144332.23d7640e@cakuba.hsd1.ca.comcast.net>
        <20191125224800.147072-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 13:18:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Mon, 25 Nov 2019 14:48:00 -0800

> From: Maciej ¯enczykowski <maze@google.com>
> 
> It cannot overlap with the local port range - ie. with autobind selectable
> ports - and not with reserved ports.
> 
> Indeed 'ip_local_reserved_ports' isn't even a range, it's a (by default
> empty) set.
> 
> Fixes: 4548b683b781 ("Introduce a sysctl that modifies the value of PROT_SOCK.")
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied.
