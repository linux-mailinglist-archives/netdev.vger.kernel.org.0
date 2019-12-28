Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3673512BC00
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 01:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfL1AgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 19:36:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfL1AgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 19:36:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65713154D18C7;
        Fri, 27 Dec 2019 16:36:14 -0800 (PST)
Date:   Fri, 27 Dec 2019 16:36:13 -0800 (PST)
Message-Id: <20191227.163613.94954890256147556.davem@davemloft.net>
To:     qdkevin.kou@gmail.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com
Subject: Re: [PATCHv3 net-next] sctp: do trace_sctp_probe after SACK
 validation and check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191225082725.1251-1-qdkevin.kou@gmail.com>
References: <20191225082725.1251-1-qdkevin.kou@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Dec 2019 16:36:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Wed, 25 Dec 2019 08:27:25 +0000

> The function sctp_sf_eat_sack_6_2 now performs the Verification
> Tag validation, Chunk length validation, Bogu check, and also
> the detection of out-of-order SACK based on the RFC2960
> Section 6.2 at the beginning, and finally performs the further
> processing of SACK. The trace_sctp_probe now triggered before
> the above necessary validation and check.
> 
> this patch is to do the trace_sctp_probe after the chunk sanity
> tests, but keep doing trace if the SACK received is out of order,
> for the out-of-order SACK is valuable to congestion control
> debugging.
> 
> v1->v2:
>  - keep doing SCTP trace if the SACK is out of order as Marcelo's
>    suggestion.
> v2->v3:
>  - regenerate the patch as v2 generated on top of v1, and add
>    'net-next' tag to the new one as Marcelo's comments.
> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>

Applied.
