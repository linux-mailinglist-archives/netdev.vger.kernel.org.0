Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F128059BB01
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiHVIHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbiHVIHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B094E13EA1
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CADA60C71
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388B3C433C1;
        Mon, 22 Aug 2022 08:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661155614;
        bh=co9c2wzgKFI7Q56Msro0lNuwwrRocJQeAH6GvRnkKhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GVtC2juMkWOZWhmVNLuGmo6WVKleejg2BLpBA8lHKX3ahiWosHYC7gzLmmNMrCCnl
         mnDLEp5/lOHix9XR9WryFjdRGsM0hWFFfjZx4/n00e0nI1UeVOY+RhMANWKr6x/GZO
         rI0VFolljgaSQCQ+7b9B2wvaBDyyd65AdSyw763rG+0SE5m+8jgHshlioSXlrNMF2K
         7z0HNtqT00crRRVehLe6/UAf7qidryXj5qVp4SfoGwz6NaEYHCWg6MJFVCGM8b8Y1b
         4NfwcFjjRZiv/Xd3tusf8acY3YM8gdz6r1cj3pooMh7maXCbW0RtpS+pxsgm40zlCF
         W9IPMhrThOjNg==
Date:   Mon, 22 Aug 2022 10:06:41 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ptikhomirov@virtuozzo.com,
        alexander.mikhalitsyn@virtuozzo.com, avagin@google.com,
        mark.d.gray@redhat.com, i.maximets@ovn.org, aconole@redhat.com
Subject: Re: [PATCH net-next v2 1/3] openvswitch: allow specifying ifindex of
 new interfaces
Message-ID: <20220822080641.k4c2sxxhd57rbkd4@wittgenstein>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
 <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 06:30:42PM +0300, Andrey Zhadchenko wrote:
> CRIU is preserving ifindexes of net devices after restoration. However,
> current Open vSwitch API does not allow to target ifindex, so we cannot
> correctly restore OVS configuration.
> 
> Use ovs_header->dp_ifindex during OVS_DP_CMD_NEW as desired ifindex.
> Use OVS_VPORT_ATTR_IFINDEX during OVS_VPORT_CMD_NEW to specify new netdev
> ifindex.
> 
> Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> ---

Looks good to me,
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
