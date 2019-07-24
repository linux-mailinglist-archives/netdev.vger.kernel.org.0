Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1221732EA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 17:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbfGXPir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 11:38:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52235 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387607AbfGXPir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 11:38:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so42253995wms.2;
        Wed, 24 Jul 2019 08:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=YvedMehgPemIhsDxpvppFcCT4c2INvzEItjhjD/enNo=;
        b=ggg6dl2QET/hNSQ24wJ7DTco67JKSpQvW8LUSD22fdWfZnB577x8u4ClZlaAtMIMNU
         2DAhs4tCTRM82bGk9qxMJNOdIBXmtaAqk7SQtloj5oN5THwICTLCAsSDTERA5HeC8tSm
         YdkCBcNGmzehub/auk1/AEv8ckkSts7/pQPZ89zNyWliIj218B8y3SweKgEauBhQiMOV
         fPYSVA2yhEIoaXmH/S5wVeBjXHu+h1wVsnmkkgWbXF50xxVRB6N0nRU/ZUTc1mzb4l/l
         UYx7URYY+dcuOUyJc0KYa8gNCXvZdLzHj1hyJSyXyu28sgyb56mBOW8fWGslffpdiqok
         Bxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=YvedMehgPemIhsDxpvppFcCT4c2INvzEItjhjD/enNo=;
        b=TfoJTkkTS/crdeCCk0maTmqwon0qkFGTmtXNpzCA7BJSbnmdLFoKHbWjq6fq/+jszK
         KvFIQ+cI1DU3Ew+NMRLJ5hNug5JOY/VBeeCAL6mZfMXZxaTJVbcDiYsaLr0QUpFwBCma
         Wmas2KAlmYrTg/a8qyWry2zC7/R0taffgjK/1DEr54fj6FGcIly+EZQwiAZEn05DXZe1
         LaUqhGE3a9a4pryeWSEhB7tA0aer/2d+Dpq8FEmyjrVdiX2Gk1fZeA5Qrfm4ifTS7Fsu
         3wOJ3fEN9kpYV5Ru0Iqh4cX/QlkOOd3hsqqXyD2aouWQfIH7bFSMjAeLOMRzmRv5MOOa
         EG1A==
X-Gm-Message-State: APjAAAUHLtUp6Q3NWVZijETWNxMWNIPEhDgWEHXUqGiulpSDg/13YcNB
        aZCmsVgeNsIZ6mYI0eYRwGArMHixTzWvj7kQjt0=
X-Google-Smtp-Source: APXvYqw/OCYaNmzYOdOTuRYLUTRa33OpNyyfEcRNVxcxs1pKQo3kFvY+dwzQCNG8Vf/eF8bEXDk8Bd8KpjRVmv5JtcA=
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr71538056wma.36.1563982724483;
 Wed, 24 Jul 2019 08:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190712001708.170259-1-ndesaulniers@google.com>
 <b219cf41933b2f965572af515cf9d3119293bfba.camel@perches.com>
 <CAKwvOdkD_r2YBqRDy-uTGMG1YeRF8KokxjikR0XLkXLsdJca0g@mail.gmail.com> <da053a97d771eff0ad8db37e644108ed2fad25a3.camel@coelho.fi>
In-Reply-To: <da053a97d771eff0ad8db37e644108ed2fad25a3.camel@coelho.fi>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 24 Jul 2019 17:38:33 +0200
Message-ID: <CA+icZUVRFG5x4ycM72pjVW9Md2NMekA-phXxJya1-9+uBuxfKQ@mail.gmail.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
To:     Luca Coelho <luca@coelho.fi>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 11:15 PM Luca Coelho <luca@coelho.fi> wrote:
>
> On Tue, 2019-07-16 at 10:28 -0700, Nick Desaulniers wrote:
> > On Thu, Jul 11, 2019 at 7:15 PM Joe Perches <joe@perches.com> wrote:
> > > On Thu, 2019-07-11 at 17:17 -0700, Nick Desaulniers wrote:
> > > > Commit r353569 in prerelease Clang-9 is producing a linkage failure:
> > > >
> > > > ld: drivers/net/wireless/intel/iwlwifi/fw/dbg.o:
> > > > in function `_iwl_fw_dbg_apply_point':
> > > > dbg.c:(.text+0x827a): undefined reference to `__compiletime_assert_2387'
> > > >
> > > > when the following configs are enabled:
> > > > - CONFIG_IWLWIFI
> > > > - CONFIG_IWLMVM
> > > > - CONFIG_KASAN
> > > >
> > > > Work around the issue for now by marking the debug strings as `static`,
> > > > which they probably should be any ways.
> > > >
> > > > Link: https://bugs.llvm.org/show_bug.cgi?id=42580
> > > > Link: https://github.com/ClangBuiltLinux/linux/issues/580
> > > > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > > > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > > ---
> > > >  drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> > > > index e411ac98290d..f8c90ea4e9b4 100644
> > > > --- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> > > > +++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> > > > @@ -2438,7 +2438,7 @@ static void iwl_fw_dbg_info_apply(struct iwl_fw_runtime *fwrt,
> > > >  {
> > > >       u32 img_name_len = le32_to_cpu(dbg_info->img_name_len);
> > > >       u32 dbg_cfg_name_len = le32_to_cpu(dbg_info->dbg_cfg_name_len);
> > > > -     const char err_str[] =
> > > > +     static const char err_str[] =
> > > >               "WRT: ext=%d. Invalid %s name length %d, expected %d\n";
> > >
> > > Better still would be to use the format string directly
> > > in both locations instead of trying to deduplicate it
> > > via storing it into a separate pointer.
> > >
> > > Let the compiler/linker consolidate the format.
> > > It's smaller object code, allows format/argument verification,
> > > and is simpler for humans to understand.
> >
> > Whichever Kalle prefers, I just want my CI green again.
>
> We already changed this in a later internal patch, which will reach the
> mainline (-next) soon.  So let's skip this for now.
>

Do you have a link to your internal Git or patchwork for this?

I am interested in testing it.

- Sedat -
