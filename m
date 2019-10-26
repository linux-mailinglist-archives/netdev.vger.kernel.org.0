Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46992E5EAF
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfJZSkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:40:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfJZSkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:40:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 83CA514DEFEDB;
        Sat, 26 Oct 2019 11:40:34 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:40:33 -0700 (PDT)
Message-Id: <20191026.114033.28887362771010992.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: list required kernel options
 for act_ct action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572102669-19910-1-git-send-email-mrv@mojatatu.com>
References: <1572102669-19910-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 11:40:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sat, 26 Oct 2019 11:11:09 -0400

> Updated config with required kernel options for conntrac TC action,
> so that tdc can run the tests.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied, thanks.
