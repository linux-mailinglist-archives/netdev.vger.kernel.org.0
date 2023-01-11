Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73566516E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbjAKCCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbjAKCCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:02:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C970A470
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 18:01:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2B18619B2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB16C433EF;
        Wed, 11 Jan 2023 02:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673402495;
        bh=Gy7DpCzyBMDZAwMzayBk4obFYNHuJ8QKeYdxCdr4QIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQFxX6spCKtOe8cQGaACEv/s1LGzKe3oVDwsyIhKKR6JyJKF7YfftT0c8tBZ4BDyy
         9yFk7/GrYEcLTAjKg5Ekdqs7GU27k8SHuA34zl0F1YGnPYU6OY96+UrivOpM/60Re2
         wbNikwH+sN5ACWJFfuq96IrPiCnRGQCPrpzg6N0UsHEzHhxcdsLOeD5VzRsVVHI2I7
         YfhZOJdxX9pVb6Fnb/40LQWEqk6YykiIVivATl6hIl4fVuhnj7tDqyvl3VqcdTGYqH
         Vz1+rTEOBaOPXEwPey+uO7jt2hmqswoJfoNQN2K9BCoF6LtFSf9QDhEMJuiY84azPE
         nP7SdvCPrrYmQ==
Date:   Tue, 10 Jan 2023 18:01:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net 00/16] mlx5 fixes 2023-01-09
Message-ID: <20230110180133.5899ae9b@kernel.org>
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

On Mon,  9 Jan 2023 22:11:07 -0800 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series provides bug fixes to mlx5 driver.
> Please pull and let me know if there is any problem.

Posted too late in the day for me to pull so FWIW:

Acked-by: Jakub Kicinski <kuba@kernel.org>
