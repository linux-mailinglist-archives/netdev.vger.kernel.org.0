Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC8481EAB
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbhL3Rnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhL3Rn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:43:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9D3C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 09:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47B1E61710
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 17:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1E1C36AE7;
        Thu, 30 Dec 2021 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640886208;
        bh=0UTH7Khp+VY00Lf2AIxPNp30Hher7GGpnu9jWmTGLtU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W9Y/mM/hmm/LvjDoXvoeakBACPnkmgj0VMhsQyK7TfrIXnE3RbvPfOkJRDqvYKhQ5
         QiPhgo8biLgcmLgLyOtzaWbtrQasj06R8HuoGEZiefyMR7nVdDbWC0Whq6aCwJ69wr
         gohGih6NrPRtw4pqypyrGMhISrpAy9BwDMfg+yI9qPPmFEu4Qdet2kOIrFwDYfMx2I
         Ga3Ood4xPGv3DhZ9k0a5VbIzpfCTFHcMCoSMyUj5megm2nWIDbWsXh/DZi3lGH1X3Y
         +Y6q21zMjZb6+0leBJvuAETWe9F3njQMHlQmt9YZX3IUpW+lMusj+q9YCjxhZu/JBf
         MskQP8o+cFLOQ==
Date:   Thu, 30 Dec 2021 09:43:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and
 MAINTAINERS
Message-ID: <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230163909.160269-9-dmichail@fungible.com>
References: <20211230163909.160269-1-dmichail@fungible.com>
        <20211230163909.160269-9-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Dec 2021 08:39:09 -0800 Dimitris Michailidis wrote:
> Hook up the new driver to configuration and build.
> 
> Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>

New drivers must build cleanly with W=1 C=1. This one doesn't build at all:

drivers/net/ethernet/fungible/funeth/funeth.h:10:10: fatal error: fun_dev.h: No such file or directory
   10 | #include "fun_dev.h"
      |          ^~~~~~~~~~~


