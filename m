Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7E75474D4
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 15:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiFKNgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 09:36:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57376 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiFKNgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 09:36:11 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 90F9683ED002;
        Sat, 11 Jun 2022 06:36:09 -0700 (PDT)
Date:   Sat, 11 Jun 2022 14:36:07 +0100 (BST)
Message-Id: <20220611.143607.1260050536985442344.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: net-next is OPEN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20220606094414.0fa7183c@kernel.org>
References: <20220606094414.0fa7183c@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 11 Jun 2022 06:36:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 6 Jun 2022 09:44:14 -0700

> As a side note I'd like to mention that there are no further
> organizational changes planned, at the moment. As you may have
> noticed we had grown the number of people who can apply patches
> to 4 (2 in each time zone). This is purely for load sharing and
> to allow each one of us to go on a vacation without impacting 
> the patch flow.

Yes, this is exactly what is going on, thanks Jakub.
