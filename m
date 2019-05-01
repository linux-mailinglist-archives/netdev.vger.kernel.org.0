Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF49310A73
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfEAP7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:59:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfEAP72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:59:28 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DEF41473E80D;
        Wed,  1 May 2019 08:59:27 -0700 (PDT)
Date:   Wed, 01 May 2019 11:59:25 -0400 (EDT)
Message-Id: <20190501.115925.83387273508050513.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, olteanv@gmail.com, timo.koskiahde@tttech.com,
        m-karicheri2@ti.com
Subject: Re: [PATCH net-next v1 0/4] net/sched: taprio change schedules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429224833.18208-1-vinicius.gomes@intel.com>
References: <20190429224833.18208-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:59:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Mon, 29 Apr 2019 15:48:29 -0700

> Overview
> --------
> 
> This RFC has two objectives, it adds support for changing the running
> schedules during "runtime", explained in more detail later, and
> proposes an interface between taprio and the drivers for hardware
> offloading.
 ...

Series applied.
