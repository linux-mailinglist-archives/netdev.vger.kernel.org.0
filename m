Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D315EA82D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfJaAVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:21:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbfJaAVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:21:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA02F14E0FDB8;
        Wed, 30 Oct 2019 17:21:53 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:21:51 -0700 (PDT)
Message-Id: <20191030.172151.339466224535362239.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, sdf@google.com, daniel@iogearbox.net,
        songliubraving@fb.com, ast@kernel.org, paulb@mellanox.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] ICMP flow improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029135053.10055-1-mcroce@redhat.com>
References: <20191029135053.10055-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:21:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Tue, 29 Oct 2019 14:50:49 +0100

> This series improves the flow inspector handling of ICMP packets:
> The first two patches just add some comments in the code which would have saved
> me a few minutes of time, and refactor a piece of code.
> The third one adds to the flow inspector the capability to extract the
> Identifier field, if present, so echo requests and replies are classified
> as part of the same flow.
> The fourth patch uses the function introduced earlier to the bonding driver,
> so echo replies can be balanced across bonding slaves.
> 
> v1 -> v2:
>  - remove unused struct members
>  - add an helper to check for the Id field
>  - use a local flow_dissector_key in the bonding to avoid
>    changing behaviour of the flow dissector

Series applied to net-next, thanks.
