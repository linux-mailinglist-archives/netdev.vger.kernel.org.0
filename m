Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9D5281E3F
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgJBWYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBWYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:24:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8149DC0613D0;
        Fri,  2 Oct 2020 15:24:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0C18611E480FB;
        Fri,  2 Oct 2020 15:07:28 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:24:15 -0700 (PDT)
Message-Id: <20201002.152415.783748911596137274.davem@davemloft.net>
To:     muryo@foxmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, kuba@kernel.org
Subject: Re: Why ping latency is smaller with shorter send interval?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <tencent_2AB240953B1EC86706967C25A6279EB60509@qq.com>
References: <tencent_2AB240953B1EC86706967C25A6279EB60509@qq.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:07:29 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Can you please not send the same posting to the mailing list
three times, from three different email addresses?

Once is enough, thank you.
