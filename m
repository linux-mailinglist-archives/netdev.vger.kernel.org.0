Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65862C6688
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 14:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgK0NQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 08:16:15 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:30401 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbgK0NQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 08:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606482973;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Lr2h3k+8qZHmYvBo/cV6UBI8owJlWcA6q6SBttNBrGc=;
        b=V0TUbQvhWaLbWzUfsEH1FAeS0APcD1PM4Dxk3OmBRZYQQ+OSeux1lSpv3Er/gwt12R
        lNNhHzy6DE1M6m4uiy+lePqu67+jNDgvyK/q5Ax/Pyr7hz2K2j0hShPcxir0vT0J/C1O
        dwBDrfN66rHwNtXmitrTLAfGn6KMnEqbXzRiEIbjeKdZfxcoCAfxNna81TjQ4JI7J7Qk
        dhryHJpKLLQv4LbCKFPluAgNzdF3bUnM8fpntI3d38lOe2h0530WrXHDUuCHd8ZuNHsx
        CTLlTM1no+8nuh4OygFfduT4mbZS+lEweupGyvf9nPXSCkWFXQOgmHjrgTIzqbfP7hDc
        PoPQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGX8h6lU5f"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwARDG6xLr
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 27 Nov 2020 14:16:06 +0100 (CET)
Subject: Re: [PATCH] can: remove WARN() statement from list operation sanity
 check
To:     Marc Kleine-Budde <mkl@pengutronix.de>, dvyukov@google.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     syzkaller-bugs@googlegroups.com,
        syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
        syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
        syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
References: <20201126192140.14350-1-socketcan@hartkopp.net>
 <73bec80c-fb97-0808-8ca5-6579d9ff5251@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <6ff82b35-4dd3-43e0-f1b2-5fe30c06d04a@hartkopp.net>
Date:   Fri, 27 Nov 2020 14:16:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <73bec80c-fb97-0808-8ca5-6579d9ff5251@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.11.20 10:48, Marc Kleine-Budde wrote:

>>   	/* Check for bugs in CAN protocol implementations using af_can.c:
>>   	 * 'rcv' will be NULL if no matching list item was found for removal.
>> +	 * As this case may potentially happen when closing a socket while
>> +	 * the notifier for removing the CAN netdev is running we just print
>> +	 * a warning here. Reported by syskaller (see commit message)
> I've removed the "Reported by syskaller (see commit message)" while applying the
> patch, to keep this comment short and to the point. Use tig/git blame (or any
> other future tool) to figure out the commit message for details :D
> 

Is fine for me ;-)

Thanks Marc!
