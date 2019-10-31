Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA63EB776
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbfJaSn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:43:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729410AbfJaSn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:43:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60FA614FC7132;
        Thu, 31 Oct 2019 11:43:58 -0700 (PDT)
Date:   Thu, 31 Oct 2019 11:43:58 -0700 (PDT)
Message-Id: <20191031.114358.663660017034219188.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2019-10-31
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031103743.24923-1-johannes@sipsolutions.net>
References: <20191031103743.24923-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 11:43:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 31 Oct 2019 11:37:42 +0100

> We have two more fixes, see below.
> 
> Please pull and let me know if there's any problem.

Pulled, thank you very much.
