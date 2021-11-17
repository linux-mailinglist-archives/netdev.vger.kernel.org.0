Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCF1454476
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhKQKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbhKQKBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:01:47 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770DAC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:58:49 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 136so1841561pgc.0
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 01:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UssrEFKdM05/SJNbakTbDZcHgbbBExfUFgDJb9KZkzw=;
        b=oCdXrUaWQZnjsTJEt0rs8nC2xPVsaVSips6npiWEs7W4HVjEVd938RzbRxfW/BJBJ0
         iTGyDcHqxqx+twaiFr4HfPsIeTXhLkmeuFmdonkqbkJVCFYLpTzTBMBoAbNxU/pP0dE4
         j7aKLBrFihySHrRUCMH6RuwlH8hzwSD/tlS4MCpLkMJZxiYUwsc4S13eIONR2bo9pfxF
         2C7gf23qjtVh9jShrLSU11IdayuTYu5SKPqqmfu1DTZLhibTXSk6T38ayCm9BcN1/Ky1
         AY/zJeuF7BA2I/IHxU9vaUv5R3bErelMu45ITaJv05nhIlQZ2iCFh0PpLsJde3MHl4E0
         lVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UssrEFKdM05/SJNbakTbDZcHgbbBExfUFgDJb9KZkzw=;
        b=6ox0JH6bDT+5w/fkU4A7yO7AV0gHL3mRLEKsrt8Qia7ZoQO9YrIs8PNf16TKinWdya
         UTLBWyj7mGc5mFYwy+D7c6Hi1qJLq6WBqQq/Gl9kdjOglHRhzFUARkMGHAwaYLKqYxrQ
         F6P0cX0Vm741ZxOec9rBH605QRUdVmi/7ZZBU1gE436vl6oQbMNgps7LiLHiHsp+1kRP
         ANnIaKMbTxK+3x+cWmahwK/BABPHN1utQ4SA14bGoqkyOIh/enALlz0sn/hHEcntTo7V
         5W1oBK6t6RqxEppceg/iET5xjlZdnAp0TnB5fSGtiuqyhSuZzLPTY9uGyuKR/6Ud4ZyZ
         +NQA==
X-Gm-Message-State: AOAM530IdzZ1pfMIVPwbyUZU4MVnzq+cR0qv1tPLnkfOjOrgih02Pufg
        0Xcq4a+x8SUAJfjtkmVejG0=
X-Google-Smtp-Source: ABdhPJzTtv1lsoU9uAWkAxb73D9OKVe4CkwMjBpB8gqUEJOhxQYcfOqqA4ywagD2yNRtR8RuJA/Tfg==
X-Received: by 2002:a63:2a8d:: with SMTP id q135mr4264995pgq.167.1637143129116;
        Wed, 17 Nov 2021 01:58:49 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s5sm6176232pgq.62.2021.11.17.01.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 01:58:48 -0800 (PST)
Date:   Wed, 17 Nov 2021 17:58:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add missed_max option
Message-ID: <YZTSUh0vA1gVZFr3@Laptop-X1>
References: <20211117080337.1038647-1-liuhangbin@gmail.com>
 <70666.1637138425@nyx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70666.1637138425@nyx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 08:40:25AM +0000, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >Currently, we use hard code number to verify if we are in the
> >arp_interval timeslice. But some user may want to reduce/extend
> >the verify timeslice. With the similar team option 'missed_max'
> >the uers could change that number based on their own environment.
> >
> >The name of arp_misssed_max is not used as we may use this option for
> >Bonding IPv6 NS/NA monitor in future.
> 
> 	Why reserve "arp_missed_max" for IPv6 which doesn't use ARP?  If
> the option is for the ARP monitor, then prefixing it with "arp_" would
> be consistent with the other arp_* options.

I didn't explain it clearly. I want to say:

I'm not using arp_misssed_max as the new option name because I plan to add
bonding IPv6 NS/NA monitor in future. At that time the option "missed_max"
could be used for both IPv4/IPv6 monitor.

I will update the commit description in next version.

Thanks
Hangbin
