Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C54C8E1A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfJBQSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:18:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbfJBQSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:18:13 -0400
Received: from localhost (unknown [172.58.43.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2A24215409DC0;
        Wed,  2 Oct 2019 09:18:11 -0700 (PDT)
Date:   Wed, 02 Oct 2019 12:18:09 -0400 (EDT)
Message-Id: <20191002.121809.873130939496092066.davem@davemloft.net>
To:     sudhakar.dindukurti@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com, dotanb@dev.mellanox.co.il
Subject: Re: [PATCH net] net/rds: Fix error handling in rds_ib_add_one()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569950462-37680-1-git-send-email-sudhakar.dindukurti@oracle.com>
References: <1569950462-37680-1-git-send-email-sudhakar.dindukurti@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 09:18:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
Date: Tue,  1 Oct 2019 10:21:02 -0700

> From: Dotan Barak <dotanb@dev.mellanox.co.il>
> 
> rds_ibdev:ipaddr_list and rds_ibdev:conn_list are initialized
> after allocation some resources such as protection domain.
> If allocation of such resources fail, then these uninitialized
> variables are accessed in rds_ib_dev_free() in failure path. This
> can potentially crash the system. The code has been updated to
> initialize these variables very early in the function.
> 
> Signed-off-by: Dotan Barak <dotanb@dev.mellanox.co.il>
> Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>

Applied.
