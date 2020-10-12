Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0328BA73
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389128AbgJLOKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:10:04 -0400
Received: from mail.efficios.com ([167.114.26.124]:49278 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730092AbgJLOKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:10:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E53C22E9EA4;
        Mon, 12 Oct 2020 10:10:02 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id vsVqtoQiWkgg; Mon, 12 Oct 2020 10:10:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id B294D2E9A76;
        Mon, 12 Oct 2020 10:10:02 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com B294D2E9A76
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1602511802;
        bh=QVkLm+x0TjuTuXozjPwAMAR8pJJk7vUphDALOFnUiU8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=dvYojegqeDStGhVyafA/ZNfd5qUQlH5RV0ogiW1KahWhSE6TKc5tGoky1ofspCnU9
         b2N1bWQWH8XflQkyRhzeXxrPVpaJZ1ZwuDEODTv0j+9uEkc3av3IUmTkEeVoyJZMSu
         /UHgy8E5CdUIuF9RCd1fe0YQSqrPxJklyrc+5OYigvYir68Hmrr6WAaOtVft3QhRFu
         F7sYa/6hR1KKM51dr2+OBrOspuBu28srSy1pPcsD2SAf1u3qgNY421ChauDZj4ekE0
         YjlJmDto4VsftKpuHgVrJNyc4DXnJ60Y8G50cmBYLEu/at5Se/1nLQ6rmfKeNqv+Ur
         3C7Akra3nLEEA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3-FIHBgwVR-y; Mon, 12 Oct 2020 10:10:02 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id A262B2E9EA3;
        Mon, 12 Oct 2020 10:10:02 -0400 (EDT)
Date:   Mon, 12 Oct 2020 10:10:02 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Michael Jeanson <mjeanson@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <90427402.16599.1602511802505.JavaMail.zimbra@efficios.com>
In-Reply-To: <74f254cb-b274-48f7-6271-4056f531f9fa@gmail.com>
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com> <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com> <19cf586d-4c4e-e18c-cd9e-3fde3717a9e1@gmail.com> <2056270363.16428.1602507463959.JavaMail.zimbra@efficios.com> <74f254cb-b274-48f7-6271-4056f531f9fa@gmail.com>
Subject: Re: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - FF81 (Linux)/8.8.15_GA_3968)
Thread-Topic: l3mdev icmp error route lookup fixes
Thread-Index: 3ryJJd286QK1dZTKIcjpU6a6fmpocA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 12, 2020, at 9:45 AM, David Ahern dsahern@gmail.com wrote:

> On 10/12/20 5:57 AM, Mathieu Desnoyers wrote:
>> OK, do you want to pick up the RFC patch series, or should I re-send it
>> without RFC tag ?
> 
> you need to re-send for Dave or Jakub to pick them up via patchworks

OK. Can I have your Acked-by or Reviewed-by for all three patches ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
