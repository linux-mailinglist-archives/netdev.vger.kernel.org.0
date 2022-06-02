Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCBD53BD9A
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 19:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbiFBRyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 13:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiFBRyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 13:54:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C8B2B07CD;
        Thu,  2 Jun 2022 10:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9614DB820E4;
        Thu,  2 Jun 2022 17:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AF7C385A5;
        Thu,  2 Jun 2022 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654192455;
        bh=iuNz+r+pm8n9GIagL4R4dB3NTvRvPg2fwpYvcVveqbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UHLyPtqNqBQgGs8GLeho7JBM0Y2Z7ouhZsFVEBs2n9PI2Wx9lrph7nLQiHK0K4QMP
         PpQUQlvac0KpyVsVypLBqDjLTPL7qenPLjsmw31I0LSmcZxI7WjYWEsUSzk5ph4JUY
         s4pDjvNpyg4QmAJvo19cOiIphoutOgmL0ozdSdS6WGFZHRgKM5xxrzsBC0dj3MVFLd
         ISU5LRWGNs81rcBlCBbVXZ+aOm3ly9/aUzkjakI5/5TvIueeqlybvzqADhLl2yZRpG
         Fwik3nuaqaZ7PI8icrxpO12I7Hmf6XUn0lol7USmyIRt1PTyGQbgrHpv+F5z0TM0G3
         p2dgNmI3/qdOQ==
Date:   Thu, 2 Jun 2022 10:54:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Varshini Elangovan <varshini.elangovan@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8188eu: Add queue_index to xdp_rxq_info
Message-ID: <20220602105413.437d33d9@kernel.org>
In-Reply-To: <20220602173657.36252-1-varshini.elangovan@gmail.com>
References: <20220602173657.36252-1-varshini.elangovan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jun 2022 23:06:57 +0530 Varshini Elangovan wrote:
> Subject: [PATCH] staging: r8188eu: Add queue_index to xdp_rxq_info

For a second there I thought we had a wifi driver with XDP support 
in staging :/
