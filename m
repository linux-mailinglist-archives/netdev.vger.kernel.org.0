Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7EF50C364
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiDVW2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiDVW1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:27:44 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2849E1D83AD;
        Fri, 22 Apr 2022 14:21:16 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 07143C009; Fri, 22 Apr 2022 21:58:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650657484; bh=PKAMLv9q1RRV13PDmQSDI3TEsC6eLazeIeSFa1X2lXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9G31bDypti/BkGkKthJZve+QwS+wxhwiqyLEyXvPNjgLbLmMy65cO+zO1ju66vXL
         OeNkTK3cMcAYQQO/V6bJtQR4VXVZZ5Zg6nAMhKOioiqx4LFeWgSBWLl3KzMfN8oElM
         hdmfG6a2hJ+cheqXTshPdiN3WB3rBgFTpr/G378b+2TNr44Z6TOpGQm3tTTq9GxzOX
         AvLAzmYpsvpsQ1a3qYe/j2FP6kg79MErly94WBmLLRlseNtl9ES2eihxuCU7V2KY8E
         +QVecC83MGTUTRIfUtQdPEX0Iz9TBtcdHfrXSnWlPUobSpwnjBwBImliKmtZ1klt05
         zVmP8ztbacsEA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 7145EC009;
        Fri, 22 Apr 2022 21:57:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650657482; bh=PKAMLv9q1RRV13PDmQSDI3TEsC6eLazeIeSFa1X2lXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EmIljHzZB/Fy6wLeXbjGGhQUEOxVKB35xGzgxlhIvqov4COAORqh9XKZKPJ53iI0f
         Ob8eH9MitR9Od1DSg0L220wxB92rXrMY2qKIJjP67iiQx6AH3bF0k5UHG5aETK/+Vr
         ALR7rd+Ryv7g19MHdlkUNpT7F4OcR9X50dvjcijYKVP+QW9lM4yzQDBRjKa0b8VWub
         3e17yI7JXlkaHKBi6mHrcNQb5F1tAMVC/uAxYh9UqGSqWmZwb6KBr4BNyxlKJvj1su
         qsVEt7hagteN/I7ogsa5sKNZhQNefwOweX5+VTaD22xGCVI9nYTWco6xMWEGouXr+H
         A7H0/pqqN6WCg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id d51252ee;
        Fri, 22 Apr 2022 19:57:55 +0000 (UTC)
Date:   Sat, 23 Apr 2022 04:57:40 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <qemu_oss@crudebyte.com>
Cc:     qemu-devel@nongnu.org, Will Cohen <wwcohen@gmail.com>,
        Greg Kurz <groug@kaod.org>,
        Michael Roitzsch <reactorcontrol@icloud.com>,
        Keno Fischer <keno@juliacomputing.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Latchesar Ionkov <lucho@ionkov.net>
Subject: Re: [RFC PATCH] 9p: case-insensitive host filesystems
Message-ID: <YmMItCb97KqegQw5@codewreck.org>
References: <1757498.AyhHxzoH2B@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1757498.AyhHxzoH2B@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Fri, Apr 22, 2022 at 08:02:46PM +0200:
> So maybe it's better to handle case-insensitivity entirely on client side? 
> I've read that some generic "case fold" code has landed in the Linux kernel 
> recently that might do the trick?

I haven't tried, but settings S_CASEFOLD on every inodes i_flags might do
what you want client-side.
That's easy enough to test and could be a mount option

Even with that it's possible to do a direct open without readdir first
if one knows the path and I that would only be case-insensitive if the
backing server is case insensitive though, so just setting the option
and expecting it to work all the time might be a little bit
optimistic... I believe guess that should be an optimization at best.

Ideally the server should tell the client they are casefolded somehow,
but 9p doesn't have any capability/mount time negotiation besides msize
so that's difficult with the current protocol.

-- 
Dominique | Asmadeus
