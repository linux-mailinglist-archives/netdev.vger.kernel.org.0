Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDB11423D
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 22:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfEEULW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 16:11:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54678 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEEULW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 16:11:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 97A7414DAEDCB;
        Sun,  5 May 2019 13:11:21 -0700 (PDT)
Date:   Sun, 05 May 2019 13:11:11 -0700 (PDT)
Message-Id: <20190505.131111.1043127096475376042.davem@davemloft.net>
To:     johan.hedberg@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2019-05-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505191203.GA86553@iliorx-mobl.ger.corp.intel.com>
References: <20190505191203.GA86553@iliorx-mobl.ger.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 13:11:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hedberg <johan.hedberg@gmail.com>
Date: Sun, 5 May 2019 22:12:03 +0300

> Here's one more bluetooth-next pull request for 5.2:
> 
>  - Fixed Command Complete event handling check for matching opcode
>  - Added support for Qualcomm WCN3998 controller, along with DT bindings
>  - Added default address for Broadcom BCM2076B1 controllers
> 
> Please let me know if there are any issues pulling. Thanks.

Pulled, thanks Johan.
