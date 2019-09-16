Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97784B346B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 07:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbfIPFbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 01:31:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39641 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfIPFbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 01:31:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id r3so7250057wrj.6
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 22:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qmVvFLqP1/Iy0U40o4z3uyLQYpbfmd+krJn4gZmoZjc=;
        b=WdkIaYyQ4mMTt8hyv+GfqhYgGmJfqu5RMEE+wT12FRwu4gHmQraqcXpz8YFKrskkZ0
         KSbX3F+BjM16REeVaA4RJqkT2RKe9SjDpmvpRUVeQ3St2QXzmufQkGH7TQLHhecUpEoa
         /bLU1pXEDGo2STZAZAWwi9Q59bksM1mOmxviO26TG6W+yI5iblDZGZlMs9tSFV4hPkQk
         98EhxcCd/wL20Ei75uzpwxe4affWhV1ehV7CvzA61A0H5FVeylT8/Gj3ben+ywGrvMRm
         20h1Br1qlklXl3KDSlEdvNk+8ZqspN+E7iPaN5Pwlj2iLe1Q3C5gMEjFfaHtvnqyXZuV
         ChKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qmVvFLqP1/Iy0U40o4z3uyLQYpbfmd+krJn4gZmoZjc=;
        b=kYyYZkM29E5ac4V/hjjjsHtiMtdaqieSFL0ZAImu/NDum0ZkFK4ZNy1kAKCAWFrbcC
         hC3Q1cRc/sAVPEdCEpFP1mr6g4Vj3HFjt3eHShZXe0uVxaX0+Du9lTl8zxvj+Y13FMBm
         3BCF8pMPe3BJMotRnqiA+SMk/yzw+EGkze/VRJUZ8Ugp0WIglgaSXcGSfQRa07Tt7r7X
         j0I5bqJZ7KP7ZmUOhuIaQq97St3nmbk3oOJXmVydewmuj2QdWUxngbUeicU5O3U6Do24
         daHTu7E+5dSUQMeVBWiqqT99rNAGvWWgtw/eATEmuJ9wfNSKgTZ8IP3gY7n/II+DJjjg
         btrA==
X-Gm-Message-State: APjAAAWEc0EG/bTo1GgsgIRk3eiqlGdu33ik1U4fWMU4eQ7TmCfexv4+
        0ptDayevCchZS/L4D1KI0T2A8w==
X-Google-Smtp-Source: APXvYqyc31ky7y5rVl2RtqNSgEfZmWfiwP2nQ4nPApVOaI7SeRMU3N70u8JMW2wUoJ0UP+Fw783whQ==
X-Received: by 2002:adf:cd86:: with SMTP id q6mr17761907wrj.44.1568611895554;
        Sun, 15 Sep 2019 22:31:35 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o188sm17755925wma.14.2019.09.15.22.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2019 22:31:35 -0700 (PDT)
Date:   Mon, 16 Sep 2019 07:31:34 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
Subject: Re: [patch iproute2-next v4 0/2] devlink: couple forgotten flash
 patches
Message-ID: <20190916053134.GF2286@nanopsycho.orion>
References: <20190912112938.2292-1-jiri@resnulli.us>
 <2c201359-2fa4-b1e4-061b-64a53eb30920@gmail.com>
 <20190914060012.GC2276@nanopsycho.orion>
 <7f32dc69-7cc1-4488-a1b6-94db64748630@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f32dc69-7cc1-4488-a1b6-94db64748630@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 15, 2019 at 07:58:33PM CEST, dsahern@gmail.com wrote:
>On 9/14/19 12:00 AM, Jiri Pirko wrote:
>> Fri, Sep 13, 2019 at 07:25:07PM CEST, dsahern@gmail.com wrote:
>>> On 9/12/19 12:29 PM, Jiri Pirko wrote:
>>>> From: Jiri Pirko <jiri@mellanox.com>
>>>>
>>>> I was under impression they are already merged, but apparently they are
>>>> not. I just rebased them on top of current iproute2 net-next tree.
>>>>
>>>
>>> they were not forgotten; they were dropped asking for changes.
>>>
>>> thread is here:
>>> https://lore.kernel.org/netdev/20190604134450.2839-3-jiri@resnulli.us/
>> 
>> Well not really. The path was discussed in the thread. However, that is
>> unrelated to the changes these patches do. The flashing itself is
>> already there and present. These patches only add status.
>> 
>> Did I missed something?
>> 
>
>you are thinking like a kernel developer and not a user.
>
>The second patch has a man page change that should state that firmware
>files are expected to be in /lib/firmware and that path is added by the
>kernel so the path passed on the command line needs to drop that part.

ok
