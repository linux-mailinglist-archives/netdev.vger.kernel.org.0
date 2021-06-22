Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9B3B0DBC
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhFVToW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:44:22 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:34546 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhFVToN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:44:13 -0400
Received: from [IPv6:2003:e9:d741:e18f:a31e:1420:3e5f:861e] (p200300e9d741e18fa31e14203e5f861e.dip0.t-ipconnect.de [IPv6:2003:e9:d741:e18f:a31e:1420:3e5f:861e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B990EC0221;
        Tue, 22 Jun 2021 21:39:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1624390800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hxe3tawQ3l2EhnvfwD+78fVETvsJbuTObxBzTUq2VU=;
        b=GwVvF8JuH8jv/GlVKirIUKPat9Iu0gtuiFCMR9M19M9VjxgtKwEmRj7GyYnAGY/UC7Ci8S
        nJE/ojhjJ2Hq7yC0YMZBDDTq0uYAXPX6KR/xsVafl+iH285FvlaeFjsbL+kn7YBCKZy1SE
        X3kAIvivQzDkF4NDO9lDWt1oCesgKfXWQACFWPcG/qEjVyPyDE92RjnsgKLJnY6jPfVLdu
        RFlnlsVCwt8qrhMz6K5LvplNWUEFk/KYhqu5MJgosQpVkM9HiYr2DL/7Vii+4CzTs3rRFg
        RvkhvjnmifVU9JY+HjhRIJzzycofmP1CvgAznqYvKDGU3cHQjsCG2raD24l+TA==
Subject: Re: [PATCH net] ieee802154: hwsim: avoid possible crash in
 hwsim_del_edge_nl()
To:     Alexander Aring <alex.aring@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20210621180244.882076-1-eric.dumazet@gmail.com>
 <CAB_54W7GL8rX8_bRkgC7NAbEwmkfGOwDbdmqP6R43F_nEM3igA@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <3417d017-8ad9-c79b-3ef5-c88623dbedc9@datenfreihafen.org>
Date:   Tue, 22 Jun 2021 21:39:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W7GL8rX8_bRkgC7NAbEwmkfGOwDbdmqP6R43F_nEM3igA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 22.06.21 20:30, Alexander Aring wrote:
> Hi,
> 
> On Mon, 21 Jun 2021 at 14:02, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> From: Eric Dumazet <edumazet@google.com>
>>
>> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
>> must be present to avoid a crash.
>>
>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Alexander Aring <alex.aring@gmail.com>
>> Cc: Stefan Schmidt <stefan@datenfreihafen.org>
>> Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>
> 
> Thanks!

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
