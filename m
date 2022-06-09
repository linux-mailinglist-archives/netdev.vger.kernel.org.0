Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10505456D5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 00:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbiFIWDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 18:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiFIWDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 18:03:01 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B771196A99;
        Thu,  9 Jun 2022 15:02:59 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id EFA0A58723354; Fri, 10 Jun 2022 00:02:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id ECAB160C247C3;
        Fri, 10 Jun 2022 00:02:56 +0200 (CEST)
Date:   Fri, 10 Jun 2022 00:02:56 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
In-Reply-To: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
Message-ID: <6s1p436o-r4ss-p9n0-o486-qo7s747n6913@vanv.qr>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Friday 2022-05-20 18:16, Kent Overstreet wrote:
>Problems with ioctls:
>
>* There's no namespacing, and ioctl numbers clash
>
>IOCTL v2 proposal:
>
>* Namespacing
>
>To solve the namespacing issue, I want to steal an approach I've seen from
>OpenGL, where extensions are namespaced: an extension will be referenced by name
>where the name is vendor.foo, and when an extension becomes standard it gets a
>new name (arb.foo instead of nvidia.foo, I think? it's been awhile).
>To do this we'll need to define ioctls by name, not by hardcoded number, [...]

https://www.khronos.org/registry/vulkan/specs/1.3-extensions/man/html/VK_NV_glsl_shader.html
Right there on the front matter: "Registered number #13".

https://www.khronos.org/registry/vulkan/specs/1.3/styleguide.html
"All extensions must be registered with Khronos."
"Each extension is assigned a range of values that can be used to create globally-unique enum
values"
