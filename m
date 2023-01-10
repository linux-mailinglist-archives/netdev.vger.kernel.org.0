Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701E7664D31
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 21:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjAJUW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 15:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjAJUW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 15:22:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160375D412
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 12:22:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A713861750
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 20:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4639C433EF;
        Tue, 10 Jan 2023 20:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673382144;
        bh=OBjN1HhEGL2ecyz+Q39fijw0Qj2u1JD4LynKhyUcZj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NB07E0f8c+owXnd1i+aB2hxh9JHseWnE52/js7xY1tQA6uXWalZCreiHrK+Fbxgvn
         pX7/W4MKC6mahHmXaUiHktY530AOn9M60sqAauGjhtpYrsMXAyNGSypoRWYR0q0CvU
         GVFhU6F4URUJm/6vof63fxBV/WBjoPkXPg8gjpVgceTTnm8k2q6lZ979iOhYLfewK4
         KX9GE093zN98poYZzF6edjl+YofFom1+YKv9m2aIAG+ogBwwaiSYjaJO7jwRd0pMmi
         DGxAxXUe0IiKplqFFPCKHxI5imJ5F5T1gPl0mdBvzikUpKP1ac52D9Vft6eWvNGEdL
         FASZDpy/PNtOg==
Date:   Tue, 10 Jan 2023 12:22:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters
 after the instance
Message-ID: <20230110122222.57b0b70e@kernel.org>
In-Reply-To: <Y72T11cDw7oNwHnQ@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
        <20230106063402.485336-8-kuba@kernel.org>
        <Y7gaWTGHTwL5PIWn@nanopsycho>
        <20230106132251.29565214@kernel.org>
        <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
        <Y72T11cDw7oNwHnQ@nanopsycho>
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

On Tue, 10 Jan 2023 17:35:35 +0100 Jiri Pirko wrote:
> >I did find it convenient to be able to do both pre and post-registering,
> >but of the two I'd definitely prefer doing it post-registering, as that
> >makes it easier to handle/allow more dynamic sub-objects.  
> 
> I'm confused. You want to register objects after instance register?

+1, I think it's an anti-pattern.
