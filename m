Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938ECCD228
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfJFNfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:35:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44286 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfJFNfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:35:04 -0400
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0148D1427577F;
        Sun,  6 Oct 2019 06:35:03 -0700 (PDT)
Date:   Sun, 06 Oct 2019 15:35:03 +0200 (CEST)
Message-Id: <20191006.153503.371264831752944300.davem@davemloft.net>
To:     danieltimlee@gmail.com
Cc:     brouer@redhat.com, toke@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/4] samples: pktgen: allow to specify
 destination IP range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191005082509.16137-1-danieltimlee@gmail.com>
References: <20191005082509.16137-1-danieltimlee@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 06 Oct 2019 06:35:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel T. Lee" <danieltimlee@gmail.com>
Date: Sat,  5 Oct 2019 17:25:05 +0900

> Currently, pktgen script supports specify destination port range.
> 
> To further extend the capabilities, this commit allows to specify destination
> IP range with CIDR when running pktgen script.
> 
> Specifying destination IP range will be useful on various situation such as 
> testing RSS/RPS with randomizing n-tuple.
> 
> This patchset fixes the problem with checking the command result on proc_cmd,
> and add feature to allow destination IP range.

Jesper, please review.
