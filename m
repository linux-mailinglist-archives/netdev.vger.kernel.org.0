Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9B61DD990
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgEUVh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgEUVh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:37:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B56C061A0E;
        Thu, 21 May 2020 14:37:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 133D4120ED482;
        Thu, 21 May 2020 14:37:27 -0700 (PDT)
Date:   Thu, 21 May 2020 14:37:26 -0700 (PDT)
Message-Id: <20200521.143726.481524442371246082.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     tanhuazhong@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521121707.6499ca6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
        <20200521121707.6499ca6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 14:37:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 21 May 2020 12:17:07 -0700

> On Thu, 21 May 2020 19:38:23 +0800 Huazhong Tan wrote:
>> This patchset adds two new VLAN feature.
>> 
>> [patch 1] adds a new dynamic VLAN mode.
>> [patch 2] adds support for 'QoS' field to PVID.
>> 
>> Change log:
>> V1->V2: modifies [patch 1]'s commit log, suggested by Jakub Kicinski.
> 
> I don't like the idea that FW is choosing the driver behavior in a way
> that's not observable via standard Linux APIs. This is the second time
> a feature like that posted for a driver this week, and we should
> discourage it.

Agreed, this is an unacceptable approach to driver features.
