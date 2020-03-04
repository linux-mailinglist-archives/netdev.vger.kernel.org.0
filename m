Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFE117988D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgCDTFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:05:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:45164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgCDTFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 14:05:35 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BBA215820CDE;
        Wed,  4 Mar 2020 11:05:34 -0800 (PST)
Date:   Wed, 04 Mar 2020 11:05:31 -0800 (PST)
Message-Id: <20200304.110531.1931234362793099232.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com
Subject: Re: [PATCH net-next 0/2] Fixes for tc act_ct software offload of
 established flows (diff v4->v6)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 11:05:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Wed,  4 Mar 2020 13:49:37 +0200

> v4 of the original patchset was accidentally merged while we moved ahead
> with v6 review. This two patches are the diff between v4 that was merged and
> v6 that was the final revision, which was acked by the community.

Series applied, thanks Paul.
