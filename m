Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8FB217813
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGGTlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGTlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:41:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FE1C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:41:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85EC9120F19D5;
        Tue,  7 Jul 2020 12:41:12 -0700 (PDT)
Date:   Tue, 07 Jul 2020 12:41:11 -0700 (PDT)
Message-Id: <20200707.124111.860515058679393159.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ice: add documentation for device-caps region
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706215341.1354720-1-jacob.e.keller@intel.com>
References: <20200706215341.1354720-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 12:41:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Mon,  6 Jul 2020 14:53:41 -0700

> The recent change by commit 8d7aab3515fa ("ice: implement snapshot for
> device capabilities") to implement the device-caps region for the ice
> driver forgot to document it.
> 
> Add documentation to the ice devlink documentation file describing the
> new region and add some sample output to the shell commands provided as
> an example.
> 
> Fixes: 8d7aab3515fa ("ice: implement snapshot for device capabilities")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied.
