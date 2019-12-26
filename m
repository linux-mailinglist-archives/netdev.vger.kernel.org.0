Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA5812AEB4
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLZVH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:07:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:07:27 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3933F1510E119;
        Thu, 26 Dec 2019 13:07:27 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:07:24 -0800 (PST)
Message-Id: <20191226.130724.181678918934442450.davem@davemloft.net>
To:     qdkevin.kou@gmail.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226122917.431-1-qdkevin.kou@gmail.com>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:07:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Thu, 26 Dec 2019 12:29:17 +0000

> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
> and trigger sctp_probe_path_trace in sctp_outq_sack.
 ...

Applied, but why did you remove the trace enabled check, just out of
curiosity?
