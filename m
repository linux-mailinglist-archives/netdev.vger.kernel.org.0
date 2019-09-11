Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846A9AFE30
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfIKN5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:57:49 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfIKN5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:57:49 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D10FA1500242E;
        Wed, 11 Sep 2019 06:57:47 -0700 (PDT)
Date:   Wed, 11 Sep 2019 15:57:46 +0200 (CEST)
Message-Id: <20190911.155746.438323377693362649.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2019-09-11
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911131326.24032-1-johannes@sipsolutions.net>
References: <20190911131326.24032-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 06:57:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 11 Sep 2019 15:13:25 +0200

> As detailed below, here are some more changes for -next, almost
> certainly the final round since the merge window is around the
> corner now.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Johannes.
