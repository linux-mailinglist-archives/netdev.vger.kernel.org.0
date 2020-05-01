Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B871C209F
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgEAWah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgEAWah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:30:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F10BC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:30:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4960314F4DE50;
        Fri,  1 May 2020 15:30:37 -0700 (PDT)
Date:   Fri, 01 May 2020 15:30:36 -0700 (PDT)
Message-Id: <20200501.153036.455002368363033160.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        kubakici@wp.pl, benjamin.l.fisher@intel.com
Subject: Re: [net] ice: cleanup language in ice.rst for fw.app
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429205950.1906223-1-jacob.e.keller@intel.com>
References: <20200429205950.1906223-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:30:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Wed, 29 Apr 2020 13:59:50 -0700

> The documentation for the ice driver around "fw.app" has a spelling
> mistake in variation. Additionally, the language of "shall have a unique
> name" sounds like a requirement. Reword this to read more like
> a description or property.
> 
> Reported-by: Benjamin Fisher <benjamin.l.fisher@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied, thanks.
