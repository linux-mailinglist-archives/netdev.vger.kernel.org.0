Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C673BAFA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbfFJRa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:30:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38157 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbfFJRa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:30:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so5395265pgl.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xO/rtsowg8DIpJ1ozcB3j4tcwb9+PJRHYtPkURjDAlM=;
        b=SbRmWMtOWNgmiyg0EjaUbpLFbibX169ew2IO/y9c/rmkUJCAJGyn8F9Kr8gwbiYEOE
         nnR9XvgUC9ica1rOt4gTR19LJzl2FU9gSL6MFUp+dMhTCjCbP94+TJC8bgG79wJ3b1YQ
         k7Bn/fSmvxH8mpxVG89N9OkfDl5p9CB5OoeCKX76BVgqh+yCWkvD5k+T4ZMr0OhuavL1
         adG54nexxwYw2CeGM0pSnARxIIuNxv+MwgJpqgWp0YhkDqmglIxLQFTT9wKC1x7jUTSc
         4hd9Be/IowI9UtrhnHcfXEaHXoXvoVuxSBzEj1wceumRAPPPQXPP/ah0gS31oWwsS2Ke
         mT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xO/rtsowg8DIpJ1ozcB3j4tcwb9+PJRHYtPkURjDAlM=;
        b=O35wY2NZwrU4DYGj5puWx/eCd3JZEmOBnRd7CCK4DoI8wp+Z83GMEBr1/58McKt+r6
         W/nNCeh8TB1ptl7+1kVPDWfxsaQkeBGFOMxGazRgU2FenKz+asUc3UpTIHfIpyuRBzd6
         sTTUL4fvr1w0EoIbONXO3JehEHR4Za2a9HTpipV/cJqPUdpLJdJncHDa9Z3O7qXOdRgS
         SlBVY8oNd+EksxpfwbcNhbXKzAFnC0MaeM7DlG9rDgMbfs1xWjeu1XkB/rTdGyInZ+Kx
         70bvuQoQ0rDfCRvw+zXFNbDIIzZ2VM1AkV+6VztvrZPrHt3TJD6V3tDL73VgBW+ox4Nh
         iPLw==
X-Gm-Message-State: APjAAAV9WAK9LDhMXAioGTmRKp1ydg1t5KeVNQimSfuP6eQBJR3Fc/wt
        wFy5xgEdUvfgda/9AOul7xQ=
X-Google-Smtp-Source: APXvYqxob71WhQTInjHUUOWzO/3ChgKGJiJwlLH7ANWB4LDVVhayXzNl+mmS71bBdsIJsDZ7e2xkWw==
X-Received: by 2002:a65:4907:: with SMTP id p7mr16366210pgs.288.1560187826889;
        Mon, 10 Jun 2019 10:30:26 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j64sm18507320pfb.126.2019.06.10.10.30.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 10:30:26 -0700 (PDT)
Subject: Re: [patch net-next v3 3/3] devlink: implement flash status
 monitoring
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com, sthemmin@microsoft.com,
        saeedm@mellanox.com, leon@kernel.org, f.fainelli@gmail.com
References: <20190604134044.2613-1-jiri@resnulli.us>
 <20190604134450.2839-3-jiri@resnulli.us>
 <08f73e0f-918b-4750-366b-47d7e5ab4422@gmail.com>
 <20190610102438.69880dcd@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <249eca9b-e62a-df02-7593-4492daf39183@gmail.com>
Date:   Mon, 10 Jun 2019 11:30:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190610102438.69880dcd@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/19 11:24 AM, Jakub Kicinski wrote:
> On Mon, 10 Jun 2019 11:09:19 -0600, David Ahern wrote:
>> On 6/4/19 7:44 AM, Jiri Pirko wrote:
>>> diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
>>> index 1804463b2321..1021ee8d064c 100644
>>> --- a/man/man8/devlink-dev.8
>>> +++ b/man/man8/devlink-dev.8
>>> @@ -244,6 +244,17 @@ Sets the parameter internal_error_reset of specified devlink device to true.
>>>  devlink dev reload pci/0000:01:00.0
>>>  .RS 4
>>>  Performs hot reload of specified devlink device.
>>> +.RE
>>> +.PP
>>> +devlink dev flash pci/0000:01:00.0 file firmware.bin
>>> +.RS 4
>>> +Flashes the specified devlink device with provided firmware file name. If the driver supports it, user gets updates about the flash status. For example:
>>> +.br
>>> +Preparing to flash
>>> +.br
>>> +Flashing 100%
>>> +.br
>>> +Flashing done
>>>  
>>>  .SH SEE ALSO
>>>  .BR devlink (8),  
>>
>> something is missing here from a user perspective at least:
>>
>> root@mlx-2700-05:~# ./devlink dev
>> pci/0000:03:00.0
>>
>> root@mlx-2700-05:~# ./devlink dev flash pci/0000:03:00.0 file
>> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
>> devlink answers: No such file or directory
>>
>> root@mlx-2700-05:~# ls -l
>> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
>> -rw-r--r-- 1 cumulus 1001 994184 May 14 22:44
>> /lib/firmware/mellanox/mlxsw_spectrum-13.2000.1122.mfa2
>>
>>
>> Why the 'no such file' response when the file exists?
> 
> I think the FW loader prepends /lib/firmware to the path (there is a
> CONFIG_ for the search paths, and / is usually not on it).  Perhaps try:
> 
> ./devlink dev flash pci/0000:03:00.0 file mellanox/mlxsw_spectrum-13.2000.1122.mfa2
> 

that worked, but if the user specifies fullpath that is confusing. So at
a minimum the documentation needs to be clear about the paths.

But, why the path limitation? why not allow a user to load a file from
any directory? For mlxsw at least the file in /lib/firmware will be
loaded automagically, so forcing the file to always be in /lib/firmware
seems counterintuitive when using a command to specify the file to load.
