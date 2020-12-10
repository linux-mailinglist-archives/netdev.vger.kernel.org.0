Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC9E2D52DF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 05:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbgLJEfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 23:35:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38754 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731718AbgLJEfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 23:35:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E87E04D259C28;
        Wed,  9 Dec 2020 20:34:39 -0800 (PST)
Date:   Wed, 09 Dec 2020 20:34:34 -0800 (PST)
Message-Id: <20201209.203434.528414781584177465.davem@davemloft.net>
To:     tanhuazhong@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, huangdaode@huawei.com
Subject: Re: [PATCH net-next 0/7] net: hns3: updates for -next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 20:34:40 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>
Date: Thu, 10 Dec 2020 11:42:05 +0800

> This patchset adds support for tc mqprio offload, hw tc
> offload of tc flower, and adpation for max rss size changes.

ZSeries applied, thanks.

