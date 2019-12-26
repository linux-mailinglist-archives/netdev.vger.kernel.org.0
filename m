Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C44C12AFBC
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLZX1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:27:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZX1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:27:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24980153A41D6;
        Thu, 26 Dec 2019 15:27:31 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:27:30 -0800 (PST)
Message-Id: <20191226.152730.1286140920999493173.davem@davemloft.net>
To:     manishc@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH net 0/2] bnx2x: Bug fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191223182309.3919-1-manishc@marvell.com>
References: <20191223182309.3919-1-manishc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:27:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>
Date: Mon, 23 Dec 2019 10:23:07 -0800

> This series has changes in the area of vlan resources
> management APIs to fix fw assert issue reported in max
> vlan configuration testing over the PF.
> 
> Please consider applying it to "net"

Series applied, thanks.
