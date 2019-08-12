Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81B895F1
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfHLENp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:13:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfHLENo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:13:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02A2B144DC6C6;
        Sun, 11 Aug 2019 21:13:43 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:13:43 -0700 (PDT)
Message-Id: <20190811.211343.1920857192153512765.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
References: <20190809054851.20118-1-jasowang@redhat.com>
        <20190810134948-mutt-send-email-mst@kernel.org>
        <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:13:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 12 Aug 2019 10:44:51 +0800

> On 2019/8/11 上午1:52, Michael S. Tsirkin wrote:
>> At this point how about we revert
>> 7f466032dc9e5a61217f22ea34b2df932786bbfc
>> for this release, and then re-apply a corrected version
>> for the next one?
> 
> If possible, consider we've actually disabled the feature. How about
> just queued those patches for next release?

I'm tossing this series while you and Michael decide how to move forward.
