Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1450D4D8A63
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242450AbiCNRHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiCNRHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:07:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B843D1E0;
        Mon, 14 Mar 2022 10:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E636960EC2;
        Mon, 14 Mar 2022 17:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE00C340F6;
        Mon, 14 Mar 2022 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647277593;
        bh=b5KqwGPnPJ2Wxx5ei7xs9QzEWR2eFF5OtzPwOfg/g3c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NYqyFud6Qys2Y45RnMrhQ9idoXT4YYCqZZWLI7CsSSmjywk5IAXvJPhfRtzao6lWg
         xEH+wNk90L3zCJUZX2qrLbgq7kS3e8yBU8h5VD9OqkwJ7KUMlHQHOz8ZVEfT0z9YvV
         M+pMgtP6LJRDQUkAT220zlM2FLoW+VarKhLaDItXD2fCTiBghIt/7vPLHYmEPgjHFV
         9yqHJMpcIBprvCHDqMFusggflKHKHcC5t0IQkjVVRYyRzRsyRbhPtqk4g7cVjSGWVj
         fYngQBORAdlHvxyoYaxMkU8iBCK4m1+dVDWrJET3L+DzI7jy0Q6EtW3NsMYZiXvNSm
         hYdcSQ/P9riEw==
Date:   Mon, 14 Mar 2022 10:06:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/30] drivers: net: packetengines: fix typos in
 comments
Message-ID: <20220314100630.0ee93704@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314115354.144023-13-Julia.Lawall@inria.fr>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
        <20220314115354.144023-13-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 12:53:36 +0100 Julia Lawall wrote:
> Various spelling mistakes in comments.
> Detected with the help of Coccinelle.

FWIW it would be easier to process the patches if they were posted
individually, there are no dependencies here.
