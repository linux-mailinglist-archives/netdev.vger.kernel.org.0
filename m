Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD173E3EC3
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfJXWFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:05:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52484 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfJXWFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:05:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20CA014B7273F;
        Thu, 24 Oct 2019 15:05:04 -0700 (PDT)
Date:   Thu, 24 Oct 2019 15:05:03 -0700 (PDT)
Message-Id: <20191024.150503.272673272041377721.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, sdf@google.com, daniel@iogearbox.net,
        songliubraving@fb.com, ast@kernel.org, paulb@mellanox.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] ICMP flow improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191021200948.23775-1-mcroce@redhat.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Oct 2019 15:05:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Mon, 21 Oct 2019 22:09:44 +0200

> This series improves the flow inspector handling of ICMP packets:
> The first two patches just add some comments in the code which would have saved
> me a few minutes of time, and refactor a piece of code.
> The third one adds to the flow inspector the capability to extract the
> Identifier field, if present, so echo requests and replies are classified
> as part of the same flow.
> The fourth patch uses the function introduced earlier to the bonding driver,
> so echo replies can be balanced across bonding slaves.

Simon has unaddressed feedback for patch #3, and this has been sitting in that
state for several days.

Please repost this series when everything is sorted, thank you.
