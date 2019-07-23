Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF70472122
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391923AbfGWUxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:53:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGWUxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:53:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D57A153BE456;
        Tue, 23 Jul 2019 13:53:10 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:53:09 -0700 (PDT)
Message-Id: <20190723.135309.1548613883260911170.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/4] nfp: Offload MPLS actions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
References: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:53:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Tue, 23 Jul 2019 15:33:58 +0100

> The module act_mpls has recently been added to the kernel. This allows the
> manipulation of MPLS headers on packets including push, pop and modify.
> Add these new actions and parameters to the intermediate representation
> API for hardware offload. Follow this by implementing the offload of these
> MPLS actions in the NFP driver.

Looks nice, clean, and straightforward.

Applied, thanks.
