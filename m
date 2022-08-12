Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B98591771
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 00:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiHLWxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 18:53:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C988E0FD;
        Fri, 12 Aug 2022 15:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99A961862;
        Fri, 12 Aug 2022 22:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA716C433C1;
        Fri, 12 Aug 2022 22:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660344789;
        bh=o8Wiwsb16PePStzbtEk0eOd9s3b7OqtR2cyq+N6qMKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NAzlo9y4QU6ZPBXWneAi8legL+65wTIcEeW4QgNKbrDsQxo+jT7ad4mw6w6XFNTV+
         /yDXCluyAnx0QmmtX6ptDXz5yjMCOuTfiBHLICB53gBM8eXthdis1cZa4nF8ZQuhE5
         o2gtfkUyaL/QqXBZoAN+tAtPcT4REeS8QoAVigg3F2bVi98bNKOX7TFlZjvfFHMlKo
         kb5gby6awH0udAgyyYRowTN5A58D11K/ILY2YdHbkiJXxbUdDMCGeqwndAa0MNfHqv
         0yIoxRZwoQZMmm3CixOGnzPxk8JBxaJGNy6lBw+81LLjx2JK/oP4dqFxr3bGBlfjsA
         zYolL48X4gKZA==
Date:   Fri, 12 Aug 2022 15:53:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
Message-ID: <20220812155308.520831bb@kernel.org>
In-Reply-To: <20220811130906.198b091d@hermes.local>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-4-kuba@kernel.org>
        <20220811130906.198b091d@hermes.local>
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

On Thu, 11 Aug 2022 13:09:06 -0700 Stephen Hemminger wrote:
> Looks interesting, you might want to consider running your code
> through some of the existing Python checkers such as flake8 and pylint.
> If you want this to be generally available in repos, best to follow the language conventions
> 
> For example flake8 noticed:
>  $ flake8 --max-line-length=120 ./tools/net/ynl/samples/ynl.py 
> ./tools/net/ynl/samples/ynl.py:251:55: F821 undefined name 'file_name'

Thanks! I'll make sure to check flake8 (pylint is too noisy for me :()
