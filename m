Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FA0125362
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfLRUXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:23:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55962 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfLRUXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:23:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC06C153CEC04;
        Wed, 18 Dec 2019 12:23:41 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:23:41 -0800 (PST)
Message-Id: <20191218.122341.746507588236453344.davem@davemloft.net>
To:     vincent.cheng.xh@renesas.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] ptp: clockmatrix: Remove IDT references
 or replace with Renesas.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191218144446.GA25453@renesas.com>
References: <1576558988-20837-3-git-send-email-vincent.cheng.xh@renesas.com>
        <20191217.222956.2055609890870202125.davem@davemloft.net>
        <20191218144446.GA25453@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 12:23:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Cheng <vincent.cheng.xh@renesas.com>
Date: Wed, 18 Dec 2019 14:45:09 +0000

> What is the proper way to remove a patch submission?

Any time you are asked to make changes to a patch series, you must
submit an entire new version of the patch series.
