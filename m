Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08C81B28F6
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgDUODc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 10:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726691AbgDUODb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 10:03:31 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B2BC061A41
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:03:31 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id t189so8471103vst.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 07:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B35D0jI8LN5q5XNwCoa3xE2PFpxh4HO6z4DdY1MmZKM=;
        b=iNSoReSC0kN5p6Y+MK4OFOOaKrGbah8BGCr8hjwdtA72KNIiYj5XuqGXN866kveKg5
         FM2SUgPN/hTG2ShC2XfHQd/m6Sv1W76lqVnZXpNx9b1R9/GO5ro6Gc+tUPyRmytejuGj
         YlD+3DF1GXOLJk2CZUzupQg69SlPMOrhat73MUNL+wlmow968rTHnsUahxo9UILh52+q
         MlYreJcFCIgj3bvIcS3WInXyR2Mp0RVhgFNS3Yhfj5eHOYtIaqEx3vZHbCQ7eL+qUCXd
         gddXzzCudDGnWIYiWwGZVwv8yt2zOO2PfMioOqNDiQleQiwY/54Uey7NoZZNDD8qHtLk
         G7eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B35D0jI8LN5q5XNwCoa3xE2PFpxh4HO6z4DdY1MmZKM=;
        b=XwiPXnmA39DyQq6ZnzLtXgTMy7YPCh5XIV7FJNpmPht+oCIVr3sx8CXtVpMr/+qCAT
         6FPWLqxUR2r5M4fqsn5moCupQ8VLeBkL4U/Zig5Rxvk2jqj4feTVMHN6rmTb7Tbg7xCr
         M2N+CHnhU1sJhckQneJKtPw7EOBCJ0dDqc26LGVEi9nqbMntxV4KlLaX6mn04TOiIJ1M
         JZph560cmJp6zi8P77cusg8/LOyJ1WV3iTd08Jy7qv/BCR5FKS9t6LTiwOW2g113td8K
         VHQ54+dECaCphdIOKk5GK14+rRYpaujm78azvjgdOjCm7934MK4/WtlvsRPipSajUiSH
         M33Q==
X-Gm-Message-State: AGi0PuasviD7M4T4OmwV8tFD8EgZIuDPa6VOIkdAOq+5YmvLhjI6heB3
        qnr1oBNry9uoNllQ2kS95OHNyVVuPSzx/I6ci/mizA==
X-Google-Smtp-Source: APiQypI6rpa4fTokweP9tN5YW2kreIutvpDWa2397Huu3gbq/EKTFkf0vMVJ7PLmjqC7piulvc8Dg1StcxUm8fSuLms=
X-Received: by 2002:a67:7d83:: with SMTP id y125mr13956104vsc.96.1587477810356;
 Tue, 21 Apr 2020 07:03:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081507.108023-1-zenczykowski@gmail.com>
 <20200421104014.7xfnfphpavmy6yqg@salvia> <CANP3RGfBtFhP8ESVprekuGB-664RHoSYC50mHEKYZwosfHHLxA@mail.gmail.com>
In-Reply-To: <CANP3RGfBtFhP8ESVprekuGB-664RHoSYC50mHEKYZwosfHHLxA@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 21 Apr 2020 07:03:18 -0700
Message-ID: <CANP3RGdpJDbfQVSSHh6YM5kD7HAsU-Qrk=Hn7Jf_HrOD-Go2PA@mail.gmail.com>
Subject: Re: [PATCH] libipt_ULOG.c - include strings.h for the definition of ffs()
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

note: I guess it could also be bionic vs libc header files...
but per man ffs:
http://man7.org/linux/man-pages/man3/ffs.3.html

       #include <strings.h>
       int ffs(int i);

       #include <string.h>
       int ffsl(long int i);
       int ffsll(long long int i);

strings.h is the right header file.
