Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBE818D409
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 17:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgCTQTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 12:19:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbgCTQTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 12:19:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F2C815858BBA;
        Fri, 20 Mar 2020 09:19:42 -0700 (PDT)
Date:   Fri, 20 Mar 2020 09:19:39 -0700 (PDT)
Message-Id: <20200320.091939.549165643522518933.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-03-20
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320134642.87932-1-johannes@sipsolutions.net>
References: <20200320134642.87932-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Mar 2020 09:19:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 20 Mar 2020 14:46:41 +0100

> Here's another set of changes for net-next, nothing really stands out,
> but see the description and shortlog below.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
