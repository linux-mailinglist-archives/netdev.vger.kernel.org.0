Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67926ED99B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjDYBJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjDYBJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF79FB44C;
        Mon, 24 Apr 2023 18:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AB8262AAC;
        Tue, 25 Apr 2023 01:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC51FC433EF;
        Tue, 25 Apr 2023 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682384930;
        bh=CT2LSQNb2gddFkjthp/YjGrhYjM2M7RiTr5ZTdmzDxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PM7weR8HTlAZEaZwFDxf2HjgFD3dO7zdAoyWjWY/HE7emwux6NCTkCvQ/Vr0XKNIA
         4rBEFATmyVowVrSARD7bImMK+WKHLzWb6beiKSSd/ZjL0hI9cfOzcoGAF5quJ8ghIZ
         1A4IT2Bw++tcvSrsAaEPS3XCeRgbs9YFhZLGbd/HrZ0D438W53GJzHoF2d0VtMlaHL
         XPyK7M3Kswthop/SUHznHfJxEVWAabtMqXeFv5xHnrR1KF2MuMQvL0vDBRlvQyJK7Y
         kAGNfgmFYOb+6PwrYOmsnGVDFLXWeaJUZoWl8aP16rrptQelv06iX5pvpHofFxHoqo
         NWURbnag5m4jg==
Date:   Mon, 24 Apr 2023 18:08:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next, 0/2] Update coding style and check alloc_frag
Message-ID: <20230424180848.21d0109d@kernel.org>
In-Reply-To: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
References: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 10:06:56 -0700 Haiyang Zhang wrote:
> Follow up patches for the jumbo frame support.
> 
> As suggested by Jakub Kicinski, update coding style, and check napi_alloc_frag
> for possible fallback to single pages.

Thanks for following up!
