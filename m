Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B02A36859D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238183AbhDVRNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:13:14 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:44849 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVRNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:13:12 -0400
Received: by mail-pg1-f180.google.com with SMTP id y32so33280833pga.11;
        Thu, 22 Apr 2021 10:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oL0/WcnCbHxL1yJ51DUfiDMDBwIuiDipc8mvrh5ow+4=;
        b=byXLXSL5+xLBTGrqnQfcZrqYoIoPEiv3qjTNvx0an3iusFSg3FU+jWvxR3F+84R3Jh
         8ZwMCRrCj2oVEq30KRKEzblaPgdbmtuwgiBfiyhihwTenoHO3el164ifAUmo72KSdZ5R
         Xc7bE4Z+yCA5HdkEb25JRPezqNOeEIFBD9lfg7PUWTXK1JeB8Gi+l2hBMNLxNh6I+a5u
         OrG7QtBysFfXdiO1Hiw2o6nP+JrAK3FoTm4B0EIv+2/JLCy2eE83doczAoEWg7S9SNtk
         HPnu3LjRAvrzloySHKmMAR4UcFfNyGWog9xowhtwgc39QfFp6zMYcUDnt7IDG7mBb+XW
         B0pA==
X-Gm-Message-State: AOAM5337ZXE3K1W6EvyALR8MyFxfj3/P9yBfi33UcGObFsZJIDsCRXc2
        n6GxpmoYDVK70pxAMBIrRUXtkpYwZEM+TQ==
X-Google-Smtp-Source: ABdhPJypCeQEUKOtXrXBs8b2viAjaw3NbuX4UaVGriFcAl0iIo1zShVEQ8SfJJXuVETEvTpPJA0zpw==
X-Received: by 2002:a63:2c14:: with SMTP id s20mr4415277pgs.72.1619111555663;
        Thu, 22 Apr 2021 10:12:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:ca3e:c761:2ef0:61cd? ([2601:647:4000:d7:ca3e:c761:2ef0:61cd])
        by smtp.gmail.com with ESMTPSA id l18sm5098991pjq.33.2021.04.22.10.12.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 10:12:34 -0700 (PDT)
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Marion et Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
 <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
 <1032428026.331.1618814178946.JavaMail.www@wwinf2229>
 <40c21bfe-e304-230d-b319-b98063347b8b@acm.org>
 <20210422122419.GF2047089@ziepe.ca>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <782e329a-7c3f-a0da-5d2f-89871b0c4b9b@acm.org>
Date:   Thu, 22 Apr 2021 10:12:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422122419.GF2047089@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/21 5:24 AM, Jason Gunthorpe wrote:
> On Mon, Apr 19, 2021 at 01:02:34PM -0700, Bart Van Assche wrote:
>> On 4/18/21 11:36 PM, Marion et Christophe JAILLET wrote:
>>> The list in To: is the one given by get_maintainer.pl. Usualy, I only
>>> put the ML in Cc: I've run the script on the 2 patches of the serie
>>> and merged the 2 lists. Everyone is in the To: of the cover letter
>>> and of the 2 patches.
>>>
>>> If Théo is "Tejun Heo" (  (maintainer:WORKQUEUE) ), he is already in
>>> the To: line.
>> Linus wants to see a "Cc: ${maintainer}" tag in patches that he receives
>> from a maintainer and that modify another subsystem than the subsystem
>> maintained by that maintainer.
> 
> Really? Do you remember a lore link for this?

Last time I saw Linus mentioning this was a few months ago.
Unfortunately I cannot find that message anymore.

> Generally I've been junking the CC lines (vs Andrew at the other
> extreme that often has 10's of CC lines)

Most entries in the MAINTAINERS file have one to three email addresses
so I'm surprised to read that Cc-ing maintainer(s) could result in tens
of Cc lines?

Thanks,

Bart.
