Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B97D17A82C
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCEOxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:53:49 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:41336 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgCEOxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:53:49 -0500
Received: by mail-qv1-f67.google.com with SMTP id s15so2521138qvn.8;
        Thu, 05 Mar 2020 06:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VxuhUCC4n+HG3AgUkytKe/eT7ToYukorM5sgQRyWjQU=;
        b=f0xOKWX8qNAzNupu5nlpzWfh81iFksOdx2LiItmWH5+9asvPAsRWUFTunBaxxaYBTv
         qv3JbBlUuYlH9NTFcOlP8Gq+eDGP1J0tTf5u9mbjg7ZRQQR1g7P0r4Yk7+foaNXicH2D
         Pf0O6ubtAp1nHxOyClotBqMdZP2pYr9FVTOwouVc+W+zqOI1VoW7/Ulz0yoBCEAt4pST
         mv7BiCoF1bRK6bYDrjTJPo5mB+h2xbdddrof61DuUFnxIFgLIelBYEc0CcflY6fp0JYn
         giTNKjpMcJaUiHZ4Rpdqb/rx/s+9oFWs9rMmCEMQGHsZ9f81NnSLn20fA2OI1VNfIvSk
         FbEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VxuhUCC4n+HG3AgUkytKe/eT7ToYukorM5sgQRyWjQU=;
        b=oPCqzesbp6D7+zhK+MbTrtwFhoN31p9+MqkL9obL085UpyW16p/Rk2+hxoKpEJLzF0
         4BTl9paIBQ9ixOrPJ0lC2TYYKPeM9HpIUhoDGQPdHP9iU9h7Di6xRdguDnb0IY/oweFi
         VJX7Fq4Iq1iUlIQM4vYhFoVFbxaXIEiFJklHQliYpaS3m/2kKBpCLJHTv8DGOqEQfSfG
         OS6R/zeYnDmWBrQNcY2fmoCIUTbOCesnKKPloVeQ8j1B566eKXlOggXx8O/dfklV9h8v
         t2tal6YQ7lOlY1eNAl17Me1+9epDyU2RvTo+khPEs2K1ikra4667pJlSpplUASjgQTm5
         s0/g==
X-Gm-Message-State: ANhLgQ1AdefHa8ObTk4eM0e4+58sjwXxzXXCSIXAh2hDrLZ69ly8FPlv
        JDZ3m6TdAb+07P7vWHvZgMd8UQeRA5aPHbYywYE=
X-Google-Smtp-Source: ADFU+vvEbdeciibEt6Hrq92wQ3v5gNAzAqdWRfPoKAj87boYm/+Z7me5O2hb9UostwnS1QPcgbJLwx/2ELu6kWicWjM=
X-Received: by 2002:a05:6214:1552:: with SMTP id t18mr6513046qvw.113.1583420027929;
 Thu, 05 Mar 2020 06:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20200305220108.18780-1-mayflowerera@gmail.com>
 <20200305220108.18780-2-mayflowerera@gmail.com> <20200305140241.GA28693@unicorn.suse.cz>
 <CAMdQvKv9tSoSBfyOyhtctQ9D7aU2WUmuMUsoLn_WZ8whD=3AzA@mail.gmail.com>
In-Reply-To: <CAMdQvKv9tSoSBfyOyhtctQ9D7aU2WUmuMUsoLn_WZ8whD=3AzA@mail.gmail.com>
From:   Era Mayflower <mayflowerera@gmail.com>
Date:   Thu, 5 Mar 2020 23:53:29 +0000
Message-ID: <CAMdQvKuzaBuKGj1-HR6+r=FY4X9GhZPvEHwRt3BjErFiu1+bgw@mail.gmail.com>
Subject: Re: [PATCH 2/2] macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you think that inserting those new enum values after *_PAD would be
a good solution?


On Thu, Mar 5, 2020 at 11:51 PM Era Mayflower <mayflowerera@gmail.com> wrote:
>
> Do you think that inserting those new enum values after *_PAD would be a good solution?
>
> On Thu, Mar 5, 2020 at 2:02 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>>
>> On Thu, Mar 05, 2020 at 10:01:08PM +0000, Era Mayflower wrote:
>> > Netlink support of extended packet number cipher suites,
>> > allows adding and updating XPN macsec interfaces.
>> >
>> > Added support in:
>> >     * Creating interfaces with GCM-AES-XPN-128 and GCM-AES-XPN-256.
>> >     * Setting and getting packet numbers with 64bit of SAs.
>> >     * Settings and getting ssci of SCs.
>> >     * Settings and getting salt of SecYs.
>> >
>> > Depends on: macsec: Support XPN frame handling - IEEE 802.1AEbw.
>> >
>> > Signed-off-by: Era Mayflower <mayflowerera@gmail.com>
>> > ---
>> [...]
>> > diff --git a/include/net/macsec.h b/include/net/macsec.h
>> > index a0b1d0b5c..3c7914ff1 100644
>> > --- a/include/net/macsec.h
>> > +++ b/include/net/macsec.h
>> > @@ -11,6 +11,9 @@
>> >  #include <uapi/linux/if_link.h>
>> >  #include <uapi/linux/if_macsec.h>
>> >
>> > +#define MACSEC_DEFAULT_PN_LEN 4
>> > +#define MACSEC_XPN_PN_LEN 8
>> > +
>> >  #define MACSEC_SALT_LEN 12
>> >
>> >  typedef u64 __bitwise sci_t;
>> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>> > index 024af2d1d..ee424d915 100644
>> > --- a/include/uapi/linux/if_link.h
>> > +++ b/include/uapi/linux/if_link.h
>> > @@ -462,6 +462,8 @@ enum {
>> >       IFLA_MACSEC_SCB,
>> >       IFLA_MACSEC_REPLAY_PROTECT,
>> >       IFLA_MACSEC_VALIDATION,
>> > +     IFLA_MACSEC_SSCI,
>> > +     IFLA_MACSEC_SALT,
>> >       IFLA_MACSEC_PAD,
>> >       __IFLA_MACSEC_MAX,
>> >  };
>>
>> Doesn't this break backword compatibility? You change the value of
>> IFLA_MACSEC_PAD; even if it's only used as padding, if an old client
>> uses it, new kernel will interpret it as IFLA_MACSEC_SSCI (an the same
>> holds for new client with old kernel).
>>
>> > diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
>> > index 1d63c43c3..c8fab9673 100644
>> > --- a/include/uapi/linux/if_macsec.h
>> > +++ b/include/uapi/linux/if_macsec.h
>> > @@ -25,6 +25,8 @@
>> >  /* cipher IDs as per IEEE802.1AEbn-2011 */
>> >  #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
>> >  #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
>> > +#define MACSEC_CIPHER_ID_GCM_AES_XPN_128 0x0080C20001000003ULL
>> > +#define MACSEC_CIPHER_ID_GCM_AES_XPN_256 0x0080C20001000004ULL
>> >
>> >  /* deprecated cipher ID for GCM-AES-128 */
>> >  #define MACSEC_DEFAULT_CIPHER_ID     0x0080020001000001ULL
>> > @@ -66,6 +68,8 @@ enum macsec_secy_attrs {
>> >       MACSEC_SECY_ATTR_INC_SCI,
>> >       MACSEC_SECY_ATTR_ES,
>> >       MACSEC_SECY_ATTR_SCB,
>> > +     MACSEC_SECY_ATTR_SSCI,
>> > +     MACSEC_SECY_ATTR_SALT,
>> >       MACSEC_SECY_ATTR_PAD,
>> >       __MACSEC_SECY_ATTR_END,
>> >       NUM_MACSEC_SECY_ATTR = __MACSEC_SECY_ATTR_END,
>> > @@ -78,6 +82,7 @@ enum macsec_rxsc_attrs {
>> >       MACSEC_RXSC_ATTR_ACTIVE,  /* config/dump, u8 0..1 */
>> >       MACSEC_RXSC_ATTR_SA_LIST, /* dump, nested */
>> >       MACSEC_RXSC_ATTR_STATS,   /* dump, nested, macsec_rxsc_stats_attr */
>> > +     MACSEC_RXSC_ATTR_SSCI,    /* config/dump, u32 */
>> >       MACSEC_RXSC_ATTR_PAD,
>> >       __MACSEC_RXSC_ATTR_END,
>> >       NUM_MACSEC_RXSC_ATTR = __MACSEC_RXSC_ATTR_END,
>>
>> The same problem with these two.
>>
>> I'm also a bit unsure about the change of type and length of
>> MACSEC_SA_ATTR_PN but I would have to get more familiar with the code to
>> see if it is really a problem.
>>
>> Michal
