Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB412AFCB
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 00:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLZXig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 18:38:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44678 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfLZXig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 18:38:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11F62153AC2DE;
        Thu, 26 Dec 2019 15:38:36 -0800 (PST)
Date:   Thu, 26 Dec 2019 15:38:35 -0800 (PST)
Message-Id: <20191226.153835.1092744996447366504.davem@davemloft.net>
To:     qdkevin.kou@gmail.com
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: move trace_sctp_probe_path into
 sctp_outq_sack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
References: <20191226122917.431-1-qdkevin.kou@gmail.com>
        <43c9d517-aea4-1c6d-540b-8ffda6f04109@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 15:38:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Kou <qdkevin.kou@gmail.com>
Date: Fri, 27 Dec 2019 07:09:07 +0800

> 
> 
>>From: Kevin Kou <qdkevin.kou@xxxxxxxxx>
>>Date: Thu, 26 Dec 2019 12:29:17 +0000
>>
>>> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
>>> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
>>> and trigger sctp_probe_path_trace in sctp_outq_sack.
>> ...
>>
>>Applied, but why did you remove the trace enabled check, just out of
>>curiosity?
> 
> Actually, the check in trace_sctp_probe_path_enabled also done in
> trace_sctp_probe_path according to the Macro definition, both check
> if (static_key_false(&__tracepoint_##name.key)).

Indeed, thanks for the explanation.
