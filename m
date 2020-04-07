Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C21A0920
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgDGIOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 04:14:07 -0400
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:14397 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgDGIOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 04:14:07 -0400
X-Greylist: delayed 555 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2020 04:14:06 EDT
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 28CD14597C;
        Tue,  7 Apr 2020 10:04:50 +0200 (CEST)
Subject: Re: [PATCH] net/bpfilter: remove superfluous testing message
To:     David Miller <davem@davemloft.net>, bmeneg@redhat.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200331130630.633400-1-bmeneg@redhat.com>
 <20200331.100806.878847626011762877.davem@davemloft.net>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
Message-ID: <f6af51c3-0875-c394-f6c4-2f51c7d1280c@proxmox.com>
Date:   Tue, 7 Apr 2020 10:04:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:75.0) Gecko/20100101
 Thunderbird/75.0
MIME-Version: 1.0
In-Reply-To: <20200331.100806.878847626011762877.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 7:08 PM, David Miller wrote:
> From: Bruno Meneguele <bmeneg@redhat.com>
> Date: Tue, 31 Mar 2020 10:06:30 -0300
> 
>> A testing message was brought by 13d0f7b814d9 ("net/bpfilter: fix dprintf
>> usage for /dev/kmsg") but should've been deleted before patch submission.
>> Although it doesn't cause any harm to the code or functionality itself, it's
>> totally unpleasant to have it displayed on every loop iteration with no real
>> use case. Thus remove it unconditionally.
>>
>> Fixes: 13d0f7b814d9 ("net/bpfilter: fix dprintf usage for /dev/kmsg")
>> Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
> 
> Applied, thanks.
> 

As the commit this fixes was included in a stable release (at least 5.4.29[0],
I did not checked others - sorry) it could make sense to backport this also
to the 5.4 stable tree?

Per documentation[1], I checked the netdev and Greg's queues, but did not found
it to be included anywhere yet.

I hope I handled this request somewhat correctly, please tell me if I should
propose the backported patch more directly to the respective stable list. As is,
the patch[2] applies fine here on top of 5.4.30.

cheers,
Thomas

[0]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.4.y&id=712c39d9319a864b74b44fd03b0e083afa2d8af2
[1]: https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#q-how-can-i-tell-what-patches-are-queued-up-for-backporting-to-the-various-stable-releases
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/patch/?id=41c55ea6c2a7ca4c663eeec05bdf54f4e2419699

