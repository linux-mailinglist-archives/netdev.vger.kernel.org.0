Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B159C68A1F3
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjBCSZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 13:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjBCSZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 13:25:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C31991FE;
        Fri,  3 Feb 2023 10:25:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D901BB82B94;
        Fri,  3 Feb 2023 18:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E2ACC433EF;
        Fri,  3 Feb 2023 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675448711;
        bh=iLCeDEnG6v2VN1K+S+am3JCPFgQk+pz3savoj+MwTPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uz2AYOw8otKl46a75+msQkohif2TBlbRljxekVGJRjNtckJorFaSNDtbly6kGtDPg
         UmnqQaryIzDVB41FohZYZjZHSSAwGwnW4X+msKQcicsPpHAM6rwll4ZPaCPEurozUc
         q/KsuR4IaQJDF2NY7flT0CqLeB35bNiPhvO/D/TYeRznGlTbaop2MJe8movDKL4krk
         8vPxrN8MIPahtPg0wqRtbSDhlXHCm7eX4gH9zTD5tJRi9aM2fjOfJPbUmU/1ZHxadL
         IeSS8KDxjXQWfsY5oj2DjnhE3E7tzDpK9+BEgRZODzHe+9ULF6fR8ozmp9b9Ni7/R6
         H9RSqtyEAAyhg==
Date:   Fri, 3 Feb 2023 10:25:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lucy Mielke <mielkesteven@icloud.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: eni: replace DPRINTK macro with pr_debug()
Message-ID: <20230203102510.29b9dd7f@kernel.org>
In-Reply-To: <00f95478-c9cc-1f4b-820e-d427a9113418@icloud.com>
References: <00f95478-c9cc-1f4b-820e-d427a9113418@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 14:00:41 +0100 Lucy Mielke wrote:
> If this is still desireable and relevant, I will continue with the rest
> of the source files.

I don't think it is. This code is waiting until its safe to delete it.
