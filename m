Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526CD241F31
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgHKR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbgHKR15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:27:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F5EC06174A;
        Tue, 11 Aug 2020 10:27:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A04E412880A3C;
        Tue, 11 Aug 2020 10:11:10 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:27:55 -0700 (PDT)
Message-Id: <20200811.102755.1446456447757407019.davem@davemloft.net>
To:     tim.froidcoeur@tessares.net
Cc:     kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kaber@trash.net, hidden@balabit.hu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] net: initialize fastreuse on
 inet_inherit_port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806123024.585212-1-tim.froidcoeur@tessares.net>
References: <20200806123024.585212-1-tim.froidcoeur@tessares.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 10:11:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


These patches do not apply cleanly to the current net tree.
