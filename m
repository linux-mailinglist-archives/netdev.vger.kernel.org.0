Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3773E50E4F9
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbiDYQDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbiDYQDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:03:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1D9E00C
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A69CB818B0
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 16:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E85C385A7;
        Mon, 25 Apr 2022 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650902423;
        bh=s696nV7KipsAmrhW9rB3td2CxEocQLb8L28UfYRpRXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I9UBIry4rzTF9qCA//ig97Ok+LLokrdGzuNx7ghDWtJ+20+EVMW6ILZvlE7Am8X6a
         vYBjY+vz2mFHfhnm01kcMwGRaNbN3bzAjXo22lNTyuQ+mz+d/NlV0iRAT+zeZ+lNFs
         IXGGBhP/kuK9Auhp7gSE3p3Ie9onalEiOFEmHuiFLCSl5LdWq9LoUOzOEQY7lgnjgH
         nZ1Hh0eDIc0CNptsy3qfIX0WWUIrLTRwhv54rcQnwe+YZKWX8JI4rHd0OOOiY24wlU
         IGdPcr+3wv0Q1WrJn9jwrjyHunEnzfyKiQY4aOQxSjRhUU+BS+AbfSFB9NnK+qE0hc
         AeBPY6avSe4Og==
Date:   Mon, 25 Apr 2022 09:00:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220425090021.32e9a98f@kernel.org>
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022 06:44:20 +0300 Ido Schimmel wrote:
> This patchset is extending the line card model by three items:
> 1) line card devices
> 2) line card info
> 3) line card device info
> 
> First three patches are introducing the necessary changes in devlink
> core.
> 
> Then, all three extensions are implemented in mlxsw alongside with
> selftest.

:/ what is a line card device? You must provide document what you're
doing, this:

 .../networking/devlink/devlink-linecard.rst   |   4 +

is not enough.

How many operations and attributes are you going to copy&paste?

Is linking devlink instances into a hierarchy a better approach?

Would you mind if I revert this? I don't understand why the line card
patches are applied in 6h on Sunday night, especially that RFCv1 had
quite a long discussion. But really any uAPI additions should warrant
longer review time, IMHO.
