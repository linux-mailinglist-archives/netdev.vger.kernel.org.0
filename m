Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA4714465
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 08:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbfEFGQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 02:16:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33947 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFGQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 02:16:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id f7so5309124wrq.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 23:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9RNXBmVBC4bjEu0wtSn0ClHzzb15m0de45Ao5G3wtto=;
        b=dwvjYcFI3BwdXK2Q1HZP2YwxLi0PpJ09mjuNx4QIjSRRiT8ZTdWHmLsUxbifRT5K4e
         95sx4ByoLssHYv8alHgPmeGlxa8UDd0SPiT73SoeQHYP4qFoyDN3kRadgrzJLqzpYI+h
         bddsuBFLuMYuh44OnCkCJsm0fDL8fKkrcx+f8AASro7Lx7GTkz0mY0wYBuuEZPQ36H95
         TTKBVYOmOq5Kga1MxGDpG7pbn6Oxv9QSfpk0mHW2k9yIC16AWHp75jhLK4ckqnOM/zfF
         22fONrhb4dk/gCZIHuFegkoaOwohYiDxDPeyHXw7Mta+m8IehJ/gqhX1hKAqBfcZFOnD
         TNFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9RNXBmVBC4bjEu0wtSn0ClHzzb15m0de45Ao5G3wtto=;
        b=co9FBJ2sU75THupvd5HU5BewYe4iiGf2xDJDsKGUBVCIzuNaS95gojG4URpAQp5wjb
         TTKquUDNN9VLITrj+qTuYKdupTMN3h7JTpn6TDWWNZOHw/hxWJay+gi7YvvT7yqOzzn0
         rOxWPS3owejqdhXaDEHd2AwyJliXsPLp6djF1FjF2H8B14mzlF/rlHEO0/zPL9GEqMGO
         RAcYBqMihIbKwboo8zx9xCAKcdYCIuy6T6WuYep/Cjalb6G/jKh8+zhc52PE22dfKhnv
         dgFkHoFb+O39BLHZJQDZL+El860xRykzJFLoQiIgu9HMJ0f53OsG+V64+1q6sA4rVg8k
         Q81A==
X-Gm-Message-State: APjAAAUKVhLDQd2OioIXrSk1nTvIjbyCcO0lP46974+l98Rf6YiryPk3
        SXLz72yeRUwMTgmDORW/bGKYrw==
X-Google-Smtp-Source: APXvYqzbypOe5NJ2DQlgJO242AZ50cDsZ3TfZ2nJGu2JzP/k4x8y2fR2vDMxtwjTqfoziGHC7fr9/Q==
X-Received: by 2002:adf:f08a:: with SMTP id n10mr2532821wro.184.1557123392857;
        Sun, 05 May 2019 23:16:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j13sm31652404wrd.88.2019.05.05.23.16.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 23:16:32 -0700 (PDT)
Date:   Mon, 6 May 2019 08:16:31 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 10/13] net/sched: add block pointer to
 tc_cls_common_offload structure
Message-ID: <20190506061631.GB2362@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-11-jakub.kicinski@netronome.com>
 <20190504131654.GJ9049@nanopsycho.orion>
 <20190505133432.4fb7e978@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505133432.4fb7e978@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 07:34:32PM CEST, jakub.kicinski@netronome.com wrote:
>On Sat, 4 May 2019 15:16:54 +0200, Jiri Pirko wrote:
>> Sat, May 04, 2019 at 01:46:25PM CEST, jakub.kicinski@netronome.com wrote:
>> >From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>> >
>> >Some actions like the police action are stateful and could share state
>> >between devices. This is incompatible with offloading to multiple devices
>> >and drivers might want to test for shared blocks when offloading.
>> >Store a pointer to the tcf_block structure in the tc_cls_common_offload
>> >structure to allow drivers to determine when offloads apply to a shared
>> >block.  
>> 
>> I don't this this is good idea. If your driver supports shared blocks,
>> you should register the callback accordingly. See:
>> mlxsw_sp_setup_tc_block_flower_bind() where tcf_block_cb_lookup() and
>> __tcf_block_cb_register() are used to achieve that.
>
>Right, in some ways.  Unfortunately we don't support shared blocks
>fully, i.e. we register multiple callbacks and get the rules
>replicated.  It's a FW limitation, but I don't think we have shared
>blocks on the roadmap, since rule storage is not an issue for our HW.
>
>But even if we did support sharing blocks, we'd have to teach TC that
>some rules can only be offloaded if there is only a single callback
>registered, right?  In case the block is shared between different ASICs.

I don't see why sharing block between different ASICs is a problem. The
sharing implementation is totally up to the driver. It can duplicate the
rules even within one ASIC. According to that, it registers one or more
callbacks.

In this patchset, you use the block only to see if it is shared or not.
When TC calls the driver to bind, it provides the block struct:
ndo_setup_tc
   type == TC_SETUP_BLOCK
      f->command == TC_BLOCK_BIND
You can check for sharing there and remember it for the future check in
filter insertion.

I would like to avoid passing block pointer during filter insertion. It
is misleading and I'm pretty sure it would lead to misuse by drivers.

I see that Dave already applied this patchset. Could you please send
follow-up removing the block pointer from filter offload struct?

Thanks!
