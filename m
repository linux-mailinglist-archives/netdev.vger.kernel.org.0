Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFFF18E3F
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfEIQjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:39:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfEIQjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:39:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C228714D03A54;
        Thu,  9 May 2019 09:39:13 -0700 (PDT)
Date:   Thu, 09 May 2019 09:39:13 -0700 (PDT)
Message-Id: <20190509.093913.1261211226773919507.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190509113235.GA12387@hmswarspite.think-freely.org>
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
        <20190509113235.GA12387@hmswarspite.think-freely.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 May 2019 09:39:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 9 May 2019 07:32:35 -0400

> This is definately a valid cleanup, but I wonder if it wouldn't be better to,
> instead of removing it, to use it.  We have 2 locations where we actually call
> sctp_make_init_ack, and then have to check the return code and abort the
> operation if we get a NULL return.  Would it be a better solution (in the sense
> of keeping our control flow in line with how the rest of the state machine is
> supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
> the state machine queue in the locations where we otherwise would call
> sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?

Also, net-next is closed 8-)
