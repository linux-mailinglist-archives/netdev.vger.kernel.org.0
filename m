Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7B76E11D9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjDMQKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjDMQKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8442798;
        Thu, 13 Apr 2023 09:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EEF9630CD;
        Thu, 13 Apr 2023 16:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19190C433EF;
        Thu, 13 Apr 2023 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681402219;
        bh=imFKYddjDFZUX0GVw1DZAGmxMw1ESMZzGSTk4CinSv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NSJBlSCjSSUHfZtEMEzp64j0LlEJP+H77fBa7OnKGgS6zIIGrK7Xw/2JYikP0j39T
         PmxvQ3QJPG/qyz7ns/RBRQ20gvAt7Te2taXg+2g7OJydVPdlVnwKBhbDWJSffWkCzK
         QUK+Ie6h9Vy/+LXjddEZcTTsD1un00LjZMKzm2f+6Jcr6PwYBEHBcY7QjCMUvQuTh/
         qYPkvuvd0l4dwJh1ipdBZdYva/nL8ohHeh/E3zvIgAIEaJFaz5ZPf4uC2R0NlfRx8f
         j+vZ69XVFyXnAKEqgS74ANZdFKe6L/flPRt3I+8B6L/jum2yYzjHv9GMNje+ks9d0B
         gacssSkWYtf5A==
Date:   Thu, 13 Apr 2023 09:10:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] wwan: core: add print for wwan port
 attach/disconnect
Message-ID: <20230413091018.0fbb8d91@kernel.org>
In-Reply-To: <20230412114402.1119956-1-slark_xiao@163.com>
References: <20230412114402.1119956-1-slark_xiao@163.com>
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

On Wed, 12 Apr 2023 19:44:02 +0800 Slark Xiao wrote:
> Subject: [PATCH net] wwan: core: add print for wwan port attach/disconnect

Subject should contain [PATCH net-next], "net" is for fixes.
