Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E7DB37D3
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbfIPKJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:09:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45006 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPKJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:09:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id i18so7516529wru.11
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gNW5aqjfAXr7ZfW8mUdbb0KeV0+Bt1V3M6VTM31Zqes=;
        b=ElkTuQV3NzObdTHoOexc5D3MH+FM5MnRFXqSPWABFN7xqPYVReeLPuacEh6lYo57gB
         bs6E7I+yKYsMlkyq6tG+TKOaUDtNjkXX6EA6F7O8Lf/XW8NWXSkV8NKZjhpPC+0TVaI8
         w1N5FdZSuyAdjwkHpBsw63jN9RJ+zTxnqz7jm9xsrHw9mmWluR7vKoOd01iAHtlHdtdE
         xhI+PJSSzurRvxU0KLEW7t3NwaRZttKAJ1ZI+ehYRgkrLfKW+L3QKSB8pvclRPey1x1d
         89/iRC5hrl/AcGhYt6E7SG2Zt31nBxm3xiT8ShoBGVq3vHba/kE35tH4MhqCOYZePw5V
         j/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gNW5aqjfAXr7ZfW8mUdbb0KeV0+Bt1V3M6VTM31Zqes=;
        b=RwhaBgi9xBX8JdL8R9eTDQoAJS6hxlbHMR+IDDg9kOnT/8r3synFtjqxJg4fdg3d+G
         smH7qoIXV4/RxUe462GM78mxZGGwxLTHt663OfZig90HOr/Y73etUSb2x2n2dcibIVvq
         0EMKlWuGNYyjDQt6KwkBOU4tipslIC8w4UC+kUPTmjtx1CqOygJ9ClNraTSLEeIDK6hU
         z3xLAx9a050iUdvsGcFulqbvaLeqfM3O2HlV+jHxhSwI20u5xM0XYYE3Sv3A2pn1yTqK
         ElF5l8WHXOy6NVK+KPNB8a+t02aKKVXeDiJ9KRk/J/hqsWTJa4G+LTbpUJz3RNYe3y//
         e3yw==
X-Gm-Message-State: APjAAAXBCyltBAvVu1Y8fMzzrxKEnk/ja/XAhsrYjdYYg+OptQkHQxWv
        wFRWamZOinBS94Ck93/edl3SAg==
X-Google-Smtp-Source: APXvYqyKR0lW9BQlL4Cz1Ovi7gbcDikZc3CCd03MsLe8xdFdj5MhKbLMrmi0VEwZpGfHB48IVKPaPw==
X-Received: by 2002:a5d:6812:: with SMTP id w18mr10938892wru.250.1568628565752;
        Mon, 16 Sep 2019 03:09:25 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f143sm15910275wme.40.2019.09.16.03.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:09:25 -0700 (PDT)
Date:   Mon, 16 Sep 2019 12:09:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
Subject: Re: [patch iproute2-next v4 0/2] devlink: couple forgotten flash
 patches
Message-ID: <20190916100924.GM2286@nanopsycho.orion>
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

The manpage change is just addition to the "EXAMPLES" section.
The fact that the file is expected to be in /lib/firmware is in the
devlink flash description right above:


   devlink dev flash - write device's non-volatile memory.
       DEV - specifies the devlink device to write to.

       file PATH - Path to the file which will be written into device's flash. The path needs to be relative to one of the directories
       searched by the kernel firmware loaded, such as /lib/firmware. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

       component NAME - If device stores multiple firmware images in non-volatile memory, this parameter may be used to indicate which
       firmware image should be written.  The value of NAME should match the component names from devlink dev info and may be driver-
       dependent.

EXAMPLES
       devlink dev show
           Shows the state of all devlink devices on the system.

       devlink dev show pci/0000:01:00.0
           Shows the state of specified devlink device.

       devlink dev eswitch show pci/0000:01:00.0
           Shows the eswitch mode of specified devlink device.

       devlink dev eswitch set pci/0000:01:00.0 mode switchdev
           Sets the eswitch mode of specified devlink device to switchdev.

       devlink dev param show pci/0000:01:00.0 name max_macs
           Shows the parameter max_macs attributes.

       devlink dev param set pci/0000:01:00.0 name internal_error_reset value true cmode runtime
           Sets the parameter internal_error_reset of specified devlink device to true.

       devlink dev reload pci/0000:01:00.0
           Performs hot reload of specified devlink device.

       devlink dev flash pci/0000:01:00.0 file firmware.bin
           Flashes the specified devlink device with provided firmware file name. If the driver supports it, user gets updates about the
           flash status. For example:
           Preparing to flash
           Flashing 100%
           Flashing done


I don't understand what is that you need :(
