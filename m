Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7611DD98E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgEUVhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUVg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:36:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9720C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:36:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 506A6120ED480;
        Thu, 21 May 2020 14:36:58 -0700 (PDT)
Date:   Thu, 21 May 2020 14:36:55 -0700 (PDT)
Message-Id: <20200521.143655.904069610832429425.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     mstarovoitov@marvell.com, netdev@vger.kernel.org,
        dbezrukov@marvell.com, irusskikh@marvell.com
Subject: Re: [EXT] Re: [PATCH net-next 03/12] net: atlantic: changes for
 multi-TC support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521121156.7f776ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200520140154.6b6328de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CH2PR18MB323861420A81270EC7207300D3B70@CH2PR18MB3238.namprd18.prod.outlook.com>
        <20200521121156.7f776ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 14:36:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 21 May 2020 12:11:56 -0700

> Module parameters are very strongly discouraged for networking drivers.

I fundamentally will disallow them except in very narrowly scoped cases.

Make a real API in the kernel for what you are trying to do, or you can't
support the facility in your driver, period.
