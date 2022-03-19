Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6F94DE5FC
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241927AbiCSEol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241916AbiCSEok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:44:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9126A2FE70;
        Fri, 18 Mar 2022 21:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3949AB82541;
        Sat, 19 Mar 2022 04:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5C4C340EC;
        Sat, 19 Mar 2022 04:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647664996;
        bh=R1WowPSirZfIAglWFtE0PFmlANmB1qcEBJSDl8RumPk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lyGcXEc2UU4wC42fBvcZusoS6ja6g15nHic8fTIv/hKYe5tKAXfw49UWGHwNbiTWs
         cNTOkhqfMFncpZWADkmdFUPfnHLH5K8k6CvV+M8eV2kyEjf9nSDQ+ESqsQNuHHzd8+
         MleFx17gZswQR6rMM7mPNJnfPpF+kDQkmj3z99xduIH8tg6JSm0xFZ4p0Naz92h8Ni
         ZxRSh3Hgh8WQqYNgYGSp8FZpWGC28GxMDZDrfNaaKoywmD/5Sivkl298Rp2HhT/zFH
         6VmXvyAla4qUcPpw/LXDEDvHSKwiIbK5yDO8NWQGMVRMo5JQ2jCLl6fMtyzMIeuX2V
         +V2QnKZbat+Bg==
Date:   Fri, 18 Mar 2022 21:43:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     <borisp@nvidia.com>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/2] net/tls: some optimizations for tls
Message-ID: <20220318214315.31278755@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1647658604.git.william.xuanziyang@huawei.com>
References: <cover.1647658604.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 11:13:34 +0800 Ziyang Xuan wrote:
> Do some small optimizations for tls, including jump instructions
> optimization, and judgement processes optimization.

Acked-by: Jakub Kicinski <kuba@kernel.org>
