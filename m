Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49688EB7E2
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfJaTQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:16:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59634 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbfJaTQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:16:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BD7714FC9F43;
        Thu, 31 Oct 2019 12:16:52 -0700 (PDT)
Date:   Thu, 31 Oct 2019 12:16:51 -0700 (PDT)
Message-Id: <20191031.121651.2154293729808989384.davem@davemloft.net>
To:     hd@os-cillation.de
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [Possible regression?] ip route deletion behavior change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
References: <603d815f-f6db-3967-c0df-cbf084a1cbcd@os-cillation.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 31 Oct 2019 12:16:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Why haven't you CC:'d the author of the change you think caused the
problem, nor the VRF maintainer?

Please do that and resend your report.
