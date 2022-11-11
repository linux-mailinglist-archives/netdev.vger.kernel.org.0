Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD606264A0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiKKW0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKW0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:26:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FC463CD5;
        Fri, 11 Nov 2022 14:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8BE5B8281C;
        Fri, 11 Nov 2022 22:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA62C433C1;
        Fri, 11 Nov 2022 22:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668205588;
        bh=gB+JR53Qbi6x9kZrSlWBYD02pwyrIxUOBq7c0/uhxg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rE1yL2X1561I97vOYrIe3/sEsE2BULSun/2xXoVIiiDD3NtsxHQWmT3xJ0UjCFILt
         XG/PCGAHw9tYT8T2SVgr2oVK/zhZxXRzkxmib51i4LisStjXx1K0kwkYKwagEGtcuQ
         MyB4DA/CaN2/S41wz1JOAOy9StvkxJOxbmTj1BduDZ+ZPbPosEM/v7WpHgj87U+M7V
         cdK/RuIHzMm5piykA6Hp6rb9jUtyax4KHthVZRBpFM92pc+Lk2WhLwJ6iWQIQsuq0d
         zFTM3nXitsDXbCzj6yipZjNxOmTLKRtv+NlztrT9n6/2hzrDA6OKHepGfTrL0Tllvr
         9fCgLPnIUCSpA==
Date:   Fri, 11 Nov 2022 14:26:27 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Anisse Astier <anisse@astier.eu>
Cc:     netdev@vger.kernel.org, Anisse Astier <an.astier@criteo.com>,
        Erwan Velu <e.velu@criteo.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: remove unused list in arfs
Message-ID: <Y27ME7bL3Tw1BvF+@x130.lan>
References: <20221031165604.1771965-1-anisse@astier.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221031165604.1771965-1-anisse@astier.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31 Oct 17:56, Anisse Astier wrote:
>This is never used, and probably something that was intended to be used
>before per-protocol hash tables were chosen instead.
>
applied to net-next-mlx5, thank you!

