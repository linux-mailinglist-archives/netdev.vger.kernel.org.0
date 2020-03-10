Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEBE180C3E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCJXVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:21:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbgCJXVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:21:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24D8C14CF6D41;
        Tue, 10 Mar 2020 16:21:22 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:21:21 -0700 (PDT)
Message-Id: <20200310.162121.2204077194507772780.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] 100GbE Intel Wired LAN
 Driver Updates 2020-03-10
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310145134.7937946c@kicinski-fedora-PC1C0HJN>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
        <20200310145134.7937946c@kicinski-fedora-PC1C0HJN>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:21:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 10 Mar 2020 14:51:34 -0700

> On Tue, 10 Mar 2020 13:45:19 -0700 Jeff Kirsher wrote:
>> This series contains updates to ice and iavf drivers.
> ...
>> v2: Dropped patch 5 of the original series, where Tony added tunnel
>>     offload support.  Based on community feedback, the patch needed
>>     changes, so giving Tony additional time to work on those changes and
>>     not hold up the remaining changes in the series.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Pulled, thank everyone.
