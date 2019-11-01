Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEEDEBBB1
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 02:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfKAB2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 21:28:46 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34027 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfKAB2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 21:28:45 -0400
Received: by mail-lj1-f194.google.com with SMTP id 139so8660773ljf.1
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 18:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lXj6Io/zy+l3kVnc3VZS6EAplgmsAUnC50Emckcf5uw=;
        b=jc8CjvgznCj5dE3iW+NracNWKhZPt+cVZJWMvjvcO10KhdpAVZMzOTBJ6sIiLcrNxi
         iJg2EKZElThQufiCWzOcflMEgqlylFKfsOEjXgWZUCt1cIXdmPwLhHYr0jxB4sEcd43z
         xcaWcZowpHrn4mQQWErYz+sWqG9pa5icY6NhEe1JTarc/b5NkmJLJVG9rnjKEi2nl6Fn
         eJRupvHa38ImiVLRJxUNDXROnEGnVnyT4shuZyyCzjwH+bR9fln/wDMFyS94QmPMvrGl
         LYWCrLF0B2+qf8snDr8Ac/E5ouoixSBDOpv9UHahSU86NsGs7sa8R0ri93W7ZhnaPKux
         fjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lXj6Io/zy+l3kVnc3VZS6EAplgmsAUnC50Emckcf5uw=;
        b=rDtGa73yqR0KKs70OJ+QNJ6LwOomPKYLwKdVXRZzxCKmWq1pe8tcI55o6hI6rIROYU
         BNHXQ8C6FhvqSEziePsRW22ymJ1cy6nZ6IEIaRO0nTVxw9xtNDzEP5zAx1u9+jVvVtl8
         Z7s+odZ9nMcys0I3bRfJLeXqIEkTg/gulrZOKUinIfCtWnn7o0y/zWcyoWotMrgoGXHj
         zT2HgLklx4q8rDwlCAg6KMpioAI4TbbCeE4iS1Fgs83shQ4BMe/etie75OmZmiTZozxi
         xT8kx/HCHGWLTIFjKB6/sVMPPDgb7gymSDKPVeSWdc1O+6XpcHkV5EKbakmEX4d7uPFD
         E18Q==
X-Gm-Message-State: APjAAAWbecIBkWZo/tnxsFf5FsLdrqNtJZrFvhHbMxyErdsEBya4Yb9Y
        45hL8Mbkd2KFB10pCmjlvAmp8w==
X-Google-Smtp-Source: APXvYqx8EXYES5u0M40yjQO42GK3R2hgk4vHXXUMRQuuD1jFgVU4Q+Fd1v/yW+EiVdrQ+xp2BJcyPw==
X-Received: by 2002:a2e:63c9:: with SMTP id s70mr6263078lje.73.1572571723584;
        Thu, 31 Oct 2019 18:28:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c22sm2106176lfj.28.2019.10.31.18.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 18:28:43 -0700 (PDT)
Date:   Thu, 31 Oct 2019 18:28:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        bpf <bpf@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [oss-drivers] Re: [PATCH bpf-next] Revert "selftests: bpf:
 Don't try to read files without read permission"
Message-ID: <20191031182835.0451d472@cakuba.netronome.com>
In-Reply-To: <CAADnVQKZbgqs3DJOsV4dtOY-ZXG8oQ7kWmJrJ_dS842qDrwABw@mail.gmail.com>
References: <20191101005127.1355-1-jakub.kicinski@netronome.com>
        <CAADnVQKZbgqs3DJOsV4dtOY-ZXG8oQ7kWmJrJ_dS842qDrwABw@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 17:56:46 -0700, Alexei Starovoitov wrote:
> On Thu, Oct 31, 2019 at 5:51 PM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > This reverts commit 5bc60de50dfe ("selftests: bpf: Don't try to read
> > files without read permission").
> >
> > Quoted commit does not work at all, and was never tested.
> > Script requires root permissions (and tests for them)
> > and os.access() will always return true for root.
> >
> > The correct fix is needed in the bpf tree, so let's just
> > revert and save ourselves the merge conflict.
> >
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>  
> 
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Since original commit is broken may be apply directly to net-next ?
> I'm fine whichever way.

I'm 3 fixes down to get test_offloads.py to work again. One for
cls_bpf, one for the test itself and one for net/core/dev.c logic.
Should I target all those at net?

Are you and Daniel running test_offloads.py?  It looks like it lots of
things slipped in since I last run it :(

> I would wait for Jiri to reply first though.

Not sure what he can contribute at this point but sure :/
