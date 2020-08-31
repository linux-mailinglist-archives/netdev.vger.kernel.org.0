Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA5C2581BA
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgHaT05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbgHaT04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 15:26:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E2CC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 12:26:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 117BB12889EEB;
        Mon, 31 Aug 2020 12:10:09 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:26:54 -0700 (PDT)
Message-Id: <20200831.122654.1580553485416573673.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] Add ip6_fragment in ipv6_stub
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
References: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 31 Aug 2020 12:10:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Fri, 28 Aug 2020 23:14:30 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Add ip6_fragment in ipv6_stub and use it in openvswitch
> This version add default function eafnosupport_ipv6_fragment

Seires applied, thank you.
