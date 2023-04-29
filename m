Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF06F260A
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjD2TpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 15:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjD2TpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 15:45:08 -0400
Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [IPv6:2001:41d0:203:375::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547ED211C
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 12:45:03 -0700 (PDT)
Message-ID: <4c27d467-95a3-fb9a-52be-bcb54f7d1aaf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682797499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xwnRxCKNaMlUo4zgGzjZgFgFwoR96WFaYycg7X8eoYg=;
        b=PUZxle/OqIvCIYTPltO4kSqu7YYK2ni9cwLGNpXm79TER+Gu0Kozk+JbCufM8duAxg8ePs
        b/CsCdYd5M2DbkD5fHTmasFnvA4wuf9034z/Yvjg1l793DaPOIKrQwXTdh89OyMnj3aOM7
        KiU+XYhIBKAq04zXCPXqOoBUGzolV10=
Date:   Sat, 29 Apr 2023 20:44:57 +0100
MIME-Version: 1.0
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
To:     Max Georgiev <glipus@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com,
        =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>
References: <20230423032437.285014-1-glipus@gmail.com>
 <20230426165835.443259-1-kory.maincent@bootlin.com>
 <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
 <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
 <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
 <20230428101103.02a91264@kmaincent-XPS-13-7390>
 <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.04.2023 15:14, Max Georgiev wrote:
> On Fri, Apr 28, 2023 at 2:11 AM Köry Maincent <kory.maincent@bootlin.com> wrote:
>>
>> On Thu, 27 Apr 2023 22:57:27 -0600
>> Max Georgiev <glipus@gmail.com> wrote:
>>
>>> Sorry, I'm still learning the kernel patch communication rules.
>>> Thank you for guiding me here.
>>
>> Also, each Linux merging subtree can have its own rules.
>> I also, was not aware of net special merging rules:
>> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
>>
>>
>>> On Thu, Apr 27, 2023 at 2:43 AM Köry Maincent <kory.maincent@bootlin.com>
>>> wrote:
>>>>
>>>> On Wed, 26 Apr 2023 22:00:43 -0600
>>>> Max Georgiev <glipus@gmail.com> wrote:
>>>>
>>>>>
>>>>> Thank you for giving it a try!
>>>>> I'll drop the RFC tag starting from the next iteration.
>>>>
>>>> Sorry I didn't know the net-next submission rules. In fact keep the RFC tag
>>>> until net-next open again.
>>>> http://vger.kernel.org/~davem/net-next.html
>>>>
>>>> Your patch series don't appear in the cover letter thread:
>>>> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
>>>> I don't know if it comes from your e-mail or just some issue from lore but
>>>> could you check it?
>>>
>>> Could you please elaborate what's missing in the cover letter?
>>> Should the cover letter contain the latest version of the patch
>>> stack (v4, then v5, etc.) and some description of the differences
>>> between the patch versions?
>>> Let me look up some written guidance on this.
>>
>> I don't know how you send your patch series but when you look on your e-mail
>> thread the patches are not present:
>> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
>>
>> It is way easier to find your patches when you have all the patches of the
>> series in the e-mail thread.
>>
> 
> Aha, I see the problem now. I guess it has something to do with "--in-reply-to"
> git send-email optio or similar options.
> 
>> Here for example they are in the thread:
>> https://lore.kernel.org/all/20230406173308.401924-1-kory.maincent@bootlin.com/
>>
>> Do you use git send-email?
> 
> Yes, I use "git format-patch" to generate individual patch files for
> every patch in the
> stack, and then I use "git send-email" to send out these patches on-by-one.
>

The problem is, as Köry has mentioned already, in sending patches one-by-one. 
You can provide a directory with patches to git send-email and it will take all 
of them at once. You can try it with --dry-run and check that all pacthes have 
the same In-Reply-To and References headers.

> Is there a recommended way to send out stacks of patches?

