Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CA486F2D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405294AbfHIBOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:14:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405145AbfHIBOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:14:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F32C14284358;
        Thu,  8 Aug 2019 18:14:19 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:14:19 -0700 (PDT)
Message-Id: <20190808.181419.69619888410470935.davem@davemloft.net>
To:     rahulv@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, mkalderon@marvell.com
Subject: Re: [PATCH net-next v2 1/1] qed: Add new ethtool supported port
 types based on media.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806065950.19073-1-rahulv@marvell.com>
References: <20190806065950.19073-1-rahulv@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:14:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Verma <rahulv@marvell.com>
Date: Mon, 5 Aug 2019 23:59:50 -0700

> Supported ports in ethtool <eth1> are displayed based on media type.
> For media type fibre and twinaxial, port type is "FIBRE". Media type
> Base-T is "TP" and media KR is "Backplane".
> 
> V1->V2:
> Corrected the subject.
> 
> Signed-off-by: Rahul Verma <rahulv@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Applied.
