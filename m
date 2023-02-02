Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F395B6877C6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjBBIqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBBIqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:46:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954FE86613
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 00:46:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE3061A27
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 08:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27803C433D2;
        Thu,  2 Feb 2023 08:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675327601;
        bh=jfE/ej7TVMEwkfa2/ThlszqLjPC9r6H4LeMVWvGJrAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOvyZaF+zUPYwi6vzEIM0KGaKbD716B4eWY7AV04Av+8dUW9YfW2RfER+T1KpCWHx
         8DHgRjoWPugssoHLwW8sQ30LWmwGy/XFA9+50jomgoXNaLJKSAkSxkNlbCStIEjsVn
         6p8/e0YuF0Uyuuz1IYYuhlbc25LgThCeg0aFIGgUnb4tJ1igqC3OvzbfRrgMWnbSJp
         ay91wTq2GzubFpVUTssFQoHEtgOx8MPlFai6Ce4SuFiCKyHRBMkk9frhtaD2hP2sCM
         nJNAyF0qwgEalhysPDCIcYLaSqkkgYXrrdzAX3jnuZwjakf5A/8ORDr+OglFAwtoQw
         XBOJoNGIwvMwg==
Date:   Thu, 2 Feb 2023 10:46:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net 5/6] ionic: clear up notifyq alloc commentary
Message-ID: <Y9t4bc67PAHRB7nD@unreal>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
 <20230202013002.34358-6-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202013002.34358-6-shannon.nelson@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 05:30:01PM -0800, Shannon Nelson wrote:
> Make sure the q+cq alloc for NotifyQ is clearly documented
> and don't bother with unnecessary local variables.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
