Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DBF159E6E
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 01:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgBLA7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 19:59:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgBLA7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 19:59:44 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64EC51516691F;
        Tue, 11 Feb 2020 16:59:43 -0800 (PST)
Date:   Tue, 11 Feb 2020 16:59:42 -0800 (PST)
Message-Id: <20200211.165942.1140404022750649575.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 0/4] Remove rtnl lock dependency from
 flow_action infra
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200211091918.20974-1-vladbu@mellanox.com>
References: <20200211091918.20974-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Feb 2020 16:59:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


net-next is closed, please resubmit when it opens back up.

Thank you.
