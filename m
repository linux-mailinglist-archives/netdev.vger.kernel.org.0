Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C959C3BF60E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhGHHQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:16:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46542 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhGHHQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:16:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6E16E4D0F3489;
        Thu,  8 Jul 2021 00:13:24 -0700 (PDT)
Date:   Thu, 08 Jul 2021 00:13:18 -0700 (PDT)
Message-Id: <20210708.001318.1836277281789484963.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        maze@google.com, kafai@fb.com
Subject: Re: [PATCH v2 net] ipv6: tcp: drop silly ICMPv6 packet too big
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210708065001.1150422-1-eric.dumazet@gmail.com>
References: <20210708065001.1150422-1-eric.dumazet@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 08 Jul 2021 00:13:24 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_mtu_to_mss needs to be exported
