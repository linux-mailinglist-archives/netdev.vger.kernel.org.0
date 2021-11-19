Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384C44571FD
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhKSPte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:49:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55108 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbhKSPtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:49:33 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 131A54D2DC50A;
        Fri, 19 Nov 2021 07:46:29 -0800 (PST)
Date:   Fri, 19 Nov 2021 15:46:24 +0000 (GMT)
Message-Id: <20211119.154624.385742174897604212.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev, edumazet@google.com
Subject: Re: [PATCH net 0/2] mptcp: fix 3rd ack rtx timer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1637331462.git.pabeni@redhat.com>
References: <cover.1637331462.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 19 Nov 2021 07:46:31 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 19 Nov 2021 15:27:53 +0100

> Eric noted that the MPTCP code do the wrong thing to schedule
> the MPJ 3rd ack timer. He also provided a patch to address the
> issues (patch 1/2).
> 
> To fix for good the MPJ 3rd ack retransmission timer, we additionally
> need to set it after the current ack is transmitted (patch 2/2)
> 
> Note that the bug went unnotice so far because all the related
> tests required some running data transfer, and that causes
> MPTCP-level ack even on the opening MPJ subflow. We now have
> explicit packet drill coverage for this code path.

Acked-by: David S. Miller <davem@davemloft.net>
