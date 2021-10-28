Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9E43E3FC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhJ1OmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhJ1OmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:42:01 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7596EC061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:39:33 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id h20so5954238qko.13
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 07:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=kPp+tweuD5Z8HFL9XQ5UWhpX1+tJaKn1jgsUrgs44zc=;
        b=VTqNmkha6trGIhKkVChvahwWLVsO4uXDBlDzZ3+cD9v2rBjlBEwCyrV7LZTNUJQaXs
         4SoA1TpKx0QE3GRz3HLsihP98NNv6GjM+u07OuNYXO6cIkmmhVafbYbxIt1OoFdkoSB/
         tfzncVx97EeoF+EbnIH0YnR8b5Bezm3QxPyCGOekJSf9OdNnDGmnHevPIa6R/MKnOjAL
         Yz/qjyQvZvKVlGPvcxCEXl0ehlYkvv3UaNZzB7ue50ufgHm4omXpVJzovLn3tO/ZN+MQ
         YGuHpWXvm9JnvknA6mOCMlEyW2VO5tSCqQmCAx5zpaqmtvtNGv0hiWh0Sh+uGrhSwtf4
         q5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=kPp+tweuD5Z8HFL9XQ5UWhpX1+tJaKn1jgsUrgs44zc=;
        b=naJSCSBcFScu5gtuFfze3GWjA8IsPeCvgJGoWKKJ0O9b/TUceaV9nXbmqKyj36RMdB
         XRfG5dZH712YPe3nwEfI94ln4xSAxhYd2MxPtGyDxRDx2gELgJG3M82faBbSWbv0n3rO
         2PBLMvvjhc/EjyT24VDrk32qCZPMwteFOfc6IBqy3htNmbxcngxEJ2o9AE9EkAMTbEw3
         zYaGu5DM5aRHfh6TNmBuSkqNA8x/ACNDmcpuD4CGw906/1jS/gC8pYGFsrd4S9P7bjOw
         MDS7S5CzXX+LwWw9wiE2Kt4ErvO9jOB5wYCj+/LIiNfKOMUOovQvU0Iqq7+xcd6lnIJP
         pNWw==
X-Gm-Message-State: AOAM530lpXNFFP3oFYbYaGpXktG2mTr2AP+1wLAuQAFAKyAH85Te2juF
        aC8/IZWuBvBEluAYkrhx/VNEcg==
X-Google-Smtp-Source: ABdhPJx3Q4csL2Yyu6Px/xkZ4LSOjQMLn+Z2Zc/tUQpfGsgSR5x8a8IXCXPZZ19+iEMVcPRPLCQU4g==
X-Received: by 2002:a37:8906:: with SMTP id l6mr3944102qkd.210.1635431972733;
        Thu, 28 Oct 2021 07:39:32 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id bp40sm2089916qkb.114.2021.10.28.07.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 07:39:32 -0700 (PDT)
Message-ID: <b5518df7-b6d7-d2ab-38fe-2ec4fc1977c8@mojatatu.com>
Date:   Thu, 28 Oct 2021 10:39:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <e3d4ac96-1d21-bfdd-36b5-571e7c0e7fa8@mojatatu.com>
In-Reply-To: <e3d4ac96-1d21-bfdd-36b5-571e7c0e7fa8@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-28 10:23, Jamal Hadi Salim wrote:
[..]
> 
> It will be helpful to display the output of the show commands in the
> cover letter....

Also some tdc tests please...

cheers,
jamal

