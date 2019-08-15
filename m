Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC468E731
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfHOIpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 04:45:49 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:37121 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfHOIpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 04:45:49 -0400
Received: by mail-wm1-f46.google.com with SMTP id z23so651198wmf.2
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 01:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u/AfR7B3ccuYUEJoaq5VE908KglTJ8XvBm6blFqWt5A=;
        b=QB0yfyOeveaGr4iJLh298nK68PhBHuUWtBXblTs7Jo+72ELFmlbcX1OGq4Ukvp+xho
         6/dUeBbWwEosZ61zmfYViY3XbO8r98u37qkcqohyX5YwbU1z6eumwasVrxbL9sOef6Lh
         pstd0jvZJw6yBOhGSQeDAv/0EQeYG14UtpfSiDOe12X1+Kqy60sJEOQhhZGV+cbzE8y1
         XYqOCl3SbJtK5LW3iNHr8y9rgaYVD6RLYPFFaFMtId1i80B4TojylrBfOfFxDbKRJLgn
         kCP9dctuswMb4jRBUh4aBOUawQssX7SmvwX5LZh93w25Lhdy8PXxCSVTtmhFK6dZDhG7
         umJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u/AfR7B3ccuYUEJoaq5VE908KglTJ8XvBm6blFqWt5A=;
        b=S3xfNW7u64GFcDzwSxmlkIS9z0L+Gmf1F/4sDsOK3Ngi2Yf8e4Aib8dHp3BM4hMKrc
         UkFITbWM/Xo/gSbTmiWoDcg1VXUz/DU6MuyyGpDE4J1yONbvpiUTyYDzjLjq5xYnt7X6
         PCV9XVd3qd+F2AhV87scc4j00mE0+cOkbLhUWvS820R/qm8K6Hxx79HcUQh3iqWNXms8
         OcbjFLLZzFrFk/n41ZtBQZ6YaU7HcxdCnovJdVaoE5Cm1v58cf/hUGJ2z0lQisBR+EX5
         MX2XMAzlhLmW9qLUBAQ5nbZ8CUNJuNS+ixrjD0wP1Tm1U0g+BYR84CQE8E63nsbwIhuq
         EV/A==
X-Gm-Message-State: APjAAAVBYxChvThQF9r8SGNuc/a5wAkboUFwFxw038RtpUCRJ9KNWnGC
        6mD+DqXoob1JINMmOnkHI0ZkbUgcGiY=
X-Google-Smtp-Source: APXvYqw/jjSAQi23cyc9+nnMFp5ocDy90kxo1dv79K6d431uEAk/3CBD/hw1uBadk+Xi3/M8qjcQIQ==
X-Received: by 2002:a7b:c753:: with SMTP id w19mr1584015wmk.91.1565858746521;
        Thu, 15 Aug 2019 01:45:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p186sm804235wme.9.2019.08.15.01.45.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 01:45:46 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:45:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 2/2] selftests: netdevsim: add devlink params
 tests
Message-ID: <20190815084545.GB2273@nanopsycho>
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

Odd, could you please try:
$ jq --version
jq-1.5
$ echo '{"param":{"netdevsim/netdevsim11":[{"name":"test1","type":"driver-specific","values":[{"cmode":"driverinit","value":"false"}]}]}}' | jq -e -r '.[][][].values[] | select(.cmode == "driverinit").value'
false
$ echo $?
0


>
>On another machine:
>
>$ echo '{ "a" : false }' | jq -e -r '.[]'
>false
>$ echo $?
>1
>
>Did you mean to drop the -e ?
