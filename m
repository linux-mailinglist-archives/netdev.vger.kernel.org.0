Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C203A2826BD
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJCVSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgJCVSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:18:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0ACC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 14:18:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4298911E3E4C0;
        Sat,  3 Oct 2020 14:01:57 -0700 (PDT)
Date:   Sat, 03 Oct 2020 14:18:44 -0700 (PDT)
Message-Id: <20201003.141844.1954716489004017212.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH v3 0/5] genetlink per-op policy export
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003081526.0992c2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201003084446.59042-1-johannes@sipsolutions.net>
        <20201003081526.0992c2a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 14:01:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Sat, 3 Oct 2020 08:15:26 -0700

> On Sat,  3 Oct 2020 10:44:41 +0200 Johannes Berg wrote:
>> Here's a respin, now including Jakub's patch last so that it will
>> do the right thing from the start.
>> 
>> The first patch remains the same, of course; the others have mostly
>> some rebasing going on, except for the actual export patch (patch 4)
>> which is adjusted per Jakub's review comments about exporting the
>> policy only if it's actually used for do/dump.
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
