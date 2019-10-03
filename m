Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6970FCA128
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfJCPbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:31:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbfJCPbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:31:40 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8B6F14304E52;
        Thu,  3 Oct 2019 08:31:39 -0700 (PDT)
Date:   Thu, 03 Oct 2019 11:31:36 -0400 (EDT)
Message-Id: <20191003.113136.126771249367519292.davem@davemloft.net>
To:     yihung.wei@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Allow attaching helper in later commit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569872344-14380-1-git-send-email-yihung.wei@gmail.com>
References: <1569872344-14380-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 08:31:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi-Hung Wei <yihung.wei@gmail.com>
Date: Mon, 30 Sep 2019 12:39:04 -0700

> -		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit) &&
> +		if ((nf_ct_is_confirmed(ct) ? !cached | add_helper :

I would suggest using "||" instea of "|" here since you are computing
a boolean.
