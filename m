Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B767D618
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbfHAHL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:11:58 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54098 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHAHL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 03:11:58 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ht5FW-0007nT-U7; Thu, 01 Aug 2019 09:11:43 +0200
Message-ID: <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michael Ellerman <mpe@ellerman.id.au>,
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
Date:   Thu, 01 Aug 2019 09:11:40 +0200
In-Reply-To: <874l31r88y.fsf@concordia.ellerman.id.au> (sfid-20190801_032117_118545_20A85892)
References: <20190712001708.170259-1-ndesaulniers@google.com>
         <874l31r88y.fsf@concordia.ellerman.id.au>
         (sfid-20190801_032117_118545_20A85892)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Luca, you said this was already fixed in your internal tree, and the fix
> would appear soon in next, but I don't see anything in linux-next?

Luca is still on vacation, but I just sent out a version of the patch we
had applied internally.

Also turns out it wasn't actually _fixed_, just _moved_, so those
internal patches wouldn't have helped anyway.

johannes

