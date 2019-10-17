Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F46DBA50
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 01:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441838AbfJQXuZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Oct 2019 19:50:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438680AbfJQXuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 19:50:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06E7B1433DE0F;
        Thu, 17 Oct 2019 16:50:23 -0700 (PDT)
Date:   Thu, 17 Oct 2019 16:50:23 -0700 (PDT)
Message-Id: <20191017.165023.620180629772213473.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com, brouer@redhat.com, dvyukov@google.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: Stable request
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
References: <20190823.144250.2063544404229146484.davem@davemloft.net>
        <3bda6dee-7b8b-1f50-b4ea-47857ca97279@solarflare.com>
        <fa2e9f70-05bd-bcac-e502-8bdb375163ce@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 16:50:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Wed, 16 Oct 2019 16:26:50 +0100

> Hi, did this get missed or was my request improper in some way?
> Our testing has been hitting this issue on distro kernels (Fedora, Debian,
>  Ubuntu), we'd like the fix to get everywhere it's needed and AIUI -stable
>  is the proper route for that.
> For reference, the fix was committed as c7a42eb49212.

I've queued this up for my next set of -stable submissions.

Thanks Ed.
