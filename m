Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFFE8CD28
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbfHNHrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:47:08 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:38924 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfHNHrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 03:47:07 -0400
Received: by mail-wr1-f49.google.com with SMTP id t16so20017972wra.6
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 00:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=DUCn7Q2k9HfOuG0h+AfyXxYDildCLAizJGKD46uq95I=;
        b=t2cnJ2BATTjPv+gwc6a1PMOeoB4zyh+gsDdUH8bEJ/YzEb0gWAgftTMSnxGd4foZez
         N/qndoP5fGbl0NYl7oUf2Ke3Eu/clRbAVukK3J07m9vGDD6Y+kzNxlXzOL7bdAo6X/qD
         i0aaysuOjwaCPo5r78p23z9hnT6MmlzoWvyw1t1HnL7DAThuP/Ve/vb6zGUkGLXXeEka
         v4PA7fifoWdLrZYd3g8eCOQDKYTjFZvdwOHY1GQLOQsSefv0bwN8Dg/mmgsiVqO6Ftzi
         Fmg6SHtChwi1wcWAXXwNq6o37x3XO5cnc6qG6Ek3AI/WEgQTKwixBmSc3VP6gbfivkd+
         zkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DUCn7Q2k9HfOuG0h+AfyXxYDildCLAizJGKD46uq95I=;
        b=BMXdyjpQiaq6AxskOGFxwXNy96PjhJo7qFRYrTo99jDPfaV/vib4z/ggKdiDlIwazn
         s1lkvOML3YTMrP3snnWt4hMDrBx+fctNtOVit2bMzL4ezBNI5tuNi0A0uR7pQYH/aqKr
         AvSeTwqKQND1A32vzy6w3mR515YQq/Fa5FH099xMAOJsNdsW4zUeDY95tsihKvh+sNy+
         a/P8Fx4yBHfMArxmgkhLqlMvQUsoPzV7QQoAtDW3bjM68g7D1lP9zMyjCtSNX6klpCJW
         bCuY9sAFRncCh6GwicHFuRPLTxoJhsClHGXQSzs/H23QKuA0bBQ5TzCo4G/tmfQGj83E
         I8yQ==
X-Gm-Message-State: APjAAAV0rp1903x22eNVjPLUyIzYfxC/09DQ7n+4bmIo0VI33xGJ8PLX
        9P7C8dCbW/KwS+llKQzHgbkxHg==
X-Google-Smtp-Source: APXvYqzoWcTyAcpxSIXHANzMuJtNEuMXNInXE08axTD4bwKdU7LiyRGDJRMyjIuhGtvD05XI9VSiBA==
X-Received: by 2002:adf:f991:: with SMTP id f17mr22900826wrr.233.1565768826072;
        Wed, 14 Aug 2019 00:47:06 -0700 (PDT)
Received: from localhost ([195.146.112.228])
        by smtp.gmail.com with ESMTPSA id g7sm6763263wmg.8.2019.08.14.00.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 00:47:05 -0700 (PDT)
Date:   Wed, 14 Aug 2019 09:47:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] selftests: netdevsim: add devlink params tests
Message-ID: <20190814074704.GA2580@nanopsycho.mediaserver.passengera.com>
References: <20190813130446.25712-1-jiri@resnulli.us>
 <20190813154108.30509472@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190813154108.30509472@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 14, 2019 at 12:41:08AM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 13 Aug 2019 15:04:46 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Test recently added netdevsim devlink param implementation.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>Thanks for the test, but it doesn't pass here:
>
>TEST: fw flash test                                                 [ OK ]
>TEST: params test                                                   [FAIL]
>	Failed to get test1 param value

Interesting. Fors for me correctly. When I run it manually, I get this:
bash-5.0# devlink dev param show netdevsim/netdevsim11 name test1 -j | jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
true
bash-5.0# echo $?
0
bash-5.0# devlink dev param set netdevsim/netdevsim11 name test1 cmode driverinit value false
bash-5.0# devlink dev param show netdevsim/netdevsim11 name test1 -j | jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
false
bash-5.0# echo $?
0




>
>> diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>> index 9d8baf5d14b3..858ebdc8d8a3 100755
>> --- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>> +++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
>> @@ -3,7 +3,7 @@
>>  
>>  lib_dir=$(dirname $0)/../../../net/forwarding
>>  
>> -ALL_TESTS="fw_flash_test"
>> +ALL_TESTS="fw_flash_test params_test"
>>  NUM_NETIFS=0
>>  source $lib_dir/lib.sh
>>  
>> @@ -30,6 +30,66 @@ fw_flash_test()
>>  	log_test "fw flash test"
>>  }
>>  
>> +param_get()
>> +{
>> +	local name=$1
>> +
>> +	devlink dev param show $DL_HANDLE name $name -j | \
>> +		jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
>
>                   ^^
>
>The -e makes jq set exit code to 1 when test1 param is false.
>
>Quoting the man page:
>
>       ·   -e / --exit-status:
>
>           Sets the exit status of jq to 0 if the last output values
>           was neither false nor null, 1 if the last output value was
>           either false or  null,  or  4  if  no valid  result  was
>           ever produced. Normally jq exits with 2 if there was any
>           usage problem or system error, 3 if there was a jq program
>           compile error, or 0 if the jq program ran.
>
>Without the -e all is well:

Not really, for non-existent param the return value would be wrong:
bash-5.0# devlink dev param show netdevsim/netdevsim11 name test2 -j | jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
devlink answers: Invalid argument
bash-5.0# echo $?
4
bash-5.0# devlink dev param show netdevsim/netdevsim11 name test2 -j | jq -r '.[][][].values[] | select(.cmode == "driverinit").value'
devlink answers: Invalid argument
bash-5.0# echo $?
0

The return value is 0 like everyone is fine. You probably have a
different jq version (1.6). Looks like I need to use the same
workaround I have in tools/testing/selftests/net/forwarding/tc_common.sh.
I thought that -e would avoid that.



>
># ./devlink.sh 
>TEST: fw flash test                                                 [ OK ]
>TEST: params test                                                   [ OK ]
>
>> +}
>> +
