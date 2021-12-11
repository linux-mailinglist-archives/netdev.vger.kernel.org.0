Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E7D4715D2
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhLKTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbhLKTyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:54:22 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2B3C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:54:22 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id g9so11010969qvd.2
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 11:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QzUnj0ZwqVKTphVFnI0n/GuvM3ZhghoUXZY5BlSYjdU=;
        b=F5cyl/flGS/LyHu2NgIvRKweo57EnQtALAoRq4eQKMRpOyYAu2j0HTOflT+Yl9nECN
         GbmR26WRZq+kEmeccgZmOAKNgza4PW2dDBvTcjw4JnnpsQYHt1kcZMFkpsv42xF4pIrm
         QxuMIbWTcEWZNcdKsf3mLOV3RsyK+4GS+7t7M3olSWytfD+M4ub2FRT+wsIfOHWrDW38
         KW7gpyvjfX0INLPL9FDHZ1G/0yQfhWmqm07ysv9uxzO/+8PcdP1uzZf4VbG1ziLNuN7K
         sfH7LzwTOJcErTcTixeWDxKgF1GF/enQbsy+HMNoFo09zwjpebzuitUlJaAOCIGJgom5
         ERZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QzUnj0ZwqVKTphVFnI0n/GuvM3ZhghoUXZY5BlSYjdU=;
        b=NjLoIrye4KDpNkfwpM5WJ2SPOOPG4Y7LaovPG+h1MKKfh8I/pztNuh4KrjwvcjlCMW
         csEnnapxv56p1AMAVH4J5NlI/nepItVJZCZpZeX74NsYnni1q2zMhNi02ZLrUkQmHU75
         xzFasCCD2N08nGKB6xlmMjybV2vnIh6aathtE5XJHC1BecWOJGXb3vn0Dc4m+Ua7qpxF
         njCn3hxhzFjglEhvx0BYyYZfHI1e0cIJCsfFejt3GCkHe3EK870X1WPF9qLgMg7iY8qQ
         ldWOB+9QXerJP+kOYA92Zz/HS5CSJcF08GkEK+rGVZ509+eiRO3NRSoie6aAlM3aHAAE
         C13w==
X-Gm-Message-State: AOAM533ZKvDzO7Chz9hH71ofyNFYui9Nvv0NHEeaT16nvsdlcFImOXz7
        ujygSzxWZVfIEclr5910wE7e1g==
X-Google-Smtp-Source: ABdhPJwnhvvbJdxnxIyoQIQtjmpsn38Q89Qf8GNIoZn4eVFfBWF1EMYN9kk7XjFMaDsotjprWZxwew==
X-Received: by 2002:a05:6214:e65:: with SMTP id jz5mr33679774qvb.116.1639252461742;
        Sat, 11 Dec 2021 11:54:21 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id w10sm5077872qtk.90.2021.12.11.11.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Dec 2021 11:54:21 -0800 (PST)
Message-ID: <a919f40f-8c13-e843-c7cd-d286dc157b61@mojatatu.com>
Date:   Sat, 11 Dec 2021 14:54:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v6 net-next 09/12] net: sched: save full flags for tc
 action
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-10-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211209092806.12336-10-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 04:28, Simon Horman wrote:
> From: Baowen Zheng<baowen.zheng@corigine.com>
> 
> Save full action flags and return user flags when return flags to
> user space.
> 
> Save full action flags to distinguish if the action is created
> independent from classifier.
> 
> We made this change mainly for further patch to reoffload tc actions.
> 
> Signed-off-by: Baowen Zheng<baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman<simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
