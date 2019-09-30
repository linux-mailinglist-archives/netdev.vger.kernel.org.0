Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2D4EC22EF
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbfI3ONT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:13:19 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57782 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731568AbfI3ONT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 10:13:19 -0400
Received: from zn.tnic (p200300EC2F058B00329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:8b00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6345A1EC02FE;
        Mon, 30 Sep 2019 16:13:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1569852797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:references;
        bh=hkBLrVZPCLlHDWZRi2BXjNwr3LBr9SGsHda/66Mx2z0=;
        b=PUAgYqWWNaZwRk75UDA9q6AiU3I1NoIg/uFLdU29stwYK52XuJXLSXcP0nFWW9Y96tyJ9+
        Zw109GmBdC3nmE+ne+Izpac4wKUXS3lMtdbT3m30cydlnhTXFIfqUKcBM6ZnAk9dQOTIZ3
        Q6DvfWab0Ke8aWuKeIsgvHIZ4aBFnaA=
Date:   Mon, 30 Sep 2019 16:13:17 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     linux-rdma@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: ERROR: "__umoddi3"
 [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
Message-ID: <20190930141316.GG29694@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

JFYI,

I'm seeing this on i386 allyesconfig builds of current Linus master:

ERROR: "__umoddi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
