Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F821D3E5A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgENUD2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 May 2020 16:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729094AbgENUD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:03:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9ECC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 13:03:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C6CA128D494B;
        Thu, 14 May 2020 13:03:26 -0700 (PDT)
Date:   Thu, 14 May 2020 13:03:26 -0700 (PDT)
Message-Id: <20200514.130326.2050471806242029227.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, xerces9@gmail.com
Subject: Re: [PATCH net] pppoe: only process PADT targeted at local
 interfaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87314848e98d74e88b3c3b2504566a7691f5a8e9.1589451271.git.gnault@redhat.com>
References: <87314848e98d74e88b3c3b2504566a7691f5a8e9.1589451271.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:03:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Thu, 14 May 2020 12:15:39 +0200

> We don't want to disconnect a session because of a stray PADT arriving
> while the interface is in promiscuous mode.
> Furthermore, multicast and broadcast packets make no sense here, so
> only PACKET_HOST is accepted.
> 
> Reported-by: David Bala¸ic <xerces9@gmail.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied and queued up for -stable, thanks.
