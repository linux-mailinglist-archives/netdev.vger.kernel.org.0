Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F64C2C284A
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388480AbgKXNjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388458AbgKXNjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 08:39:52 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA99C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 05:39:52 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id y197so20360685qkb.7
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 05:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GP21IJsDORO/UhQuJ86Tit3EECgFhxCu9MPnh4Hlq84=;
        b=sVagsh6ZY6+PvkBAGRYVr2bWHTJYMG9VUDgNoONQNptmFKJCQy5KTdGL7/ufh+KU4I
         0lmrJUs3SLpQn2S3+2r6V/k9WYDwl3bmqdGQ+NIP+kKpwrRijNcusm3eB8PRCQ/Gs1lN
         aWoDnf8Mi8Nf4b5ZBiC6QOuOmWjijM8wPkurflk9I01Xxq+w7vAYpvqwrLKEgD9PMxpf
         i18cr/Wf+19hikxaXZyA9q2rIuk+2YjyhPUfv5C7FGhIK8j1vE1pVKhxET5JwyMV6Was
         abH+OOJG82yZjV67RhsXdAYT4iQwXeHCgdD0TMfBEKmWhb2ZrlY1Wm0AF1GkMQUPuUxr
         JtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GP21IJsDORO/UhQuJ86Tit3EECgFhxCu9MPnh4Hlq84=;
        b=KZIwESGpoUiuSSZHskno9rsRgxozFkCHMfWJjA02MwkCsvDGsugQnPWodVZAJsiB78
         ETinO07k01IXhdZyeLixpazdnZ1XIXbe4Qi068ss4OxSm1XtTETf7iiswg90vRghMwvs
         2W6NxIxB4bHIOSwU+UoPs3my2jymcT8DNSozNlZ9obnC9b4mfSPQjxtvKAt9sFRad2zX
         VYrABn55Z7Ct9lr1ILN2UVoGbCyC7ZPNuNrWe8E597aUnODNoZWlFTB9KDc+9bvKdxw2
         y1A8E4T0ciC4Oh3YMCjEGRz+XG/JE8urLSpYVFidJMY87h+8iLNY2MsMLAEkgfb6+w/W
         wY9Q==
X-Gm-Message-State: AOAM532wPfvCzzC10fJHEIYGL1zEV4o6GV+AwaUCR3pobduqKcB6xYL0
        MN8yU0XalK9QSxf+esv48DidNA==
X-Google-Smtp-Source: ABdhPJxQwefpw3KqRsbOl3m+vTfL/58Z9UfeXHmU5Rbj9WHROTt3hifWJHVyh5Pc6TDcoBNSBlx4+Q==
X-Received: by 2002:ae9:ed0f:: with SMTP id c15mr4904630qkg.348.1606225189628;
        Tue, 24 Nov 2020 05:39:49 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id v32sm13505181qtb.42.2020.11.24.05.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 05:39:48 -0800 (PST)
Subject: Re: [PATCH net-next] net: sched: alias action flags with TCA_ACT_
 prefix
To:     Vlad Buslov <vlad@buslov.dev>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <20201121160902.808705-1-vlad@buslov.dev>
 <20201123132244.55768678@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87v9dv9k8q.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <d1167677-c813-35d2-144a-2246dcf8fd59@mojatatu.com>
Date:   Tue, 24 Nov 2020 08:39:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <87v9dv9k8q.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-24 4:28 a.m., Vlad Buslov wrote:
> On Mon 23 Nov 2020 at 23:22, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Sat, 21 Nov 2020 18:09:02 +0200 Vlad Buslov wrote:
>>> Currently both filter and action flags use same "TCA_" prefix which makes
>>> them hard to distinguish to code and confusing for users. Create aliases
>>> for existing action flags constants with "TCA_ACT_" prefix.
>>>
>>> Signed-off-by: Vlad Buslov <vlad@buslov.dev>
>>
>> Are we expecting to add both aliases for all new flags?
> 
> I don't think it makes sense to have both aliases for any new flags.
> 

Agreed.

cheers,
jamal
