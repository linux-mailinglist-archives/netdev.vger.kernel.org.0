Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0DAAFE5A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfIKOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:10:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43782 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfIKOK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:10:29 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADD8B1500242E;
        Wed, 11 Sep 2019 07:10:27 -0700 (PDT)
Date:   Wed, 11 Sep 2019 16:10:26 +0200 (CEST)
Message-Id: <20190911.161026.1492301520395776176.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, dirk.vandermerwe@netronome.com
Subject: Re: [PATCH net-next 0/2] devlink: add unknown 'fw_load_policy'
 value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190911110833.9005-1-simon.horman@netronome.com>
References: <20190911110833.9005-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 07:10:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Wed, 11 Sep 2019 12:08:31 +0100

> Dirk says:
> 
> Recently we added an unknown value for the 'reset_dev_on_drv_probe' devlink
> parameter. Extend the 'fw_load_policy' parameter in the same way.
> 
> The only driver that uses this right now is the nfp driver.

Series applied to net-next, thanks.
