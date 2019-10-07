Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAFCE470
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 15:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfJGN6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 09:58:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727536AbfJGN6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 09:58:52 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D68301411EAE1;
        Mon,  7 Oct 2019 06:58:50 -0700 (PDT)
Date:   Mon, 07 Oct 2019 15:58:49 +0200 (CEST)
Message-Id: <20191007.155849.1777230056892941307.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Subject: Re: [PATCH net-next 0/6] net/tls: minor micro optimizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 07 Oct 2019 06:58:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sun,  6 Oct 2019 21:09:26 -0700

> This set brings a number of minor code changes from my tree which
> don't have a noticeable impact on performance but seem reasonable
> nonetheless.
> 
> First sk_msg_sg copy array is converted to a bitmap, zeroing that
> structure takes a lot of time, hence we should try to keep it
> small.
> 
> Next two conditions are marked as unlikely, GCC seemed to had
> little trouble correctly reasoning about those.
> 
> Patch 4 adds parameters to tls_device_decrypted() to avoid
> walking structures, as all callers already have the relevant
> pointers.
> 
> Lastly two boolean members of TLS context structures are
> converted to a bitfield.

All looks good, series applied.
