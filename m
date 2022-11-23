Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45053634F26
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbiKWEop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiKWEon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:44:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCD6CC16D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:44:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 615FBB81E5F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A09C433C1;
        Wed, 23 Nov 2022 04:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669178680;
        bh=MfZJsE47JJmDI4fIiV0Yob+/YDyL7j8RtVKhdMjGnbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SpanO7bzhf/fgM15yZLuH3tMnI7k7hnnUwhyNx2+l2tSn7G9+DV9jbUsOo/O0k5EU
         3ilWbolfwEsDUVNhNAiZSJnhxf+SaQjMlKxa5rgnF8FZAoj4DJuE0u30fmeW8NC0zv
         ANEiVVOUu6tZrcsKwFJH/nCJXY5WIVRTu9DprDHCWNYUm4Qd2Ju60OwoUgBRnctk/8
         yn+Pd3whQqh+dduJd4mQBbxr+/PWI/IJB9YPq695dMX4i1KDesr+E7SObtdpUCPGmN
         t02AIxQITeKcen/+p6po3Lrrm3JpNIOJxr1JPlEd+WLyFcv9T6v/sbr4fB/QqafQpJ
         dZSg5Ji2DbIKA==
Date:   Tue, 22 Nov 2022 20:44:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Tronchin <davide.tronchin.94@gmail.com>
Cc:     bjorn@mork.no, netdev@vger.kernel.org, marco.demarco@posteo.net
Subject: Re: [PATCH] net: usb: cdc_ether: add u-blox 0x1343 composition
Message-ID: <20221122204438.25442c0c@kernel.org>
In-Reply-To: <20221121140903.68843-1-davide.tronchin.94@gmail.com>
References: <20221121140903.68843-1-davide.tronchin.94@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Nov 2022 15:09:03 +0100 Davide Tronchin wrote:
> If 4: CDC-ECM interface
> ---

We need your Signed-off-by tag in between those two lines.
