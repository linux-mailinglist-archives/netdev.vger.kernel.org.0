Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E5E5432BF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 16:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241502AbiFHOiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 10:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241514AbiFHOiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 10:38:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EB011AFC9;
        Wed,  8 Jun 2022 07:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF25561B95;
        Wed,  8 Jun 2022 14:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA51C3411D;
        Wed,  8 Jun 2022 14:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654699081;
        bh=yg65op50jEfe1uvoE3ef1f8/+OCHJwqBHX0y2nkfKOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O7rtdIyOEXChcrWFTliXcWJGWSmm4qBxuInnTMceX6N9L0ijzirbRm/joaB6RqzJd
         ZtFYAjiKuOAv8ogi6yh0H8iBA9Dy1kRu/tBw7Wc58PaOTiKwh75H5KtzgOMyb2BKp8
         pJjJpZkGvOfLS1bbZ/27DbpBnyVPhAVtzE/SeuiJO9tG7pbbnm/lisRF7fQ6/fiQe3
         xAISvMt6dgsn90j+Xk06ZZ2kfRyuE9Q2PUmfLoFCWjs0erHq2ZdIqsX19eiKrNHlYk
         2V0sh4LsaB4lFru22OoRd6xsW+YIV1DtAcXmWjvSBWCbuxc48O1y/CytuAwcRIw74D
         jNiJsVKcEXkcA==
Date:   Wed, 8 Jun 2022 07:38:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf] MAINTAINERS: Add a maintainer for bpftool
Message-ID: <20220608073800.5185b78c@kernel.org>
In-Reply-To: <20220608121428.69708-1-quentin@isovalent.com>
References: <20220608121428.69708-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jun 2022 13:14:28 +0100 Quentin Monnet wrote:
> I've been contributing and reviewing patches for bpftool for some time,
> and I'm taking care of its external mirror. On Alexei, KP, and Daniel's
> suggestion, I would like to step forwards and become a maintainer for
> the tool. This patch adds a dedicated entry to MAINTAINERS.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Long overdue! :)
