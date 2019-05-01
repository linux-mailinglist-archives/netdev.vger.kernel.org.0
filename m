Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864E810E6C
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfEAVP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:15:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfEAVP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:15:58 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0197133E97C0;
        Wed,  1 May 2019 14:15:57 -0700 (PDT)
Date:   Wed, 01 May 2019 17:15:56 -0400 (EDT)
Message-Id: <20190501.171556.558136305355226946.davem@davemloft.net>
To:     hofrat@osadl.org
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] rds: ib: force endiannes annotation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
References: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 14:15:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>
Date: Tue, 30 Apr 2019 05:12:57 +0200

> While the endiannes is being handled correctly as indicated by the comment
> above the offending line - sparse was unhappy with the missing annotation
> as be64_to_cpu() expects a __be64 argument. To mitigate this annotation
> all involved variables are changed to a consistent __le64 and the
>  conversion to uint64_t delayed to the call to rds_cong_map_updated().
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>

Applied.
