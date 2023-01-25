Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC9167BA11
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbjAYTBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbjAYTBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:01:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE2D23C55;
        Wed, 25 Jan 2023 11:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38E09CE2129;
        Wed, 25 Jan 2023 19:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AADBC433EF;
        Wed, 25 Jan 2023 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674673295;
        bh=AXaUtpNg3QgcsfBT6bp4+5ZQ5MYWDv9VhOmUZbTWnSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JZLmlLIsVO5/PNbtG96h90qvJZDxugRBOB6FfaCfl767Y3S+jHYyamYGzDLnqsV+i
         hm+PbuwyiX8nzUHL3++9JOwsm7HZiKMnFKxVc1KX2EVGb1mig9eYgHaHqhGj0yJHJu
         hxAEcn9mXXNjtwEDP6fy0OAWUO3+X1cjhA9EIOpe7ntewNDBRBTblFx7NJM8xwuGoi
         mOaHNAW52/vQs9X1ORq3L+o81eafxZcKsyB+jftIQU905ijscxtKPa0itatbKW8WQ5
         T584vxFIV0tdNdmrwZIZTN60YO/bJ1mHQ21TXQZa1DvS1AR80xwBk6ORrEX2EcZmqG
         uyFsyben+XrsQ==
Date:   Wed, 25 Jan 2023 11:01:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next v1 00/10] Convert drivers to return XFRM
 configuration errors through extack
Message-ID: <20230125110133.7195b663@kernel.org>
In-Reply-To: <cover.1674560845.git.leon@kernel.org>
References: <cover.1674560845.git.leon@kernel.org>
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

On Tue, 24 Jan 2023 13:54:56 +0200 Leon Romanovsky wrote:
> This series continues effort started by Sabrina to return XFRM configuration
> errors through extack. It allows for user space software stack easily present
> driver failure reasons to users.

Steffen, would you like to take these into your tree or should we apply
directly? Looks like mostly driver changes.
