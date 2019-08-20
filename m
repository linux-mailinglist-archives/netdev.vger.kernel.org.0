Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E818995347
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfHTBUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:20:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfHTBUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:20:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56CCC14B8DDA4;
        Mon, 19 Aug 2019 18:20:02 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:20:01 -0700 (PDT)
Message-Id: <20190819.182001.2189224716784282925.davem@davemloft.net>
To:     vladbu@mellanox.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, lucasb@mojatatu.com,
        mrv@mojatatu.com, shuah@kernel.org, batuhanosmantaskaya@gmail.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 0/2] Fix problems with using ns plugin
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819075208.12240-1-vladbu@mellanox.com>
References: <20190819075208.12240-1-vladbu@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:20:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>
Date: Mon, 19 Aug 2019 10:52:06 +0300

> Recent changes to plugin architecture broke some of the tests when running tdc
> without specifying a test group. Fix tests incompatible with ns plugin and
> modify tests to not reuse interface name of ns veth interface for dummy
> interface.

Series applied.
