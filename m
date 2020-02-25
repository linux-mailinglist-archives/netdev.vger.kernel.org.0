Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399A516BB30
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgBYHqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:46:06 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40234 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgBYHqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:46:06 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so13422496wru.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 23:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HaCf8ju6+9uNDhhwgsR+7owEeD/A7pubs4p/KrqXW7w=;
        b=Rbgl6DGc29ep6e3jOlUjpHe+hFkWtrmj3/q2/K7E6XRL4Xv1MaLPPA73SkSLRsVSLq
         EOND6HpkYXY+GsYzpbyRpRTkHa5Otl5T0yip0GNUY0ulkbNp3Q50Du1/0cq8Fu7NorrU
         YP2ATGc/+Nc1iCVit+TzxnVbJRrc3L2loUsH8hfvEOHjB7tCgXYo6r6WVa1wXBuQ2aD8
         MN5jYcQEGJXpaLS5074Q5sXvaAUU+R1zYXLvQ4Vr1SU0IrvzAxL2nT3g9rbXyYC8ZihN
         BITaWjaBXY+EoHtD0yO6oEwi5eYtaMaQMs0o+LrEuu6JBI4csQNNuUenev0SWtS66PRp
         h6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HaCf8ju6+9uNDhhwgsR+7owEeD/A7pubs4p/KrqXW7w=;
        b=EuQc6UYE/LwniftNddfp7LmH082wXwL1PBt5fIVJoQKDjRhauGenL63+7LnCxPyFjd
         sCdroyS5gAWUenrcptTuvpc7y90AbS561CokbgpOQzef6v7dazCTsrpS+L8kfgRmxQb0
         qi2EEGcfWYj9gOdb5DW+uMXerSAsmXOWo8ByJxzGE/RwmOX4Ve9bFwbvX3tlXG9kXYkL
         1+jzQrXcOmfwwMrZsvlSrKRnxkp0XNRUzg7GqUfYnYdjI8UylWzZ9Uaow89AJIAtGPrU
         C+ayRTFC603oat/4XpXoJLG2JNxx7RS4/naxd2/EKRPHhfNFrsEnDAs18xdNkzhG4usy
         aBLQ==
X-Gm-Message-State: APjAAAWXotRsfWp9a1UwLosQ3tMPEfUtqE7A67XSP/uh8v1mwcVJEznJ
        qHXbStGR5vlQe3ATCtLfmQc/vQ==
X-Google-Smtp-Source: APXvYqyhW+mhVvvYFLSjzPmOyX20qIvYzJ3Q2WyndF77lmeQftPgNdfHEnkeBPRYkkrH7daGkO9viw==
X-Received: by 2002:a5d:514b:: with SMTP id u11mr70906445wrt.322.1582616765065;
        Mon, 24 Feb 2020 23:46:05 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id l6sm24061472wrn.26.2020.02.24.23.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 23:46:04 -0800 (PST)
Date:   Tue, 25 Feb 2020 08:46:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 10/10] selftests: netdevsim: Extend devlink trap
 test to include flow action cookie
Message-ID: <20200225074603.GC17869@nanopsycho>
References: <20200224210758.18481-1-jiri@resnulli.us>
 <20200224210758.18481-11-jiri@resnulli.us>
 <20200224204332.1e126fb4@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224204332.1e126fb4@cakuba.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 05:43:32AM CET, kuba@kernel.org wrote:
>On Mon, 24 Feb 2020 22:07:58 +0100, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Extend existing devlink trap test to include metadata type for flow
>> action cookie.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>> ---
>>  .../testing/selftests/drivers/net/netdevsim/devlink_trap.sh  | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
>> index f101ab9441e2..437d32bd4cfd 100755
>> --- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
>> +++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
>> @@ -103,6 +103,11 @@ trap_metadata_test()
>>  	for trap_name in $(devlink_traps_get); do
>>  		devlink_trap_metadata_test $trap_name "input_port"
>>  		check_err $? "Input port not reported as metadata of trap $trap_name"
>> +		if [ $trap_name == "ingress_flow_action_drop" ] ||
>> +		   [ $trap_name == "egress_flow_action_drop" ]; then
>> +			devlink_trap_metadata_test $trap_name "flow_action_cookie"
>> +			check_err $? "Flow action cookie not reported as metadata of trap $trap_name"
>> +		fi
>>  	done
>>  
>>  	log_test "Trap metadata"
>
>Oh, this doesn't seem to check the contents of the trap at all, does it?

No. This is not the test for the actual trapped packets. It is a test to
list devlink traps and supported metadata.

The packet trapping is done using dropmonitor which is currently
not implemented in selftests, even for the existing traps. Not even for
mlxsw. There is a plan to introduce these tests in the future, Ido is
working on a tool to catch those packets to pcap using dropmon. I think
he plans to send it to dropmon git soon. Then we can implement the
selftests using it.
