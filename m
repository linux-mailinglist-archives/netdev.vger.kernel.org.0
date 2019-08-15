Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3DCA8E4A7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 07:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfHOF6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 01:58:33 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:36127 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbfHOF6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 01:58:32 -0400
Received: by mail-wr1-f51.google.com with SMTP id r3so1222787wrt.3
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 22:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DwduM7skV+vfoPd0Ax9UH/0qZWnTkMh4Rd/1rEUWmVY=;
        b=z9Pkj67Tu9cL9eLgLYW27deoyxEJprU8t+R8JTCCRXRGKvNeDA9NB0B6hZxgDS8Me+
         hlHmgqGnlMnskYzzoZg5f5dCRRoEa6Dr1Rv/WyNFDKEsgfYTnni4T0gCMb4iC9o4oVDZ
         ocGm49FNPGxTfTmPwME6KeTEzooy60daXY0ve89hjJY2CpRDGadJdf7FMbHeKnlniEOi
         nCJnJ1z63rmywZh6zV3NRb0a73a/HIwKX+t34sZhbBtQRzqOh4+BQftIZ2Vs9XoNh8N4
         94dEFi7hBnPUGoC/dcS8B4ICaP2QPjtGGlTmUIbvfCfLJ1EESmgrMJW96q3QGM4s1evy
         P6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DwduM7skV+vfoPd0Ax9UH/0qZWnTkMh4Rd/1rEUWmVY=;
        b=UBnmxGtRtUkWrXM0aXas29ZiAegt9TCr1QwjsSQqeo9Ayq+MJmPCGiptP2RHNkJaN9
         qo9vXFjreofk4bvvqkG3UqigAl8/iae2TvpcZU7lQsztEdwgAlHMMsgDKX18zO1PbrWF
         ZapxubactMsdPq/WocCpAv2yQ1Wc3PpY/fhKq2A4zrt8SUwxZXj4Y/yrnMJhsP7bSWfQ
         7iSJlV4bjwTOaCo/Q35ilK3SEw8/ZbtKX8UvNVQlRXIQwKxvpg/TNJUNvArtR8+1MWfP
         yaO1jsq2m4TXqhEy6+bsChDucRZV70TTK4iAT2LH1GtDeYHDfE3RzJ48/+lRdG6wtIq3
         marg==
X-Gm-Message-State: APjAAAXs9KaAaVeISZ7PjjHFoUzLyVLC3Lg3KlDB/T7G0SePAnz6S1hN
        1aCrAnpNa0KTVHV7qavpLlPDJGEloMU=
X-Google-Smtp-Source: APXvYqyUXq2RldmZvWayuxQjZqPxkdqc9g1pFJRWb5DCpKkj1EqfXcRLENfGq0XlrkK4Iu83spZr/A==
X-Received: by 2002:adf:e887:: with SMTP id d7mr3380717wrm.282.1565848710756;
        Wed, 14 Aug 2019 22:58:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o14sm755356wrg.64.2019.08.14.22.58.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 22:58:29 -0700 (PDT)
Date:   Thu, 15 Aug 2019 07:58:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/2] selftests: netdevsim: add devlink params
 tests
Message-ID: <20190815055829.GA2273@nanopsycho>
References: <20190814152604.6385-1-jiri@resnulli.us>
 <20190814152604.6385-3-jiri@resnulli.us>
 <20190814180900.71712d88@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814180900.71712d88@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 15, 2019 at 03:09:00AM CEST, jakub.kicinski@netronome.com wrote:
>On Wed, 14 Aug 2019 17:26:04 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Test recently added netdevsim devlink param implementation.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> v1->v2:
>> -using cmd_jq helper
>
>Still failing here :(

Ugh :/

>
># ./devlink.sh 
>TEST: fw flash test                                                 [ OK ]
>TEST: params test                                                   [FAIL]
>	Failed to get test1 param value
>TEST: regions test                                                  [ OK ]
>
># jq --version
>jq-1.5-1-a5b5cbe
># echo '{ "a" : false }' | jq -e -r '.[]'
>false
># echo $?
>1
>
>On another machine:
>
>$ echo '{ "a" : false }' | jq -e -r '.[]'
>false
>$ echo $?
>1
>
>Did you mean to drop the -e ?

No. -e is needed in order to jq return error in case there is no output.
Looks like a bug in jq 1.6 fixed. How about I add a check for jq >= 1.6?
