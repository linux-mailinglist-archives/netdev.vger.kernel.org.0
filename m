Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074536A1108
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 21:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBWUKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 15:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjBWUJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 15:09:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEC422A2F;
        Thu, 23 Feb 2023 12:09:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D8A0B81A28;
        Thu, 23 Feb 2023 20:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE134C433EF;
        Thu, 23 Feb 2023 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677182989;
        bh=KkADALq5qHseVqqPJbVihCYQadkkp5GgQXqyCwnGW7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AfVAfyjyBdc1pUCLiGLx7Zq8E9RaNvRIpVhswIVn0+6ElT71oMUEiD4IG5PMNCIjw
         anLRl1h9HP0cgUu3kDsZsGf9/5F3kxeKuaw8B8iEZC6V+wB+Vg4fmuPoRKj46CiYxJ
         Lv5FiBLAjQXFNXlhUsv5l26x03YmGbhs8ykydpqE=
Date:   Thu, 23 Feb 2023 21:09:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Edward Liaw <edliaw@google.com>
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        kernel-team <kernel-team@android.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: Re: [PATCH 4.14 v2 1/4] bpf: Do not use ax register in interpreter
 on div/mod
Message-ID: <Y/fICk4NYFEF9EoS@kroah.com>
References: <20230222192925.1778183-1-edliaw@google.com>
 <20230222192925.1778183-2-edliaw@google.com>
 <Y/crdG+quVvKMF0m@kroah.com>
 <CAG4es9Wa+PxomxmK348O8nxfXny8jo=9kqQ0KOYgQq82gTNeaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4es9Wa+PxomxmK348O8nxfXny8jo=9kqQ0KOYgQq82gTNeaQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 10:46:50AM -0800, Edward Liaw wrote:
> > What is the git commit id in Linus's tree of this commit?
> 
> Hi Greg,
> It is a partial revert of 144cd91c4c2bced6eb8a7e25e590f6618a11e854.

Please document that in the changelog text very very well when you
resend this.

thanks,

greg k-h
