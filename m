Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB46871A3
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405472AbfHIFmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:42:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfHIFmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:42:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 787B81449A656;
        Thu,  8 Aug 2019 22:42:13 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:42:13 -0700 (PDT)
Message-Id: <20190808.224213.1161867916822706934.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@resnulli.us, jay.vosburgh@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] team: Add vlan tx offload to hw_enc_features
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808062247.38352-1-yuehaibing@huawei.com>
References: <20190807023808.51976-1-yuehaibing@huawei.com>
        <20190808062247.38352-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:42:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 8 Aug 2019 14:22:47 +0800

> We should also enable team's vlan tx offload in hw_enc_features,
> pass the vlan packets to the slave devices with vlan tci, let the
> slave handle vlan tunneling offload implementation.
> 
> Fixes: 3268e5cb494d ("team: Advertise tunneling offload features")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: fix commit log typo

Applied and queued up for -stable.
