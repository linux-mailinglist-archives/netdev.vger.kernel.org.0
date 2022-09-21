Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9715E56C6
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 01:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiIUXeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 19:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIUXd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 19:33:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD373A5994
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 16:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A004B8336D
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED3DC433C1;
        Wed, 21 Sep 2022 23:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663803235;
        bh=u2NcIKhFr8oj2Qd4VsahMY7L9yUeYyRaF7iROF5NFnY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B9RnPwM3SiRwLMj0LHs+4xcSPBIV0bCjC1hSEsX1Ni6QtzEv7RhRC0Jv6rsIL78w3
         ECHJCZ+wHuanXySZm/upFKUknGXg5H4G8yporaemkul6LmPq18sASRp4fgIjfWn9rO
         XbxFZmPM6C8+yWwONatd+YsnkmkecDPXSEWNKnlNOpEEsXqVm42qRah9YPbSJItPTD
         p3ToCX7j4KOHb0bxByxFLs94Bc+nc4ODAeHTfiIxo/gUoLXPxlPakzLFKfxYWUuDiA
         9j+w9etWZOitL/m0K2XWqLx+0mJ8hxU51xWSite138J0LoV+rEcCvGs5SfvmGS5wPD
         Lz1BYUks2luFg==
Date:   Wed, 21 Sep 2022 16:33:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api
 with queues and new parameters
Message-ID: <20220921163354.47ca3c64@kernel.org>
In-Reply-To: <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
        <20220915134239.1935604-3-michal.wilczynski@intel.com>
        <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
        <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
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

On Thu, 15 Sep 2022 20:41:52 +0200 Wilczynski, Michal wrote:
> In our use case we are trying to find a way to expose hardware Tx 
> scheduler tree that is defined per port to user. Obviously if the
> tree is defined per physical port, all the scheduling nodes will
> reside on the same tree.

Can you give some examples of what the resulting hierarchy would look
like?
