Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE24D65C8
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349439AbiCKQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350161AbiCKQIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:08:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F8B48395
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 074FDB82C1E
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EE7C340E9;
        Fri, 11 Mar 2022 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647014864;
        bh=V6WWl4owCmZHZjQrT7Pyoh5iaaRxNMr60EuNfGBB4QU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gP7S2ajdHg2ZtRQ42E2SdWq1ziw5r3t70AM1zt+FzR6bzcbWfqafUT+YDlpbOlQA2
         YfKa6fVJDHwxC9P12CP3UCVbWJiUEJP+pRYqCxSAk2YtWp3+XfwrRxH+9oD9aTDHO2
         RlQ0D194OC1Z9eLxVBoLbFu95Z7gNbfputgOQia22db6VlNDRYfpEZ7fciM1M14F1M
         pYq0xdtqsh4Xx42T2o+M+K4zZzmKiskWYLMRBtmTYT5spFCdTvWGpSpTpY/SGNVQIK
         mBsZl52EWEHvd5kKQ79DhkyRn6kn98+4Y7VtLEV3F18W8iYJg71rfsf0GWD+haAFsE
         SCUd8H200XwqQ==
Date:   Fri, 11 Mar 2022 08:07:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <20220311080743.50447d96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220311080631.7e679bea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1646928340.git.petrm@nvidia.com>
        <288b325ace94f327b3d3149e2ee61c3d43cf6870.1646928340.git.petrm@nvidia.com>
        <20220310211301.477e323c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87y21g96de.fsf@nvidia.com>
        <20220311080631.7e679bea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 08:06:31 -0800 Jakub Kicinski wrote:
> I'm okay with your version if you prefer, but the above works, right?
> Or am I missing something?

Ah, you only have one fops now, I should have read the patch more
carefully. Yup, that's also good.
