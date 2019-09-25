Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4853DBDFDC
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 16:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437021AbfIYOQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 10:16:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436974AbfIYOQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 10:16:50 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EC40154F585F;
        Wed, 25 Sep 2019 07:16:48 -0700 (PDT)
Date:   Wed, 25 Sep 2019 16:16:44 +0200 (CEST)
Message-Id: <20190925.161644.1269508540815516466.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     esyr@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgraul@linux.ibm.com
Subject: Re: [PATCH net v2 0/3] net/smc: move some definitions to UAPI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20af78a4-ded5-57ca-bd77-303cc7a59cf5@linux.ibm.com>
References: <cover.1568993930.git.esyr@redhat.com>
        <20190924.165240.1617972512581218831.davem@davemloft.net>
        <20af78a4-ded5-57ca-bd77-303cc7a59cf5@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 07:16:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Wed, 25 Sep 2019 14:10:05 +0200

> we have to admit that it is already late for these patches. Nevertheless
> we think it is better to come up with them now than never. We doubt there
> exists already much userland code for it - except our own IBM-provided
> package smc-tools. Thus we appreciate acceptance of these patches.

Ursula, it's going to break the build of userland code.

I consider that unacceptable.
