Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C59F32DD1A
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhCDWdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:33:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45826 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhCDWdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:33:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AD9624D2D0CCF;
        Thu,  4 Mar 2021 14:33:51 -0800 (PST)
Date:   Thu, 04 Mar 2021 14:33:47 -0800 (PST)
Message-Id: <20210304.143347.415521310565498642.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, dvyukov@google.com
Subject: Re: [PATCH] cipso,calipso: resolve a number of problems with the
 DOI refcounts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <161489339182.63157.2775083878484465675.stgit@olly>
References: <161489339182.63157.2775083878484465675.stgit@olly>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 04 Mar 2021 14:33:51 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Thu, 04 Mar 2021 16:29:51 -0500

> +static void calipso_doi_putdef(struct calipso_doi *doi_def);
> +

This is a global symbol, so why the static decl here?

Thanks.
