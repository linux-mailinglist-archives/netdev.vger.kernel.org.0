Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C90BD9915
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390712AbfJPSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:22:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfJPSWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:22:02 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6A431425BDB6;
        Wed, 16 Oct 2019 11:22:01 -0700 (PDT)
Date:   Wed, 16 Oct 2019 14:21:59 -0400 (EDT)
Message-Id: <20191016.142159.1388461310782297107.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     walteste@inf.ethz.ch, bcodding@redhat.com, gsierohu@redhat.com,
        nforro@redhat.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv4: Return -ENETUNREACH if we can't create
 route but saddr is valid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7bcfeaac2f78657db35ccf0e624745de41162129.1570722417.git.sbrivio@redhat.com>
References: <7bcfeaac2f78657db35ccf0e624745de41162129.1570722417.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 11:22:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Thu, 10 Oct 2019 17:51:50 +0200

> I think this should be considered for -stable, < 5.2

Changes meant for -stable should not target net-next, but rather net.
