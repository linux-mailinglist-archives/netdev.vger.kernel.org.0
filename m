Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D96969AB
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfHTTpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:45:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729409AbfHTTpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:45:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2E0A146F0E88;
        Tue, 20 Aug 2019 12:45:49 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:45:49 -0700 (PDT)
Message-Id: <20190820.124549.2048964358332749388.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     jhansen@vmware.com, stefanha@redhat.com, sgarzare@redhat.com,
        netdev@vger.kernel.org, sthemmin@microsoft.com,
        Alexander.Levin@microsoft.com, sashal@kernel.org,
        haiyangz@microsoft.com, kys@microsoft.com, mikelley@microsoft.com,
        linux-hyperv@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: Fix a lockdep warning in __vsock_release()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566270830-28981-1-git-send-email-decui@microsoft.com>
References: <1566270830-28981-1-git-send-email-decui@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 12:45:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Tue, 20 Aug 2019 03:14:22 +0000

> +static void __vsock_release2(struct sock *sk)

Do not duplicate an entire function just to adjust some aspect of the
lock debugging, please find a cleaner and more minimal way to
implement this fix.
