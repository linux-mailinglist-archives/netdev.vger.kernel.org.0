Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0DF64C45A
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 08:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiLNHWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 02:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiLNHWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 02:22:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B6714D19;
        Tue, 13 Dec 2022 23:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E4F5B81619;
        Wed, 14 Dec 2022 07:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40048C433D2;
        Wed, 14 Dec 2022 07:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671002537;
        bh=48GqGmbbMjxf6Q6um0LMW66Yba8Lyd9HBbxBxv4GInE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JKHdadIsebQU85kcM8OKKKjwRC2K7GRQ+zQb1WQgrNiCa1VBHlEVSIIPI9tzJpR/w
         hLiOTKpsS+GAdPWirAcA594kso60N39a71p7xgygxlA04KXaAsVohjeokTpr3S6FuI
         OkFicXLMdRqYgHodF9Y2Lc1vNmqVoGhGevSPvzQE//rbY7TviXeHtd+UF/r/kNqYS7
         M/AN0OuzZyJiu8GzvP9kgpr6nx5P4Voc6PLgvNp1pF52jphtuq7x+T1fH8G/fMqn80
         ZO7oMCiPnIEC/Q2quO1IMo0lBr0Ogtp33g2efe749qFrJae8R/SbEtKwH0iG9Xw+JZ
         LzUSN+iUAIQYA==
Date:   Wed, 14 Dec 2022 09:22:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lixue Liang <lianglixuehao@126.com>
Cc:     anthony.l.nguyen@intel.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, jesse.brandeburg@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, lianglixue@greatwall.com.cn,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <Y5l5pUKBW9DvHJAW@unreal>
References: <20221213074726.51756-1-lianglixuehao@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213074726.51756-1-lianglixuehao@126.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 13, 2022 at 07:47:26AM +0000, Lixue Liang wrote:
> From: Lixue Liang <lianglixue@greatwall.com.cn>
> 
> Add the module parameter "allow_invalid_mac_address" to control the
> behavior. When set to true, a random MAC address is assigned, and the
> driver can be loaded, allowing the user to correct the invalid MAC address.
> 
> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>


I'm amused that we are in v7 version of module parameter.

NAK to any module driver parameter. If it is applicable to all drivers,
please find a way to configure it to more user-friendly. If it is not,
try to do the same as other drivers do.

Thanks
