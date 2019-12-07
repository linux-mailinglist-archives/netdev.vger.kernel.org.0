Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41BA115AEE
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 05:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfLGERQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 23:17:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfLGERQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 23:17:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9814315363EF6;
        Fri,  6 Dec 2019 20:17:15 -0800 (PST)
Date:   Fri, 06 Dec 2019 20:17:12 -0800 (PST)
Message-Id: <20191206.201712.796721034498266453.davem@davemloft.net>
To:     vvidic@valentin-vidic.from.hr
Cc:     jakub.kicinski@netronome.com, willemdebruijn.kernel@gmail.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
        <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 20:17:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Valentin Vidic <vvidic@valentin-vidic.from.hr>
Date: Thu,  5 Dec 2019 07:41:18 +0100

> ENOTSUPP is not available in userspace, for example:
> 
>   setsockopt failed, 524, Unknown error 524
> 
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

Applied and queued up for -stable, thanks.
