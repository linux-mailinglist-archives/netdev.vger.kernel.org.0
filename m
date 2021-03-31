Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B20350650
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhCaS3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 14:29:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48502 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbhCaS3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 14:29:43 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8DFD763E34;
        Wed, 31 Mar 2021 20:29:26 +0200 (CEST)
Date:   Wed, 31 Mar 2021 20:29:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nf_log_bridge: Fix missing assignment
 of ret on a call to nf_log_register
Message-ID: <20210331182938.GA28208@salvia>
References: <20210331142606.1422498-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210331142606.1422498-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 03:26:06PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the call to nf_log_register is returning an error code that
> is not being assigned to ret and yet ret is being checked. Fix this by
> adding in the missing assignment.

Applied, thanks.
