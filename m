Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8DF5BD9A0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiITBrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiITBrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:47:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539153033
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:47:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FB8BB82355
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A8BC433D6;
        Tue, 20 Sep 2022 01:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638425;
        bh=nDFIqodxpbs8ibNfn4G47eAf/N9PK5QI9IfUONNRk5w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pDs6+cu5R+ixEwE+Ah0116izwS5fxNBad8E0D4dud+IXTyUlnxlGJlWjXRa7hpB+L
         mMWFU2rfCoJI3ssmoUTK4SglRNAGyzjUJUi87hOyCeGRDLRgM0ppjR07lKxEtSAYBA
         aisxdLGL4g99mKFEtX1QhHXIwWKmwfgy9cuzZ9htTY2Gf9DUaYdogmBwou7Dv0XzIe
         0MUiJCLc94RR03ZWbNVQO9ZlCFGNkw7Ju5fAtGODX/9MbRg7idqTx00Q7NHhrEElqE
         rlOaU7ohpIOPbgp9FJr8RUIBjWt3pmG39bsvcY3Xv9UDzjZ2UQ/0AhYI29yWkN+Q1+
         5Ydn/jpA4oIZg==
Date:   Mon, 19 Sep 2022 18:47:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 1/4] net/tls: Describe ciphers sizes by const
 structs
Message-ID: <20220919184703.5e0d2d44@kernel.org>
In-Reply-To: <20220914090520.4170-2-gal@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
        <20220914090520.4170-2-gal@nvidia.com>
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

On Wed, 14 Sep 2022 12:05:17 +0300 Gal Pressman wrote:
> +#define CIPHER_SIZE_DESC(cipher) [cipher] { \

I'll hopefully get to doing more meaningful reviews tomorrow, 
but in the meantime please send a v2 fixing the compiler issues.

This macro makes gcc unhappy, should likely be [cipher] = { ?
