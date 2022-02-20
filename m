Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782854BD2D9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 01:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbiBTXzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 18:55:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiBTXzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 18:55:08 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E45C32068
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 15:54:46 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id c14so27578089qvl.12
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 15:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metztli-com.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yBtrNN4uwfJ+1WgOoVnh2SfdtEspt8o9QO0g209UjmY=;
        b=VF9laxAtGRyFoFwElqZsKNI1hF59lCPOR/3Ikf7qnGihPh3gyq1ouqU/6Fh0b6polE
         nUH1c2BSVfvugzv7y+5Wfo1aop+s9TfUcrWaRlqDBCH4Q16WmaTHMNVlcqOJGwrTBKxo
         gsGhiErk0k/0PIWqs4/wUVUWclA0k8y67f4KQTyei9Rolp522u2a44A9EJa2uVUveE9X
         dJuotIyy/CZAOAHKLWyXiOazGwJ0+/1KVE+eSZLGk9ztB0x8AOZHuOUWv4H/dKra7hF7
         NJYHMj2M9kzzKLiW01ZtcVfk0Y9TlXRYSU5SYhzqgiWgjuBetE9JryBUe3M2ldn2jFVZ
         55zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yBtrNN4uwfJ+1WgOoVnh2SfdtEspt8o9QO0g209UjmY=;
        b=vTTeKkJ5OHZ7+n5VrhiCpC1ppVDuzucY6neDXp9ZUVVJbAhX5+SImdQBIC4/1MA5w8
         /Szy0JHy4QtJhFYgLeseJPIkM3XuxUnjw29PoY5NVV83RcIj3YwW54kTkdvBaSyCVIEc
         pjtB8DdFZBhcrVN28Qx18qP1Qc/0IBzbhFmW555wwF++ZF0+tdZ618COKBPjAV6DPz0M
         1WfV0nreVuBOUvKMUgmqRuEoSd0T/zPWSQzK27A+VUFK4UEwfN3LQwQXZ0pGhhVBpo5q
         MpvcIW6oDxrUMKTMN8ZOw/vhnH01cjsncJ60rRpGixyKHuSJUCSFCxwhFMUzjKEufsjv
         NJYQ==
X-Gm-Message-State: AOAM532vPb9p+oahk7poVY8BCIqtmXK8c00S8GUZF17UB3u6H02xHM+y
        IllR9Axpf2pVFN61Qc3tYE7N2Q==
X-Google-Smtp-Source: ABdhPJwH1S4G3mxDPEpKrEN9Ap/+mHmV/xA7ngfiUYeJjX9kzArkAPAp6pHfrf28w+oViIWZE9C35w==
X-Received: by 2002:a05:622a:174b:b0:2de:23d5:4d15 with SMTP id l11-20020a05622a174b00b002de23d54d15mr2636602qtk.475.1645401285288;
        Sun, 20 Feb 2022 15:54:45 -0800 (PST)
Received: from ?IPv6:2600:1700:6470:27a0:4e80:93ff:fe00:3ff7? ([2600:1700:6470:27a0:4e80:93ff:fe00:3ff7])
        by smtp.gmail.com with ESMTPSA id z17sm29443385qta.11.2022.02.20.15.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Feb 2022 15:54:44 -0800 (PST)
From:   Metztli Information Technology <jose.r.r@metztli.com>
Subject: Re: Unsubscription Incident
To:     Slade Watkins <slade@sladewatkins.com>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Edward Shishkin <edward.shishkin@gmail.com>,
        ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        vbox-dev@virtualbox.org
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
 <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
 <CA+pv=HOTQUzd0EYCuunC9AUPOVLEu6htyhNwiUB1fTjhUHsN5Q@mail.gmail.com>
Message-ID: <61892434-1007-1aa0-f686-d66409550c84@metztli.com>
Date:   Sun, 20 Feb 2022 15:54:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CA+pv=HOTQUzd0EYCuunC9AUPOVLEu6htyhNwiUB1fTjhUHsN5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, Oct 25, 2021 at 1:14 PM Slade Watkins <slade@sladewatkins.com> 
wrote:
>
> On Mon, Oct 25, 2021 at 2:34 PM Shannon Nelson <snelson@pensando.io> wrote:
> >
> > On 10/25/21 10:04 AM, Slade Watkins wrote:
> > > On Mon, Oct 25, 2021 at 12:43 AM Benjamin Poirier
> > > <benjamin.poirier@gmail.com> wrote:
> > >> On 2021-10-22 18:54 +0300, Vladimir Oltean wrote:
> > >>> On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
> > >>>> Hi,
> > >>>>
> > >>>>  From Oct 11, I did not receive any emails from both linux-kernel and
> > >>>> netdev mailing list. Did anyone encounter the same issue? I subscribed
> > >>>> again and I can receive incoming emails now. However, I figured out
> > >>>> that anyone can unsubscribe your email without authentication. Maybe
> > >>>> it is just a one-time issue that someone accidentally unsubscribed my
> > >>>> email. But I would recommend that our admin can add one more
> > >>>> authentication step before unsubscription to make the process more
> > >>>> secure.
> > >>>>
> > >>>> Thanks,
> > >>>> Lijun
> > >>> Yes, the exact same thing happened to me. I got unsubscribed from all
> > >>> vger mailing lists.
> > >> It happened to a bunch of people on gmail:
> > >> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
> > > I can at least confirm that this didn't happen to me on my hosted
> > > Gmail through Google Workspace. Could be wrong, but it seems isolated
> > > to normal @gmail.com accounts.
> > >
> > > Best,
> > >               -slade
> >
> > Alternatively, I can confirm that my pensando.io address through gmail
> > was affected until I re-subscribed.
>
> Hm. Must be a hit or miss thing, then.
>
> > sln
> >
> >
> >
>
>              -slade

Well, it seems it is making the rounds in 2022. I have not received an 
email from Linux Kernel Mailing List <linux-kernel@vger.kernel.org> (and 
neither the Virtual Box developers mailing list
< 
https://www.virtualbox.org/pipermail/vbox-dev/2022-February/015710.html 
 > ) since sometime within Jan. 26, 2022, to the present; hence, I 
assume somebody (or some skiddie) unsubscribed me.

  The last Jan. 26, 2022, email I sent to the list also included the 
reiser4 developer as an addressee -- as I have experienced some issues 
with newer kernels (and thought someone else might even provide a hint).
< https://lkml.org/lkml/2022/1/26/204 >

Apropos (off-topic, sorry, yet if this email makes it to the Linux 
kernel mailing list and other developers know him), I am somewhat 
concerned about Mr. Shiskin's well being  -- as his continued Reiser4 
work for the Linux kernel is appreciated by at least those of us who -- 
in stark contrast to 'the chosen ones' -- we do not pretend to be 
morally superior to judge and pontificate to others.

Last reiser4 patch (hack) that is working decently for me:
< https://metztli.it/bullseye/reiser4-ryzen.png >

I will resubscribe to Linux Kernel Mailing List 
<linux-kernel@vger.kernel.org>; unless, of course, I have been placed on 
a black list by the Penguins and/or their 'morally virtuous' 
govt/corporate overlords ;-)


Best Professional Regards.

-- 
Jose R R
http://metztli.it
---------------------------------------------------------------------------------------------
Download Metztli Reiser4: Debian Bullseye w/ Linux 5.14.21 AMD64
---------------------------------------------------------------------------------------------
feats ZSTD compression https://sf.net/projects/metztli-reiser4/
---------------------------------------------------------------------------------------------
or SFRN 5.1.3, Metztli Reiser5 https://sf.net/projects/debian-reiser4/
-------------------------------------------------------------------------------------------
Official current Reiser4 resources: https://reiser4.wiki.kernel.org/
