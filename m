Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61AEC105A95
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKUTsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:48:38 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52434 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:48:38 -0500
Received: from localhost (unknown [IPv6:2001:558:600a:cc:f9f3:9371:b0b8:cb13])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 043D615043D4E;
        Thu, 21 Nov 2019 11:48:37 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:48:37 -0800 (PST)
Message-Id: <20191121.114837.1788349933957486904.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next] lwtunnel: check erspan options before
 allocating tun_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b82b4b953ffc3a7053076bdfd20d5a62e07d5ad3.1574331290.git.lucien.xin@gmail.com>
References: <b82b4b953ffc3a7053076bdfd20d5a62e07d5ad3.1574331290.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 11:48:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 21 Nov 2019 18:14:50 +0800

> As Jakub suggested on another patch, it's better to do the check
> on erspan options before allocating memory.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
