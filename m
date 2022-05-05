Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531AA51C579
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382134AbiEEQ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiEEQ6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:58:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371D85BD2E;
        Thu,  5 May 2022 09:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA45CB82E0B;
        Thu,  5 May 2022 16:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35761C385A8;
        Thu,  5 May 2022 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651769676;
        bh=WFcN9uCuku+W6hl6ivbmd8b2MJhAZo7OV8Rl1CGkL2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dh2Z3lXGfdIdARN4snPQzZGkgmaFmvPZ1GE+B/RacRP6NdyTZ9xSdk8gChwsqRBnb
         UQSOFeziDRpfxzwGHh03EAHQ3OWj0b5c/9cA4qaMFPtMqwSj5uXaNujQCQEq+XurSY
         fOLj4aBrhbWYgRgOcZ2+/v80BfUywuABD6m3oTc39MWp+5pbJ5RQTk5BD80OOkPkX2
         lGVoEzxxM9g3t4lz8cD1tTlR9hH+e5QKI80KnSZXupPx2YjZQ63bZ32cYyJtHwoGev
         O9/Zbw7SO0efY0le3vkZxQHuV/5Qb9RcwoA32yajCQKynG1bxQaWGRgiW4CcFzAgPC
         W/SO05zIEyVhg==
Date:   Thu, 5 May 2022 09:54:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Carlos Fernandez <carlos.escuin@gmail.com>,
        carlos.fernandez@technica-enineering.de, davem@davemloft.net,
        edumazet@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Subject: Re: [PATCH] net: macsec: XPN Salt copied before passing offload
 context
Message-ID: <20220505095435.1a2d8af2@kernel.org>
In-Reply-To: <165175728541.217313.17093503108252590709@kwain>
References: <[PATCH] net/macsec copy salt to MACSec ctx for XPN>
        <20220505123803.17553-1-carlos.fernandez@technica-engineering.de>
        <165175728541.217313.17093503108252590709@kwain>
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

On Thu, 05 May 2022 15:28:05 +0200 Antoine Tenart wrote:
> (Note: please use "[PATCH net]" for fixes and "[PATCH net-next]" for
> improvements in the subject when submitting patches to the networking
> subsystem).

Plus the version of the patch, FWIW, so [PATCH net v2] would have been
appropriate here, I think.
