Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900829280E
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgJSNTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:19:36 -0400
Received: from mail.efficios.com ([167.114.26.124]:36948 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbgJSNTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 09:19:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 40490255292;
        Mon, 19 Oct 2020 09:19:34 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id C0DBrNvOVBH4; Mon, 19 Oct 2020 09:19:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id ECFBC254E64;
        Mon, 19 Oct 2020 09:19:33 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com ECFBC254E64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1603113573;
        bh=M0BMdItvnodZf2iKshbizu8bAjYebGgVLOD1oUvXyFs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=dqhCE66rSdZF2NEXBXdPyOYATz5AzB9DKKNe5i33G5qLU4A1Sko68FcvvEnK2LwDW
         0ytGnzHcE8YTXoTqq2BycWKA1m9T9c/nKl2PXy5RRkGnE16IIq+VgLN75SmJdK9d/H
         /KtTVuux4M1+kGM8J9+8HceIp0Ljq+w/QamV7MguLhk0STHO8LHNggLo0VgGpB5pGQ
         NGSbzO4cHcW1BTIyqPBIcMYAac4+Qd9ack3gX4ZTp3Eknl+25JpCqwOacigPSdzAc/
         HXy2re99f1gu+WSb9TY29j+xtZBgwQU/sYnHiLKyaAiC6sAf27nbKyz0Yu3MYwlujy
         o2zZR3EeoXCTg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4X1LApaftglY; Mon, 19 Oct 2020 09:19:33 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id E0BAC25528D;
        Mon, 19 Oct 2020 09:19:33 -0400 (EDT)
Date:   Mon, 19 Oct 2020 09:19:33 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Message-ID: <1388027317.27186.1603113573797.JavaMail.zimbra@efficios.com>
In-Reply-To: <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
References: <20201018191807.4052726-1-sashal@kernel.org> <20201018191807.4052726-35-sashal@kernel.org> <20201018124004.5f8c50a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <842ae8c4-44ef-2005-18d5-80e00c140107@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.9 035/111] ipv6/icmp: l3mdev: Perform icmp
 error route lookup on source device routing table (v2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3968 (ZimbraWebClient - FF81 (Linux)/8.8.15_GA_3968)
Thread-Topic: ipv6/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)
Thread-Index: O++JGGQaiLsP+V6zxscZGFGKFob4qg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Oct 18, 2020, at 9:40 PM, David Ahern dsahern@gmail.com wrote:

> On 10/18/20 1:40 PM, Jakub Kicinski wrote:
>> This one got applied a few days ago, and the urgency is low so it may be
>> worth letting it see at least one -rc release ;)
> 
> agreed

Likewise, I agree there is no need to hurry. Letting those patches live through
a few -rc releases before picking them into stable is a wise course of action.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
