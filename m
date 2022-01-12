Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A11148BE8A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 07:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350976AbiALGX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 01:23:57 -0500
Received: from out162-62-57-87.mail.qq.com ([162.62.57.87]:51315 "EHLO
        out162-62-57-87.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbiALGX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 01:23:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641968626;
        bh=AFpLSdr37ru0LWxmAPC73QLpfj5oiuYqjThjLb9wsxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=nnm9oAsnIHYCERrPtMHi18826hTqthXYw7IRFsS7rMc4cjxxpxbXbGg0oGe2ubw9x
         m44lEd+Q/bmMvI8CGON6ZongK3JaF0kWlmhHWRp61taGA8rA7ruT3AhMGgXhYrs+Ie
         bg39nTl1biVaFDfUZNFtAUT0fLUngU9ZANLEDDr4=
Received: from localhost ([119.32.47.91])
        by newxmesmtplogicsvrsza5.qq.com (NewEsmtp) with SMTP
        id 41BB8A76; Wed, 12 Jan 2022 14:16:27 +0800
X-QQ-mid: xmsmtpt1641968187tlvhrscib
Message-ID: <tencent_236C8935F1179CB3D1788CBF3B179494D60A@qq.com>
X-QQ-XMAILINFO: NhDhJCJPIfnTDcnTznCD9f89oc8Kla5y5v2MzY6O6cSG9gIiK9IrdR1D2zyAdn
         0eevOWM0Gzp1keStWW2+1yuPnFR55xMhbf4VE/VnKMqNPaoxt8WVVPzOuWO8QkM5LrHjlxav/STa
         NLaSIsTmak/NjAw41rodE0av49y7UgoIO9hdmnFVjKxqc37FSLHsNkM+c8g9DmI1gE+/6qMuGeoY
         UjC9CkpgJJCWNVroOiv1aMvWX73iuGSnHsFJi6jTcVmQvDDF6SBAXvvJ/nMlXI7WdSZJ29Weh4sr
         Fy9iEuvugRh4LbhP3JFnl+dFRzmlzNIAlNlcgWc1r4JXUmFYrTQO7buYKnXSlhbQiSdtGXbQj+tZ
         bbcwdLcD15F1tMX+aJJ1GOYfe5flcx4bVJYbE1IT0rZmUycWtxau0MV5mCVPJrovk3MMhKTzz13C
         Rhto0xY+wTqzl22lpJrFuG5OOhhV7hhYcofvpCqqS3yQqHtIu8vcstrC3MKi/Rukc/NpAAiI9Aw/
         kXl9hQTS2yfDTZf97PPzb37VW9pdEoQYkaIwC8HJQ69QmX13ofWx9SQ9MqgXYOoQ2KiCdcWTuv7l
         lhpc6stePTGrBece03FyX3cBhPpyiLjEVvYdyRe76WIo/+2+mZic2oUAk2gV2zsYRo+qYUghoB9e
         gqSuFePvAniIjalpy3FqaP/qWcePpd/i3ylWDx7mC9NYOs4ttbaC0mPLeTk3IKepXrBeAyeWM+TZ
         eDOSlPZTcUcJlGJzs3htjwYWZ2wERUqR3fkJfGB5XMw+U9jVV7Ik4T4N96dY4hjMQ7kqPYQqRs9s
         jowG9PHQa4WCLVDQ/ua2h4SdTSm3iEetG+h2PMmcSnJ0qkN87OJPbzq/mMVpVFlIVpLrW1ryW2NA
         ==
Date:   Wed, 12 Jan 2022 14:16:27 +0800
From:   Conley Lee <conleylee@foxmail.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: ethernet: sun4i-emac: replace magic number with
 macro
X-OQ-MSGID: <Yd5yO0+T+q9gBYlj@fedora>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_71466C2135CD1780B19D7844BE3F167C940A@qq.com>
 <Yd2xC7ZaHrTAXcZd@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yd2xC7ZaHrTAXcZd@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/22 at 05:32下午, Corentin Labbe wrote:
> Date: Tue, 11 Jan 2022 17:32:11 +0100
> From: Corentin Labbe <clabbe.montjoie@gmail.com>
> To: Conley Lee <conleylee@foxmail.com>
> Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
>  wens@csie.org, netdev@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3] net: ethernet: sun4i-emac: replace magic number
>  with macro
> 
> Le Tue, Jan 11, 2022 at 11:05:53AM +0800, Conley Lee a écrit :
> > This patch remove magic numbers in sun4i-emac.c and replace with macros
> > defined in sun4i-emac.h
> > 
> > Signed-off-by: Conley Lee <conleylee@foxmail.com>
> 
> Hello
> 
> I sent a CI job witch next-20220107+yourpatch and saw no regression.
> 
> Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-on: sun4i-a10-olinuxino-lime
> 
> Thanks!
> Regards
> 
Could you please provide more information about it ? I test it on my
marsboard-a20 and everything work well.

Thanks 
