Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD493AC614
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbhFRIa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhFRIa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:30:57 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55DDC061574;
        Fri, 18 Jun 2021 01:28:48 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id w31so7204939pga.6;
        Fri, 18 Jun 2021 01:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=L8E9iQlqVEJ+gzCXld3siwY+dzmNVX0LaD06zHF/0RQ=;
        b=h5Vw5aFu9zGEkuOEorRUs/MpAEYMCPPaB70hiYJznDPXZ1gGMPxEr2CIYO2LdrAGVy
         YK3LQL1OMH+tuMfWQfhvbuavcJEBFubTDRtGI6+TCaIuWp2EKhIwPQZJozFUuiTenhMK
         ww8i4vtrmKKCNXQWRiCG7H17O3PHoMxfJV91ed7VT2lkMljRS6s2wuiHP4DvyklERJNl
         T47BULDGlhBJZqT48XKBqrV1pKTNC8s3DraeNkeojph7V/O2Yqj0+LJ4R0psHawbQiSy
         TKuyHZ4VoxO5jYOgkAuxzSny+lB8+612x0cm4jDF+1X0vuFeof3TNubVk/ZUljKTvgXy
         qJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=L8E9iQlqVEJ+gzCXld3siwY+dzmNVX0LaD06zHF/0RQ=;
        b=Oy8HEEhNBaaEv4mRQCstdmSrnx8sEBza05BZsv948MsvMjqQIS1i1vvYFQwy33Wij+
         d4+IIlMBZ+JBF76ydUeoOJdqitObzitjh1ZpQOvjCZsxcaET8s4Mjd+ErEEi4I/dOury
         FCMQms/pz/zW5NgbDs/hTkHyBYJVURbsfGZVLn92oAE/AQmfZws31dvSF89WKvbrzkNV
         eC79V2cIOSEdyG74Qn9feGreqzR1MlRTJl4dcq3FMJlQN9ICuFilg4WzsVtSUK8Q1fTu
         +ag3Fgy5lFNSWr6Q/4Rx387vWn3ZbCsr2JbBs4vxtv7PfFmaajiYnnS4h8s+TZ58hh8k
         Q4SA==
X-Gm-Message-State: AOAM530JeiMZMN41EJjpyROwHMjcx5j2NPRgMT9DEl16UDe4G908GltA
        mCDlWWr3LkZLknmmJuBu8bixPJwhLmY=
X-Google-Smtp-Source: ABdhPJyBJCfAM2WelwdCsSVYQ7SryUKZ62EQis5tWdW7ajbykm/ean1iA8t+/FlOEIDyfteizWQgKg==
X-Received: by 2002:a63:81c3:: with SMTP id t186mr9082057pgd.123.1624004928119;
        Fri, 18 Jun 2021 01:28:48 -0700 (PDT)
Received: from [10.1.1.25] (222-152-189-137-fibre.sparkbb.co.nz. [222.152.189.137])
        by smtp.gmail.com with ESMTPSA id q21sm7815537pfn.81.2021.06.18.01.28.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 01:28:47 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com>
 <1623907712-29366-3-git-send-email-schmitzmic@gmail.com>
 <d661fb8-274d-6731-75f4-685bb2311c41@linux-m68k.org>
 <1fa288e2-3157-68f8-32c1-ffa1c63e4f85@gmail.com>
 <CAMuHMdVGe1EutOVpw3-R=25xG0p2rWd65cB2mqM-imXWYjLtXw@mail.gmail.com>
 <da54e915-c142-a69b-757f-6a6419f173fa@gmail.com>
 <CAMuHMdV5Yd2w+maSn-dQ=NOrVyVc8JjV38miKRc-pvnzBcKSig@mail.gmail.com>
Cc:     Finn Thain <fthain@linux-m68k.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <9faae8bf-74c2-52e8-ce3d-9abef34412e4@gmail.com>
Date:   Fri, 18 Jun 2021 20:28:42 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV5Yd2w+maSn-dQ=NOrVyVc8JjV38miKRc-pvnzBcKSig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Am 18.06.2021 um 20:13 schrieb Geert Uytterhoeven:
>>
>> How does re-probing after a card change for a builtin driver work?
>> Changing the permission bits is a minor issue.
>
> Oh right, this driver predates the driver framework, and doesn't support
> PCMCIA hotplug.  So auto-unregister on removal doesn't work.
> Even using unbind/bind in sysfs won't work.
>
> So rmmod/modprobe is the only thing that has a chance to work...
>
>>>> The comment there says isa_type must be set as early as possible, so I'd
>>>> rather leave that alone, and add an 'else' clause here.
>>>>
>>>> This of course raise the question whether we ought to move the entire
>>>> isa_type handling into arch code instead - make it a generic
>>>> amiga_pcmcia_16bit option settable via sysfs. There may be other 16 bit
>>>> cards that require the same treatment, and duplicating PCMCIA mode
>>>> switching all over the place could be avoided. Opinions?
>>>
>>> Indeed.
>>
>> The only downside I can see is that setting isa_type needs to be done
>> ahead of modprobe, through sysfs. That might be a little error prone.
>>
>>> Still, can we autodetect in the driver?
>>
>> Guess we'll have to find out how the 16 bit cards behave if first poked
>> in 8 bit mode, attempting to force a reset of the 8390 chip, and
>> switching to 16 bit mode if this fails. That's normally done in
>> apne_probe1() which runs after init_pcmcia(), so we can't rely on the
>> result of a 8390 reset autoprobe to do the PCMCIA software reset there.
>>
>> The 8390 reset part does not rely on anything else in apne_probe1(), so
>> that code can be lifted out of apne_probe1() and run early in
>> apne_probe() (after the check for an inserted PCMCIA card). I'll try and
>> prepare a patch for Alex to test that method.

I just realized that might not work - ínit_pcmcia() enables the PCMCIA 
interface for us, so the early 8390 reset may not go through at all... 
The module parameter may have to stay as a fallback option at least.

>>
>>> I'm wondering how this is handled on PCs with PCMCIA, or if there
>>> really is something special about Amiga PCMCIA hardware...
>>
>> What's special about Amiga PCMCIA hardware is that the card reset isn't
>> connected for those 16 bit cards, so pcmcia_reset() does not work.
>
> I was mostly thinking about the difference between 8-bit and 16-bit
> accesses.

No idea. I've never even seen an 8 bit PCMCIA card - I have a few old 
16/32 bit ones around that were great for crashing my PowerBook, nothing 
else...

>>> And I'd really like to get rid of the CONFIG_APNE100MBIT option,
>>> i.e. always include the support, if possible.
>>
>> I can't see why that wouldn't be possible - the only downside is that we
>> force MULTI_ISA=1 always for Amiga, and lose the optimizations done for
>> MUTLI_ISA=0 in io_mm.h. Unless we autoprobe, we can use isa_type to
>> guard against running a software reset on 8 bit cards ...
>
> The latter sounds like a neat trick...

Yes, we can at least get rid of the APNE100MBIT option that way. I'll 
have to think about the autoprobe a bit more.

Cheers,

	Michael

> Gr{oetje,eeting}s,
>
>                         Geert
>
