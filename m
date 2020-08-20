Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D13824C823
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgHTXBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbgHTXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:01:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEAAC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:01:33 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F6291286B97D;
        Thu, 20 Aug 2020 15:44:46 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:01:30 -0700 (PDT)
Message-Id: <20200820.160130.1637547830663890627.davem@davemloft.net>
To:     simon.horman@netronome.com
Cc:     kuba@kernel.org, louis.peens@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/2] nfp: flower: add support for QinQ matching
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820143938.21199-1-simon.horman@netronome.com>
References: <20200820143938.21199-1-simon.horman@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 15:44:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <simon.horman@netronome.com>
Date: Thu, 20 Aug 2020 16:39:36 +0200

> Louis says:
> 
> Add new feature to the Netronome flower driver to enable QinQ offload.
> This needed a bit of gymnastics in order to not break compatibility with
> older firmware as the flow key sent to the firmware had to be updated
> in order to make space for the extra field.

I'll apply this series, thanks Simon.

