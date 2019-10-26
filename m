Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47682E5EA2
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfJZS1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:27:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfJZS1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:27:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0D9B1424DB5B;
        Sat, 26 Oct 2019 11:26:59 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:26:59 -0700 (PDT)
Message-Id: <20191026.112659.712173290222153597.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, bgalvani@redhat.com
Subject: Re: [PATCH v2 0/2] ipv4: fix route update on metric change.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1572083332.git.pabeni@redhat.com>
References: <cover.1572083332.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 11:26:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Sat, 26 Oct 2019 11:53:38 +0200

> This fixes connected route update on some edge cases for ip addr metric
> change.
> It additionally includes self tests for the covered scenarios. The new tests
> fail on unpatched kernels and pass on the patched one.
> 
> v1 -> v2:
>  - add selftests

Series applied and queued up for -stable, thanks.
