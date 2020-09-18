Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F2726E9C5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgIRAH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIRAH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:07:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53269C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:07:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3F2213671A30;
        Thu, 17 Sep 2020 16:50:39 -0700 (PDT)
Date:   Thu, 17 Sep 2020 17:07:26 -0700 (PDT)
Message-Id: <20200917.170726.1556365058537185463.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] selftests: Set default protocol for raw
 sockets in nettest
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917151333.41252-1-dsahern@kernel.org>
References: <20200917151333.41252-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:50:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu, 17 Sep 2020 09:13:33 -0600

> IPPROTO_IP (0) is not valid for raw sockets. Default the protocol for
> raw sockets to IPPROTO_RAW if the protocol has not been set via the -P
> option.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied, thanks David.
