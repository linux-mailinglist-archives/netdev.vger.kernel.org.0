Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B25589AF
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfF0SRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:17:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF0SRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:17:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3A47133E9BFD;
        Thu, 27 Jun 2019 11:17:05 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:17:05 -0700 (PDT)
Message-Id: <20190627.111705.1141002003036720021.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org,
        xuwei5@huawei.com
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5c06e5dd-cfb1-870c-a0a3-42397b59c734@huawei.com>
References: <20190528.235806.323127882998745493.davem@davemloft.net>
        <6e9b41c9-6edb-be7f-07ee-5480162a227e@huawei.com>
        <5c06e5dd-cfb1-870c-a0a3-42397b59c734@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:17:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Tue, 25 Jun 2019 10:28:04 +0800

> So It is ok for me to fall back to reschedule the link watch wq
> every 100 items, or is there a better way to fix it properly?

Yes, that is fine for now.
