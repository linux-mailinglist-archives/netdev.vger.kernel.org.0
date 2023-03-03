Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA426AA5F4
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 00:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCCXym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 18:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjCCXyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 18:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E055311C8;
        Fri,  3 Mar 2023 15:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17306B818AB;
        Fri,  3 Mar 2023 23:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56601C433EF;
        Fri,  3 Mar 2023 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677887677;
        bh=UluNXG14RmoSr4RS2NwksI5uEbS0WIkcjnPGlHH87+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpuqBrm+SBya6yNB7B9+YBgLNEnMLSA2Q3RDHWybx2BjOdG8IyVaTO/944N3Kcke1
         ZMHnoLDm/YSrW2/4zdh2tiAm7gZmZgbrK6GZhVLrG53OKSHE6GUb5Vm6OLCp+RtS3v
         gRqvUix+IAkf/L/2cc/paxuVMDmjCsPeFXGuoYJV0pCXN2r7NMtaYYAdxV+AszlV+/
         dQWW1qX7dbAua88mabzdmyfoEO/SNruSBsMZvVFxeej3Bi8Dcm9U8W2XWbLaxfzw9A
         il7HMV7I0V03Ga8OmzPaUXlohYBgUEPKel3pWRXenWUuyJtI8hfBpQiz1nKaIQiJLR
         AymieGps/KoHA==
Date:   Fri, 3 Mar 2023 15:54:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Message-ID: <20230303155436.213ee2c0@kernel.org>
In-Reply-To: <20230303185351.2825900-1-usama.anjum@collabora.com>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Mar 2023 23:53:50 +0500 Muhammad Usama Anjum wrote:
> make versioncheck reports the following:
> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
> 
> So remove linux/version.h from both of these files. Also remove
> linux/compiler.h while at it as it is also not being used.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
