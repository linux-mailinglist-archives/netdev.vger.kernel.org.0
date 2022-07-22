Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884DD57DC1F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbiGVISl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiGVISh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:18:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59BF9DCBB;
        Fri, 22 Jul 2022 01:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4456061A47;
        Fri, 22 Jul 2022 08:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C703C341C6;
        Fri, 22 Jul 2022 08:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658477915;
        bh=EucOG8YpcI+sPmX2/qj2NGPp5Tvngo81DFqIszqjmBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d99iSJaPV4MR2pb80Tjxllpc1rkeYkOI7shrhlbmcOVuKKIREZhhstc4pjDXInOUL
         MDBQl1ret4izg7zgGEibIena4qtFBExtb9ecEVBHMDAVX1iVkTKL1ekVvxzJzlrfhx
         BpkPg0eq5u3C1m5kQ8yCStcOFDhlxYH6g0J3fAEtRUdqHPPpka0kSu+X1vJ//LGj3L
         /PnYKhBrvXNvMeEMzZwJsngMM1reTht96PIcgoCQArk4j+acrzNhQNxopcg6BqJxWq
         13CGWAbXg6OfRnZMBZZlfzb/pQIT8ZtX4ZWsJkXyafuOE5zRIozepCRlc80mvm4b/h
         LTVWDlAH8o71A==
Date:   Fri, 22 Jul 2022 10:18:20 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, casey@schaufler-ca.com,
        ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v3 2/4] bpf-lsm: Make bpf_lsm_userns_create() sleepable
Message-ID: <20220722081820.6qlf2pszvvyfra2z@wittgenstein>
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220721172808.585539-3-fred@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220721172808.585539-3-fred@cloudflare.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 12:28:06PM -0500, Frederick Lawler wrote:
> Users may want to audit calls to security_create_user_ns() and access
> user space memory. Also create_user_ns() runs without
> pagefault_disabled(). Therefore, make bpf_lsm_userns_create() sleepable
> for mandatory access control policies.
> 
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> 
> ---

Seems reasonable,
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
