Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965F7F0BDF
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfKFCCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:02:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbfKFCCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:02:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A810215102F8E;
        Tue,  5 Nov 2019 18:02:41 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:02:41 -0800 (PST)
Message-Id: <20191105.180241.820382899920213483.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, scott.drennan@nokia.com,
        jbenc@redhat.com, martin.varghese@nokia.com
Subject: Re: [PATCH v4 net-next] Change in Openvswitch to support MPLS
 label depth of 3 in ingress direction
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572832664-3048-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1572832664-3048-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:02:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Mon,  4 Nov 2019 07:27:44 +0530

> From: Martin Varghese <martin.varghese@nokia.com>
> 
> The openvswitch was supporting a MPLS label depth of 1 in the ingress
> direction though the userspace OVS supports a max depth of 3 labels.
> This change enables openvswitch module to support a max depth of
> 3 labels in the ingress.
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>

Applied.
