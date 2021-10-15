Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC9C42EE3F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhJOKBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:01:47 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54882 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234825AbhJOKBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 06:01:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Us8GlL2_1634291969;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Us8GlL2_1634291969)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 17:59:30 +0800
Subject: Re: [PATCH] selftests/tls: add SM4 GCM/CCM to tls selftests
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
 <YWk9ruGFxRA/1On6@Laptop-X1>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <cf53cf98-354f-f993-4b55-ff22dcc0d92d@linux.alibaba.com>
Date:   Fri, 15 Oct 2021 17:59:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWk9ruGFxRA/1On6@Laptop-X1>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

On 10/15/21 4:37 PM, Hangbin Liu wrote:
> Hi Tianjia,
> 
> The new added tls selftest failed with latest net-next in RedHat CKI
> test env. Would you like to help check if we missed anything?
> 
> Here is the pipeline page
> https://datawarehouse.cki-project.org/kcidb/builds/67720
> Config URL:
> http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/10/14/388570846/redhat:388570846/redhat:388570846_x86_64_debug/.config
> Build Log URL:
> http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/10/14/388570846/redhat:388570846/redhat:388570846_x86_64_debug/build.log
> TLS test log:
> https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2021/10/14/redhat:388570846/build_x86_64_redhat:388570846_x86_64_debug/tests/1/results_0001/job.01/recipes/10799149/tasks/19/results/1634231959/logs/resultoutputfile.log
> Command: make -j24 INSTALL_MOD_STRIP=1 targz-pkg
> Architecture: x86_64
> 
> Please tell me if you need any other info.
> 
> Thanks
> Hangbin
> 

This patch needs to enable the SM4 algorithm, and the config file you 
provided does not enable this algorithm.

Best regards,
Tianjia
