Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B70864B25E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbfFSGtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:49:19 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:56527 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfFSGtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 02:49:19 -0400
X-Originating-IP: 90.88.23.150
Received: from bootlin.com (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 08665240017;
        Wed, 19 Jun 2019 06:49:12 +0000 (UTC)
Date:   Wed, 19 Jun 2019 08:49:21 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] net: mvpp2: cls: Add pmap to fs dump
Message-ID: <20190619084921.7e1310e0@bootlin.com>
In-Reply-To: <20190618160910.62922-1-nhuck@google.com>
References: <20190618083900.78eb88bd@bootlin.com>
        <20190618160910.62922-1-nhuck@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nathan,

On Tue, 18 Jun 2019 09:09:10 -0700
Nathan Huckleberry <nhuck@google.com> wrote:

>There was an unused variable 'mvpp2_dbgfs_prs_pmap_fops'
>Added a usage consistent with other fops to dump pmap
>to userspace.

Thanks for sending a fix. Besides the typo preventing your patch from
compiling, you should also prefix the patch by "net: mvpp2: debugfs:"
rather than "cls", which is used for classifier patches.

Thanks,

Maxime
