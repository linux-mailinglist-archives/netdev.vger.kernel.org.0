Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E8822A45D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbgGWBI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWBI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:08:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCE5C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:08:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0EAA5126B5342;
        Wed, 22 Jul 2020 17:52:10 -0700 (PDT)
Date:   Wed, 22 Jul 2020 18:08:55 -0700 (PDT)
Message-Id: <20200722.180855.1247228846076080749.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v2 net-next 00/10] l2tp: cleanup checkpatch.pl warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:52:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Wed, 22 Jul 2020 17:32:04 +0100

> l2tp hasn't been kept up to date with the static analysis checks offered
> by checkpatch.pl.
> 
> This series addresses a range of minor issues which don't involve large
> changes to code structure.  The changes include:
> 
>  * tweaks to use of whitespace, comment style, line breaks,
>    and indentation
> 
>  * two minor modifications to code to use a function or macro suggested
>    by checkpatch
> 
> v1 -> v2
> 
>  * combine related patches (patches fixing whitespace issues, patches
>    addressing comment style)
> 
>  * respin the single large patchset into a multiple smaller series for
>    easier review

Series applied, thank you.
