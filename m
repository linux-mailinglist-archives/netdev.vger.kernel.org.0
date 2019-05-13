Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE48B1B17D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 09:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfEMHtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 03:49:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:42214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727576AbfEMHtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 03:49:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20EFAAF57;
        Mon, 13 May 2019 07:49:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C51ADE014B; Mon, 13 May 2019 09:49:28 +0200 (CEST)
Date:   Mon, 13 May 2019 09:49:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Weilong Chen <chenweilong@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
Message-ID: <20190513074928.GC22349@unicorn.suse.cz>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 09:33:13AM +0800, Weilong Chen wrote:
> The remote host answers to an ICMP timestamp request.
> This allows an attacker to know the time and date on your host.

Why is that a problem? If it is, does it also mean that it is a security
problem to have your time in sync (because then the attacker doesn't
even need ICMP timestamps to know the time and date on your host)?

> This path is an another way contrast to iptables rules:
> iptables -A input -p icmp --icmp-type timestamp-request -j DROP
> iptables -A output -p icmp --icmp-type timestamp-reply -j DROP
> 
> Default is disabled to improve security.

If we need a sysctl for this (and I'm not convinced we do), I would
prefer preserving current behaviour by default.

Michal Kubecek
