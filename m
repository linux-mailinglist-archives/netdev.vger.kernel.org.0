Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D556BC561
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCPEma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCPEm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:42:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F77FABB21
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:41:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94BDE61ACA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 04:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64C9C433D2;
        Thu, 16 Mar 2023 04:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678941712;
        bh=F8o6afti0ZpNtlVNTb/6W0Fg650FSqWLe1m9IexY0F0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yy+qaIi9R52LVG+Yuj7T4oHOjY6I9sUusyX+i5gNMHtPMQeJDaviGcfzmKqCa5SNL
         n8GZqxDO8ma29CWTV8KB18KGNvmwXf7nnOpVboMr6HSROFj2hVqzlyH9EjVylT5xSi
         9NQvMz4EJQSoROK5SfVIR8T5vjHteVqCAiO1/5TUAgMcDxOseLI7UvHHKc5nZw0YSi
         gVm5tNjpE+48c1+lHCIhcAIXtI2LtToAgOrfa4L243xfeTlxP+/RgaKC7U3ppPyEAy
         1bLUuMDqZeSjh5BzPjXyRwn1lMB1/hqGeUol30Ludz8gKZCmS/az5JsUjMqtuwm+lF
         VoVQDSlWLVADQ==
Date:   Wed, 15 Mar 2023 21:41:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, arkadiusz.kubalewski@intel.com
Subject: Re: [PATCH net v2] tools: ynl: add the Python requirements.txt file
Message-ID: <20230315214150.5a5e9612@kernel.org>
In-Reply-To: <20230315122811.22093-1-michal.michalik@intel.com>
References: <20230315122811.22093-1-michal.michalik@intel.com>
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

On Wed, 15 Mar 2023 13:28:11 +0100 Michal Michalik wrote:
> It is a good practice to state explicitly which are the required Python
> packages needed in a particular project to run it. The most commonly
> used way is to store them in the `requirements.txt` file*.

Ah, missed this, let's continue discussion on v1.
Also take a look at:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
