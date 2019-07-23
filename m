Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65BE71F8A
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391563AbfGWSqu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Jul 2019 14:46:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35012 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfGWSqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:46:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9696A153B91EA;
        Tue, 23 Jul 2019 11:46:49 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:46:49 -0700 (PDT)
Message-Id: <20190723.114649.1745070901171139330.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     netdev@vger.kernel.org, lorenzo@google.com, reminv@google.com,
        raorn@raorn.name
Subject: Re: [PATCH] net-ipv6-ndisc: add support for RFC7710 RA Captive
 Portal Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANP3RGfG0gcA1a8n550+X1+43=6tpzdv4YG+FX6GQanfWKG7QQ@mail.gmail.com>
References: <20190719063003.10684-1-zenczykowski@gmail.com>
        <20190722.121107.493176692915633338.davem@davemloft.net>
        <CANP3RGfG0gcA1a8n550+X1+43=6tpzdv4YG+FX6GQanfWKG7QQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 11:46:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue, 23 Jul 2019 17:52:17 +0800

>> Applied to net-next
> 
> Any chance we could get this into LTS releases?

It's a new feature, not a bug fix.  So no.
