Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C723C0BD5
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfI0S7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:59:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfI0S7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:59:32 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7775B153F4722;
        Fri, 27 Sep 2019 11:59:29 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:59:27 +0200 (CEST)
Message-Id: <20190927.205927.145274854149509779.davem@davemloft.net>
To:     matiasevara@gmail.com
Cc:     stefanha@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2] vsock/virtio: add support for MSG_PEEK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569602663-16815-1-git-send-email-matiasevara@gmail.com>
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
        <1569602663-16815-1-git-send-email-matiasevara@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:59:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This is net-next material.
