Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51076EE51E
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbjDYP66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbjDYP65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:58:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E596CC17
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 08:58:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6F262782
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 15:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AB3C433D2;
        Tue, 25 Apr 2023 15:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682438335;
        bh=h8KUYnSv92iCBy4+FyUehDhK7mgE+oJ7hVX2uh4s+v4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WXWpe0ecGxn/IO6+0jaR0bSjg3mk0/i0g7lQXUvoOQmlJYRbDoa47h4a2nOimT5w1
         b19Hgja084SmpY3SLbczYdkV1WAAh4kNQRwM7s5Dirnic/QPBquOEWAi4DG0HprhKr
         YIUBXCv0J3tcvyNz//G7OZPJYXZ2WGdavH6TfTrLcNhT+hB82StyjUcjcpDQ4O+aTT
         geMQUUTcqLrMNFTbJ/56KDFdwnPuFziVDJ5cFTtQ2/PUOW4xkGBlkLVGofy3xk/lWw
         6sEWBOjpVGtvJmGwupSvldT4IZIraAN36v7PvGd7dNa0wBuUh9hQ7n4wOvOOxMx5sx
         iZIsDo1FBIuzw==
Date:   Tue, 25 Apr 2023 08:58:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v4 3/5] Add ndo_hwtstamp_get/set support to
 vlan/maxvlan code path
Message-ID: <20230425085854.1520d220@kernel.org>
In-Reply-To: <20230423032835.285406-1-glipus@gmail.com>
References: <20230423032835.285406-1-glipus@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 22 Apr 2023 21:28:35 -0600 Maxim Georgiev wrote:
> -		if (!net_eq(dev_net(dev), &init_net))
> -			break;

Did we agree that the net namespace check is no longer needed?
I don't see it anywhere after the changes.
