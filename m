Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5F24E2BF
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgHUVfy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Aug 2020 17:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgHUVfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:35:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B49EC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 14:35:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DEDC8128B3509;
        Fri, 21 Aug 2020 14:19:07 -0700 (PDT)
Date:   Fri, 21 Aug 2020 14:35:53 -0700 (PDT)
Message-Id: <20200821.143553.1454267475258459257.davem@davemloft.net>
To:     maze@google.com
Cc:     maheshb@google.com, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, mahesh@bandewar.net, jianyang@google.com
Subject: Re: [PATCH next] net: add option to not create fall-back tunnels
 in root-ns as well
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CANP3RGc+N4O-eUAHr+mOsQ740aExW7zzbmh8V7Wb54d3teB+hQ@mail.gmail.com>
References: <20200819005123.1867051-1-maheshb@google.com>
        <20200821.140323.1479263590085016926.davem@davemloft.net>
        <CANP3RGc+N4O-eUAHr+mOsQ740aExW7zzbmh8V7Wb54d3teB+hQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 14:19:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <maze@google.com>
Date: Fri, 21 Aug 2020 14:25:20 -0700

> If no kernel command line option is specified, should the default
> be to maintain compatibility, or do you think it's okay to make
> the default be no extra interfaces?  They can AFAICT always be added
> manually via 'ip link add' netlink commands.

You can't change current default behavior, so the answer should be
obvious right?
