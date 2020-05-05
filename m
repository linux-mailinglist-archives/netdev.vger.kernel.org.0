Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF7D1C61E9
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEEUXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728076AbgEEUXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:23:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94FDC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:23:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9ACED1280C7BA;
        Tue,  5 May 2020 13:23:52 -0700 (PDT)
Date:   Tue, 05 May 2020 13:23:51 -0700 (PDT)
Message-Id: <20200505.132351.136259359282011599.davem@davemloft.net>
To:     u9012063@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHv2] erspan: Add type I version 0 support.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1588694706-26433-1-git-send-email-u9012063@gmail.com>
References: <1588694706-26433-1-git-send-email-u9012063@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 13:23:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Tue,  5 May 2020 09:05:06 -0700

> 
> The Type I ERSPAN frame format is based on the barebones
> IP + GRE(4-byte) encapsulation on top of the raw mirrored frame.
> Both type I and II use 0x88BE as protocol type. Unlike type II
> and III, no sequence number or key is required.
> To creat a type I erspan tunnel device:
>   $ ip link add dev erspan11 type erspan \
>             local 172.16.1.100 remote 172.16.1.200 \
>             erspan_ver 0
> 
> Signed-off-by: William Tu <u9012063@gmail.com>

Applied to net-next, thanks.
