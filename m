Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D5F16F892
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgBZHem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:34:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40898 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgBZHem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:34:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id t3so1642743wru.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 23:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KKvQDSMKmlOxfHSTnIGVb6ns63OWcc76lfWq2snJrSY=;
        b=grng1kWooZofkMSpnSOBcsqP5vAhxp1Xf3LO/bdkdC7XAnL29fI3x3hhBqkQrjERI1
         tizX3z9n82G4jD5bJKotSHnSqLJNLm+zPsU/iy9gROJ92f4sYxSkiEYZnP9OP6fr/L5t
         2xT5crHd5qXHNHFUU6nwOibwWtR+z7EI+95v+MtfeTawWclZlNb1cAlo7iivM4QdMiJL
         we/XKsSDTROCy0ER/0eJV5VBYixUH8G/Bu/G98jHc9Xb7VED8m79jhPPafGz8FGgAiHV
         9NJSVKSC613hc/BgqYFQ2oZrJthbZCd3Xyp/TElm3J0I3mWF4wCILHm0ob785W5CAZhN
         Y1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KKvQDSMKmlOxfHSTnIGVb6ns63OWcc76lfWq2snJrSY=;
        b=ASGZFMww5bPvV21qooKktCKSkxS5AJb91utJ2GiBEzlqgkt3hYYZNklwtHTBwuZXMM
         yGG1lCHKnM6Nr57UTbhlzvAGbM4OiAZSlSpcszioH9562zzLGO4tkpSzaa764VchN6Gx
         1ro2zajRWcP6Q+Xa63FyPEGiEIBhScUYCudDIqdhyJFQH6k40H9uH2Pz85prs4f8Ed7i
         sMpJq3poTviXL1AOvhcNlnSa/rczfhguzhoiLukLn4IS9Ulq8gvgQtwvrQKew11jR1rQ
         cW2Aeug7cevuiNxAVEidEVk7Fml9yszycSYcTVQ9BrjYd8Q06tUyORhUJ1F4TlaKUGDO
         ig9Q==
X-Gm-Message-State: APjAAAU/O8nfOGkzp24oPiGVi/i31R4+BTVfiuwXb9K1187dhzOin4+W
        hzy54ISLZnvXStnQir9/FcdGAQ==
X-Google-Smtp-Source: APXvYqzeHYeB9Rp+sgCM2lTWwcw4Dy+fg0WOvuQgkOoxyskFdYMlwsPUStYHampiJncUp8/d1R3feQ==
X-Received: by 2002:a5d:604c:: with SMTP id j12mr3710552wrt.162.1582702480823;
        Tue, 25 Feb 2020 23:34:40 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c141sm1685337wme.41.2020.02.25.23.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 23:34:40 -0800 (PST)
Date:   Wed, 26 Feb 2020 08:34:39 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 10/10] selftests: netdevsim: Extend devlink trap
 test to include flow action cookie
Message-ID: <20200226073439.GA10533@nanopsycho>
References: <20200224210758.18481-1-jiri@resnulli.us>
 <20200224210758.18481-11-jiri@resnulli.us>
 <20200224204332.1e126fb4@cakuba.hsd1.ca.comcast.net>
 <20200225074603.GC17869@nanopsycho>
 <20200225095721.657095ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225095721.657095ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 06:57:21PM CET, kuba@kernel.org wrote:
>On Tue, 25 Feb 2020 08:46:03 +0100 Jiri Pirko wrote:
>> >>  		devlink_trap_metadata_test $trap_name "input_port"
>> >>  		check_err $? "Input port not reported as metadata of trap $trap_name"
>> >> +		if [ $trap_name == "ingress_flow_action_drop" ] ||
>> >> +		   [ $trap_name == "egress_flow_action_drop" ]; then
>> >> +			devlink_trap_metadata_test $trap_name "flow_action_cookie"
>> >> +			check_err $? "Flow action cookie not reported as metadata of trap $trap_name"
>> >> +		fi
>> >>  	done
>> >>  
>> >>  	log_test "Trap metadata"  
>> >
>> >Oh, this doesn't seem to check the contents of the trap at all, does it?  
>> 
>> No. This is not the test for the actual trapped packets. It is a test to
>> list devlink traps and supported metadata.
>> 
>> The packet trapping is done using dropmonitor which is currently
>> not implemented in selftests, even for the existing traps. Not even for
>> mlxsw. There is a plan to introduce these tests in the future, Ido is
>> working on a tool to catch those packets to pcap using dropmon. I think
>> he plans to send it to dropmon git soon. Then we can implement the
>> selftests using it.
>
>The extra 100 lines of code in netdevsim which is not used by selftests
>does make me a little sad.. but okay, looking forward to fuller tests.
>Those tests better make use of the variable cookie size, 'cause
>otherwise we could have just stored the cookie on a u64 and avoided the
>custom read/write functions all together ;)

Will do.

