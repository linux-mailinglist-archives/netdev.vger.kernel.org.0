Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EA5226241
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgGTOgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgGTOgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:36:36 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C64C061794;
        Mon, 20 Jul 2020 07:36:36 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 33B99453;
        Mon, 20 Jul 2020 14:36:36 +0000 (UTC)
Date:   Mon, 20 Jul 2020 08:36:35 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
Message-ID: <20200720083635.3e7880ce@lwn.net>
In-Reply-To: <20200720140716.GB1080481@unreal>
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
        <20200720045626.GF127306@unreal>
        <20200720075848.26bc3dfe@lwn.net>
        <20200720140716.GB1080481@unreal>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:07:16 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> > Do *you* want to review that megapatch?  The number of issues that have
> > come up make it clear that these patches do, indeed, need review...  
> 
> Can you point me to the issues?
> What can go wrong with such a simple replacement?

Some bits of the conversation:

  https://lore.kernel.org/lkml/20200626110219.7ae21265@lwn.net/
  https://lore.kernel.org/lkml/20200626110706.7b5d4a38@lwn.net/
  https://lore.kernel.org/lkml/20200705142506.1f26a7e0@lwn.net/
  https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
  https://lore.kernel.org/lkml/202007081531.085533FC5@keescook/

etc.

jon
