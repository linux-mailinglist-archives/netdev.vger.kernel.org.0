Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337202F70E
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 07:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfE3FRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 01:17:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47074 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3FRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 01:17:46 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E9E813E2C2F6;
        Wed, 29 May 2019 22:17:45 -0700 (PDT)
Date:   Wed, 29 May 2019 22:17:44 -0700 (PDT)
Message-Id: <20190529.221744.1136074795446305909.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com, linville@redhat.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: copy reglen to userspace
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190528205848.21208-1-vivien.didelot@gmail.com>
References: <20190528205848.21208-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 22:17:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Tue, 28 May 2019 16:58:48 -0400

> ethtool_get_regs() allocates a buffer of size reglen obtained from
> ops->get_regs_len(), thus only this value must be used when copying
> the buffer back to userspace. Also no need to check regbuf twice.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Hmmm, can't regs.len be modified by the driver potentially?
