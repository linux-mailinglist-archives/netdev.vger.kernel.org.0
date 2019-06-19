Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8953C4BA6D
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 15:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbfFSNqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 09:46:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSNqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 09:46:22 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D35F15214DB6;
        Wed, 19 Jun 2019 06:46:21 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:46:18 -0400 (EDT)
Message-Id: <20190619.094618.553973515758964218.davem@davemloft.net>
To:     yamada.masahiro@socionext.com
Cc:     sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldir@darbyshire-bryant.me.uk
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAK7LNARVfXySZK_Wzmww=UeFwpWu+vjbctK33zX9KW8w_adexw@mail.gmail.com>
References: <20190619132326.1846345b@canb.auug.org.au>
        <CAK7LNAQCe0APJ3ggJYRDf_DjYg=dH9+2nNsYoygiFKhTa=givg@mail.gmail.com>
        <CAK7LNARVfXySZK_Wzmww=UeFwpWu+vjbctK33zX9KW8w_adexw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 06:46:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Wed, 19 Jun 2019 13:14:06 +0900

> What a hell.

I know, some serious bush league coding going on in the networking
right?
