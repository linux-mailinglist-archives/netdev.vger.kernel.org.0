Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2EC6036B3
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJRXi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJRXi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:38:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07149C96F8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA004B8218A
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A02FC433C1;
        Tue, 18 Oct 2022 23:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666136334;
        bh=wLAlgscqmbN90oBymiJi+KdGngSF8oPYFhCQ2hu5T2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=isytLdPCIC8PP4a0J+wt+E0E6IuYjWlnDU79eN28oQQYXvYMaf4/pxZBDudyJMPCh
         t32bwc46Nfgtk9PiOyraGRcbr9KxM1Yc+blfolw0/4JI9LWCGNzngvoTqHBl25xlec
         284ZJlGob/6dW/ZTS3jpIfqEQ5vLe8v7ed4MLcp4A6RwZhHq9hg2Tzzn5o4+uT9whJ
         bREn9EumRpjDarLKGdx4/A6CeV1m3TCL7HjVvVdXs6El/ULzFSChRRY+M1mFaxxSi8
         csplbsi6LjwDZIaQAnHnLV4itQE/inSL/HHkIv3AJZ6yLT60X3XdQ/TPuA2HCzR+9k
         Tcxe0lNGHzp1Q==
Date:   Tue, 18 Oct 2022 16:38:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com
Subject: Re: [PATCH net-next] ibmveth: Always stop tx queues during close
Message-ID: <20221018163853.6e65eee6@kernel.org>
In-Reply-To: <94c6ed71-286b-0fd8-5128-9fe9b7ebcd0f@linux.ibm.com>
References: <20221017151743.45704-1-nnac123@linux.ibm.com>
        <20221018114729.79dbfbe2@kernel.org>
        <94c6ed71-286b-0fd8-5128-9fe9b7ebcd0f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 16:00:14 -0500 Nick Child wrote:
> Since the issue only results in annoying "failed to send" driver 
> messages and is under no pressure to get backported from end users, we 
> are okay if it does not get backported. That being said, if you would 
> like to see it backported, I can send you the patches that would apply
> cleanly to v4.9 and v4.14-v5.15.

If it's just a error message in the logs net-next is fine.
Please repost with that clarified in the commit message, tho.
