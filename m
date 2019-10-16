Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF57D851D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbfJPA4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:56:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfJPA4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:56:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D88E01264EA26;
        Tue, 15 Oct 2019 17:56:39 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:56:39 -0700 (PDT)
Message-Id: <20191015.175639.347136446069377956.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        david.laight@aculab.com
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:56:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 14 Oct 2019 14:14:43 +0800

> SCTP-PF was implemented based on a Internet-Draft in 2012:
> 
>   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> 
> It's been updated quite a few by rfc7829 in 2016.
> 
> This patchset adds the following features:
> 
>   1. add SCTP_ADDR_POTENTIALLY_FAILED notification
>   2. add pf_expose per netns/sock/asoc
>   3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
>   4. add ps_retrans per netns/sock/asoc/transport
>      (Primary Path Switchover)
>   5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt

I would like to see some SCTP expert ACKs here.

Thank you.
