Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B107EDFA
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390451AbfHBHsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:48:53 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45354 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729945AbfHBHsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:48:52 -0400
Received: by mail-wr1-f48.google.com with SMTP id f9so76109311wre.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 00:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RohZmlVDuv7RQtH7w2iKelx9xhIf4wDMo0o80NbNvFE=;
        b=D/kaJGXvWPWfMkU2jaJhCmvoKZmre4kOBVWYBxqKVFfPOc8piKmnNlunRF93cQHrTt
         GF/2RWPNjyIxSWF5lvV3j3MkWSd7XB+zn7Z0ocVN9LZf4gVRrLbNMJ5jPiJI6CbMBuKT
         6w5jlcWC/swMv+iS0KxWk8MyGDfMv+0s6SZH3qkoQl2dExxayxP1dITWLXWFNFnd5zhN
         vp0iMowV61fw4DvrxVxa3PIGYhQ5qFRX8/GMpsq7Ba6Zdwj/NMw9Sd/jYJCxkL2qoJxZ
         kD3Lg0uh1GRHS7ESur40O6vQGJI9i5pY3p2MSoPbMFkNlZTNrxECgYPMnZO9x/j+XEy/
         WOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RohZmlVDuv7RQtH7w2iKelx9xhIf4wDMo0o80NbNvFE=;
        b=N9vnFIES2Nawqz/m1/tTNI94U6pU9xhxjaXv8mkdzThPBxm9FlmktaryKYwhjiBcCe
         VhlYNe0X+mx3iyieU+dvBhuKuLkOwby8L0fBF/nUGZNR7jpTq7jtNOvn72wp3V+SIX7T
         AdsWxKFSuK3dglyAMK2p3uiDkSr9jp2DIzfjeLpSrUNE9hdnwodQ8HT2AhV9dMajM/h+
         zhZBUq+zENIgyD5vTnwb1Z8mWek31cM6KOdXWqN6oz6FzdA6pouPzIFX1hgew1TnT+Vk
         azusFkL6Btew6D6JU8BT6Ug9I3uE+OO0kFgEEO1KpSdKCCG7IxQuWX272cJvEeJWp+xn
         2NVA==
X-Gm-Message-State: APjAAAW+jnIZ6ZZGliJ8bWaFl6Yf217VPB573OqznurNcmdyidAkRzQr
        rUf7Dt7UNnmfRWdtHzYveJ9hDas7
X-Google-Smtp-Source: APXvYqy9oBAjYm8VGs2QiSgJFQRk7AHtNZVZ2a2a5/JMV+oiCVUCPtohmKVHqB7QIYjoI6vJc3AfDQ==
X-Received: by 2002:a5d:5510:: with SMTP id b16mr108856593wrv.267.1564732130354;
        Fri, 02 Aug 2019 00:48:50 -0700 (PDT)
Received: from localhost ([80.82.155.62])
        by smtp.gmail.com with ESMTPSA id z19sm55219272wmi.7.2019.08.02.00.48.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 00:48:50 -0700 (PDT)
Date:   Fri, 2 Aug 2019 09:48:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190802074838.GC2203@nanopsycho>
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 31, 2019 at 09:58:10PM CEST, dsahern@gmail.com wrote:
>On 7/31/19 1:46 PM, David Ahern wrote:
>> On 7/31/19 1:45 PM, Jiri Pirko wrote:
>>>> check. e.g., what happens if a resource controller has been configured
>>>> for the devlink instance and it is moved to a namespace whose existing
>>>> config exceeds those limits?
>>>
>>> It's moved with all the values. The whole instance is moved.
>>>
>> 
>> The values are moved, but the FIB in a namespace could already contain
>> more routes than the devlink instance allows.
>> 
>
>From a quick test your recent refactoring to netdevsim broke the
>resource controller. It was, and is intended to be, per network namespace.

unifying devlink instances with network namespace in netdevsim was
really odd. Netdevsim is also a device, like any other. With other
devices, you do not do this so I don't see why to do this with netdevsim.

Now you create netdevsim instance in sysfs, there is proper bus probe
mechanism done, there is a devlink instance created for this device,
there are netdevices and devlink ports created. Same as for the real
hardware.

Honestly, creating a devlink instance per-network namespace
automagically, no relation to netdevsim devices, that is simply wrong.
There should be always 1:1 relationshin between a device and devlink
instance.
