Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A7DEB869
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfJaUbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:31:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:31:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 499DA14FEC57F;
        Thu, 31 Oct 2019 13:31:07 -0700 (PDT)
Date:   Thu, 31 Oct 2019 13:31:02 -0700 (PDT)
Message-Id: <20191031.133102.2235634960268789909.davem@davemloft.net>
To:     lariel@mellanox.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, sd@queasysnail.net,
        sbrivio@redhat.com, nikolay@cumulusnetworks.com, jiri@mellanox.com,
        dsahern@gmail.com, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 13:31:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The previous posted version was also v2, what are you doing?
