Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317E148645A
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiAFM0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238754AbiAFM0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:26:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8019C061245;
        Thu,  6 Jan 2022 04:26:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D3EEB81FBB;
        Thu,  6 Jan 2022 12:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52C5C36AE3;
        Thu,  6 Jan 2022 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641471992;
        bh=F+VRetsdQhDk6RTHaHN8OZEU4IjmNt0fu6rA5nIO7a4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4i9FukbcjQ8Ru8J0XU9nV2k/NPxE63fFvocJtu1H/UlWa7/rt/WArU7Sk/mrxIio
         KRC5V3u2O+v0x75+J7m0U8e5kv94ylqTcYiTQ+n3mqfQRx93ER3vmjbsd2jjDcdcIk
         SYNnsBhTC7y1YhprLKgVSQMUxakRMU9sKSPGo5z8=
Date:   Thu, 6 Jan 2022 13:26:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: txtimestamp.c:164:29: warning: format '0' expects argument of
 type 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
 int'} [-Wformat=]
Message-ID: <Ydbf9UV1ga2aytJX@kroah.com>
References: <CA+G9fYtaoxVF-bL40kt=FKcjjaLUnS+h8hNf=wQv_dKKWn_MNQ@mail.gmail.com>
 <YdbGZiKKdVgh8A4i@kroah.com>
 <CA+G9fYtNQh8KygC7ufvkMuB_d7PX-meknhOpDcuQiPx8oBcrCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtNQh8KygC7ufvkMuB_d7PX-meknhOpDcuQiPx8oBcrCA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 05:38:16PM +0530, Naresh Kamboju wrote:
> On Thu, 6 Jan 2022 at 16:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jan 06, 2022 at 03:39:09PM +0530, Naresh Kamboju wrote:
> > > While building selftests the following warnings were noticed for arm
> > > architecture on Linux stable v5.15.13 kernel and also on Linus's tree.
> > >
> > > arm-linux-gnueabihf-gcc -Wall -Wl,--no-as-needed -O2 -g
> > > -I../../../../usr/include/    txtimestamp.c  -o
> > > /home/tuxbuild/.cache/tuxmake/builds/current/kselftest/net/txtimestamp
> > > txtimestamp.c: In function 'validate_timestamp':
> > > txtimestamp.c:164:29: warning: format '0' expects argument of type
> > > 'long unsigned int', but argument 3 has type 'int64_t' {aka 'long long
> > > int'} [-Wformat=]
> > >   164 |   fprintf(stderr, "ERROR: 0 us expected between 0 and 0\n",
> 
> <trim>
> 
> > Same question as before, is this a regression, and if so, any pointers
> > to a fix?
> 
> This is a known warning on Linus's tree.

Great, please report the issue there, as there's nothing I can do about
it in the 5.15.y tree until it is resolved there as you know.

thanks,

greg k-h
