Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5461CBD86
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 06:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgEIEjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 00:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgEIEjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 00:39:51 -0400
Received: from omr2.cc.vt.edu (omr2.cc.ipv6.vt.edu [IPv6:2607:b400:92:8400:0:33:fb76:806e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA70BC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 21:39:50 -0700 (PDT)
Received: from mr2.cc.vt.edu (junk.cc.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id 0494dmG7000482
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 00:39:48 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id 0494dhGw020470
        for <netdev@vger.kernel.org>; Sat, 9 May 2020 00:39:48 -0400
Received: by mail-qk1-f200.google.com with SMTP id x5so4323382qkn.20
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 21:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=4HlAZy+x5Vyp9f/R1vrNhputccwbqWK0vLECWfqcbjA=;
        b=Nq0kNOoQ0WfgLAuSumMN+HLTn7qpMZTXVsPuc3MRqYw+8lhmQlu0yk0kh/9zoYmDT+
         gZ0e5IDlvytLL5uQ5GulJTtWpyFrErlsAiTkCfOViRA9RqYLiWIHUrnjg2sN3zyVXvwM
         Xvj+mbCacVy7L44UTG8z187LCqnbarbbiF8MpFSjA2e3YScuu3EdLs7TmE/QOC7oZPbH
         eVma74KQbQ/jcspO5jluIkCtxG4dTV9+KxnV0qlCen+xnAVcGicMOrEn3hcouEIQ1l9J
         3Rg7S9AMASVub/5Wdqjpb/IjTl11VJrxmJVsO1WBjIMCcFA2BWeLunQX84T6rJa4CCGG
         fxlw==
X-Gm-Message-State: AGi0PuYApMOJzMiF4UtqVgNpiguirZm7AiuyJAjSi2fXh+NV6ppOazcs
        sh+81JeVscIlFKfjRI69oLCYwGOn0RmS4wmQwyBk4TGGsx/ces8dD09XcNItBI7hk6QFqLfONQ+
        FG01U/3Jd1hlb/om/JR4muzYqlSQ=
X-Received: by 2002:ac8:60d2:: with SMTP id i18mr6351336qtm.244.1588999183102;
        Fri, 08 May 2020 21:39:43 -0700 (PDT)
X-Google-Smtp-Source: APiQypJUKMRJwsuig4tOPD4UhjqCfhYBTzYXe/zcaSRYFPbaDlHVfzA30uj3uvwa+YZFmsCDPZupaw==
X-Received: by 2002:ac8:60d2:: with SMTP id i18mr6351323qtm.244.1588999182813;
        Fri, 08 May 2020 21:39:42 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:c9e1::359])
        by smtp.gmail.com with ESMTPSA id b42sm3466211qta.29.2020.05.08.21.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 21:39:41 -0700 (PDT)
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next 20200506 - build failure with net/bpfilter/bpfilter_umh
In-Reply-To: <CAK7LNARbKdfGiozX+WrF7fTSf6tpXPUQ8Hr=jC_phUwZa_FONg@mail.gmail.com>
References: <251580.1588912756@turing-police>
 <CAK7LNARbKdfGiozX+WrF7fTSf6tpXPUQ8Hr=jC_phUwZa_FONg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1588999179_6159P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Sat, 09 May 2020 00:39:39 -0400
Message-ID: <126705.1588999179@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--==_Exmh_1588999179_6159P
Content-Type: text/plain; charset=us-ascii

On Sat, 09 May 2020 12:45:22 +0900, Masahiro Yamada said:

> >   LD [U]  net/bpfilter/bpfilter_umh
> > /usr/bin/ld: cannot find -lc
> > collect2: error: ld returned 1 exit status
> > make[2]: *** [scripts/Makefile.userprogs:36: net/bpfilter/bpfilter_umh] Error 1
> > make[1]: *** [scripts/Makefile.build:494: net/bpfilter] Error 2
> > make: *** [Makefile:1726: net] Error 2
> >
> > The culprit is this commit:
>
> Thanks. I will try to fix it,
> but my commit is innocent because
> it is just textual cleanups.
> No functional change is intended.

Hmm... 'git show' made it look like a totally new line...

Proposed patch following in separate email...



--==_Exmh_1588999179_6159P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBXrY0CwdmEQWDXROgAQK7zBAAoJIkHQxqxrSHh8Xj26EcJbDRX+pxD8oO
7VHd42t5dEVS3+lr3FSfYfVwmIH3E/du6MlogZs9IvfBbahpZOtxBFrenL4Nbp86
xgHXbfD+dG70HKdi8n0e85dWOUxhOFSTtoBRdEYFPHIMKhvrXf+704OVC2ugB2bL
eqVKa0/7TzLBT2NZSy/2rZQmlc6S90fOCSy73TJsvKc/1yFOfQC1TW9sjzp+8kCl
evfrSHjEqpwmto8Bdl3nbcDyk64nvLlGtHf7vVzgnrwh2+llKO2cjzoBkuGPp2zp
BuL901PbPg9vMaZ6TvxApC2YZnsT1piaIR797/F8KzPuy44KV05FZw9HRL6/9kND
hV7su+7nwQcUsX0hbZlpi6LybKlYFe2Ly9a7q+HNgsj5MjBK8sHOc8mA3mOm042l
LYC/phYGLhgNVAy2ih9GaGOyw6MmQEABe4e8VNiavdfWaz2Z/W89pioa2v+DzwIx
U8SUdqD4vDIZ+Xwkfzss1sY72DEztwzL+Vkh/5h4wdm1qCic6o7zvOUGSSqqPDmL
NpqEEVkZQPTtifs4Od3/TgRdTJz/Vn8RsCuB3bF5x4DJ+7HRWXm9ROXrsXqZfZ5V
5jDlftMD70YV42WyihkcVAWAhqRLyzmRWcF9cmsllqVGupq2f+MWJowiacsNB0dG
EQ9pnXquFtw=
=x8/o
-----END PGP SIGNATURE-----

--==_Exmh_1588999179_6159P--
