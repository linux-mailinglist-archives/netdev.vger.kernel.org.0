Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D181F6E12
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgFKTnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgFKTnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:43:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB36C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:43:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8A2C12865786;
        Thu, 11 Jun 2020 12:43:41 -0700 (PDT)
Date:   Thu, 11 Jun 2020 12:43:40 -0700 (PDT)
Message-Id: <20200611.124340.2260398343202867717.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: remove support for mgmt device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611040739.4109-1-snelson@pensando.io>
References: <20200611040739.4109-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 12:43:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 10 Jun 2020 21:07:39 -0700

> We no longer support the mgmt device in the ionic driver,
> so remove the device id and related code.
> 
> Fixes: b3f064e9746d ("ionic: add support for device id 0x1004")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thank you.
