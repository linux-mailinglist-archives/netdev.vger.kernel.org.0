Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45DFC7F66F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392499AbfHBMEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:04:36 -0400
Received: from ozlabs.org ([203.11.71.1]:47707 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392489AbfHBMEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 08:04:36 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 460QnX1zNsz9s7T;
        Fri,  2 Aug 2019 22:04:31 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking debug strings static
In-Reply-To: <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
References: <20190712001708.170259-1-ndesaulniers@google.com> <874l31r88y.fsf@concordia.ellerman.id.au> <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
Date:   Fri, 02 Aug 2019 22:04:31 +1000
Message-ID: <871ry3lqnk.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:
>> Luca, you said this was already fixed in your internal tree, and the fix
>> would appear soon in next, but I don't see anything in linux-next?
>
> Luca is still on vacation, but I just sent out a version of the patch we
> had applied internally.

Awesome, thanks.

cheers
