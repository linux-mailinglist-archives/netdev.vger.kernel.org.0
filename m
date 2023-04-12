Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8BC6DF897
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjDLOeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjDLOeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:34:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD1176A6;
        Wed, 12 Apr 2023 07:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A36D62D62;
        Wed, 12 Apr 2023 14:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86329C433D2;
        Wed, 12 Apr 2023 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681310047;
        bh=S65Xlm1hN6CYrLBcE2DMKmo6xG37aMTKFhLPmZYoUd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J8C8cu4w5m8bhYIFV3aa2elYLWYyGgFJDRyP89gDm9u83ydwJiSecHPWNsBe1IRTm
         3SE14NZF6WvM4lydHt0chYJOygyWE1/vPlfRU2/cZsaEajZaJdqGvauqyHweGFXMEU
         9SI5xRQf8XlE7VHEe1s4GyPGJnBijw/Y9926zaj/7rPz5OtfHGZfboXyn+eGs1g4KE
         iucofs4HLo/9+14DPItgvfcxITqhhIIFpiMH4LD/5QAW6htMT4qtAOd3Tl5HP6vDjj
         KG5e/yD7NlanyRYYVq/cDur6Ru+yFCHQwVDEeQzZrB+/5yvjJSppJeHjnht9i0RGff
         MuNGjN+eTGQAA==
Date:   Wed, 12 Apr 2023 07:34:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     ivecera@redhat.com, netdev@vger.kernel.org, mschmidt@redhat.com,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] bnxt_en: Allow to set switchdev mode
 without existing VFs
Message-ID: <20230412073406.73b60a9c@kernel.org>
In-Reply-To: <CADFzAK-ym-LH_suYgHn+wZvh2NGHmiGvRrRxNSa8CbXP=edS9g@mail.gmail.com>
References: <20230411120443.126055-1-ivecera@redhat.com>
        <CACKFLimBqwsX3tsnUp9svqSJHx57XEAu3kQ8Hj1Pq0+QS1uGsg@mail.gmail.com>
        <CADFzAK-ym-LH_suYgHn+wZvh2NGHmiGvRrRxNSa8CbXP=edS9g@mail.gmail.com>
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

On Tue, 11 Apr 2023 23:17:55 +0530 Venkat Duvvuru wrote:
> Acked-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>

Michael, does this mean Broadcom is okay with the patch?

> This electronic communication and the information and any files transmitted 
> with it, or attached to it, are confidential and are intended solely for 
> the use of the individual or entity to whom it is addressed and may contain 
> information that is confidential, legally privileged, protected by privacy 
> laws, or otherwise restricted from disclosure to anyone else. If you are 
> not the intended recipient or the person responsible for delivering the 
> e-mail to the intended recipient, you are hereby notified that any use, 
> copying, distributing, dissemination, forwarding, printing, or copying of 
> this e-mail is strictly prohibited. If you received this e-mail in error, 
> please return the e-mail to the sender, delete it from your computer, and 
> destroy any printed copy of it.

You must remove this footer.
