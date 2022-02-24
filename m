Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8FA4C39DA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 00:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiBXXvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 18:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiBXXvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 18:51:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9EC294567;
        Thu, 24 Feb 2022 15:50:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF0A6B82A1F;
        Thu, 24 Feb 2022 23:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E8EC340E9;
        Thu, 24 Feb 2022 23:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645746633;
        bh=/R22wQvyMzwte2Vqe2Nqf1fgMov7Hgz6rWLBAX3GlW0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U9o0db8t6TsUIOvX4rBO2ho4uCsAQPzUlwQHITccDbdp5hV5zoC0sTpDt+W3rEf5/
         L1CjJkpssWhk6jbRAv4e3nk7Y42vas80vN5qAYMQKW/8SQ9JrqH7QgKMjmNAPjQoQM
         HGJgs+ncgba8sv58MgeVPLoHa4pyJV0dco/nlMjy7LT1oHaWYcTTQSLFYfr9QnB5K8
         IuxU9MfJKEVzqcgA6F0x2QEqnVSavkY5Nkwmk0Sjoc3dUBd/aCn5VU5YwCVyC5IG+E
         d23oIT5YkY51XLMeBwB7AisLe++ACKRI3UtxlH97yojo9xKPpdxPVAsVbp9SVNaPFF
         6lt/GlgcRliWA==
Date:   Thu, 24 Feb 2022 17:58:32 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 2/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_start_scan_cmd
Message-ID: <20220224235832.GA1312501@embeddedor>
References: <cover.1645736204.git.gustavoars@kernel.org>
 <8b33c6d86a6bd40b5688cf118b4b35850db8d8c7.1645736204.git.gustavoars@kernel.org>
 <b6cd3d69-12a4-693a-e48f-d769c79fc455@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6cd3d69-12a4-693a-e48f-d769c79fc455@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 03:35:07PM -0800, Jeff Johnson wrote:

[..]

> 
> my e-mail client hung while reviewing v1, so now giving
> 
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Thanks, Jeff.

--
Gustavo
