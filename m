Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29A6CF312
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjC2TWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjC2TWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:22:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B182B10E7
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:22:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 27A7FCE203F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0FFC433D2;
        Wed, 29 Mar 2023 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680117748;
        bh=Q11oQSYkKzYNWX5I/wJ7b3f0obXABNw/WYIzQhmDy1k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jBoIMr+1prcay3Ixksw6u4MX9V6wHqD5M4LJ8AWSRAMnQW63rZo0jzceLAvgIwpYx
         F38fW3tts7LPg/pQ2E25zz10GNTiRqLihc7biQzwOESmOx2fBv7O3ITvT0Ds/ePdxP
         jyN4lKeOVphVlgTzfbybTl8vn99OVqaihgegLg37TO6PKsOJ964SV3Ea1GdhSajH3X
         9q0jZtGXBAsqyAGocbJqfly8aYPDGH3iF4sQnpgFjIEHw+eStuLf5E+5/HMhnx26OW
         PmRo4f5NId298bbhhOcBQ4CWf79i8Ly4FSbigZruCGjJ+O+IExO7cLr4ro/8cBtJlL
         mdZ0d65mbeXOQ==
Date:   Wed, 29 Mar 2023 12:22:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Message-ID: <20230329122227.1d662169@kernel.org>
In-Reply-To: <20230329144548.66708-2-louis.peens@corigine.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 16:45:47 +0200 Louis Peens wrote:
> In some customized scenario, `dev_port` is used to rename netdev
> instead of `phys_port_name`, which requires to initialize it
> correctly to get expected netdev name.

What do you mean by "which requires to initialize it correctly to get
expected netdev name." ?
