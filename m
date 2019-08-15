Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20098F3B5
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbfHOSkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:40:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48018 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbfHOSkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:40:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B379913E985F5;
        Thu, 15 Aug 2019 11:40:20 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:40:20 -0700 (PDT)
Message-Id: <20190815.114020.1110808707080624043.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net-next] net/rds: Add RDS6_INFO_SOCKETS and
 RDS6_INFO_RECV_MESSAGES options
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565861803-31268-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1565861803-31268-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 11:40:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Thu, 15 Aug 2019 02:36:43 -0700

> Add support of the socket options RDS6_INFO_SOCKETS and
> RDS6_INFO_RECV_MESSAGES which update the RDS_INFO_SOCKETS and
> RDS_INFO_RECV_MESSAGES options respectively.  The old options work
> for IPv4 sockets only.
> 
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Applied.
