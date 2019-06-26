Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D71D56F6A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfFZROz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:14:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbfFZROy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:14:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD81314BEB0DE;
        Wed, 26 Jun 2019 10:14:53 -0700 (PDT)
Date:   Wed, 26 Jun 2019 10:14:53 -0700 (PDT)
Message-Id: <20190626.101453.103222375095547363.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     sdf@google.com, jianbol@mellanox.com, jiri@mellanox.com,
        mirq-linux@rere.qmqm.pl, willemb@google.com, sdf@fomichev.me,
        jiri@resnulli.us, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] team: Always enable vlan tx offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190626160339.35152-1-yuehaibing@huawei.com>
References: <20190624135007.GA17673@nanopsycho>
        <20190626160339.35152-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 10:14:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 27 Jun 2019 00:03:39 +0800

> We should rather have vlan_tci filled all the way down
> to the transmitting netdevice and let it do the hw/sw
> vlan implementation.
> 
> Suggested-by: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied and queued up for -stable, thanks.
