Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD5E276562
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgIXArK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgIXArF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:47:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16D9C0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 17:47:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2EDE120EA806;
        Wed, 23 Sep 2020 17:30:17 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:47:04 -0700 (PDT)
Message-Id: <20200923.174704.141560329827171928.davem@davemloft.net>
To:     tiantao6@hisilicon.com
Cc:     jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: switchdev: Fixed kerneldoc warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600781539-31676-1-git-send-email-tiantao6@hisilicon.com>
References: <1600781539-31676-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:30:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>
Date: Tue, 22 Sep 2020 21:32:19 +0800

> Update kernel-doc line comments to fix warnings reported by make W=1.
> net/switchdev/switchdev.c:413: warning: Function parameter or
> member 'extack' not described in 'call_switchdev_notifiers'
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Applied.
