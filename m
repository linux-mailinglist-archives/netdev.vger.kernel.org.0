Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18433489B7A
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 15:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbiAJOmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 09:42:13 -0500
Received: from out162-62-57-87.mail.qq.com ([162.62.57.87]:58705 "EHLO
        out162-62-57-87.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235700AbiAJOmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 09:42:13 -0500
X-Greylist: delayed 9174 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2022 09:42:10 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641825723;
        bh=SInMYX8FQJcMH6GOvAqNHe5i9bED8l/qPkQmnz9JKnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ik2d4sUhWEz7YpEZywc8aiXSF0pXVi5yafkQF8bkafoQvB0BZLCSmHoyyUhHQ1OyQ
         kCPmTTAJOtydRchWN3oX/0mw1tZiYK1A07zhQWistqOZ2dRlHNOwkb5dqdb/4yFj3t
         i8cgjNYy0y/oOVN4Nb39cgXj1zFEwkr/eRNzWkjk=
Received: from localhost ([119.32.47.91])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id A822FCF7; Mon, 10 Jan 2022 22:42:02 +0800
X-QQ-mid: xmsmtpt1641825722t83hly730
Message-ID: <tencent_6DDF530ADA4A09B6D49B4E0A8CD9F23D7809@qq.com>
X-QQ-XMAILINFO: MdDuF0zFTqpBGSvl8dJqX0GI0XABVuqy0SrSRJYjycLK1i6n0bb9K8xa0WKCyU
         kh7DjI4IhZuImH0dHAdDICpJMVIkxAkfeGoEUtxPm0dMUojw5AdsLxnvj/gUoHNxDn+SW307L7lI
         3+5DVA47ZeaXl7EpHYTzR7aB/MNQGLhpIp0iPW8KPgpRVXlkuXtpFkZzuESrLPN1Rsb4IFwJe59b
         VO3bOCPXVemKNUuOQCihmxWBkfhc7F7hJC5V+EFfNM4HNwQ2KpE0ZQmnHWG3yAX86X/7Flxsjl7Z
         eJjpRvcIYDnCBVhiJudWIshCRierBboxD1MvicBlTuvxWn8OUny5BS/ZvBsK3eOnIdQ2RvznNV8r
         17o1slEZx2t41u6fLfMXvXWfpKkWe7Deep8u1bbsENPz354/fTcJrQAmvIKPQYGIz9K+C2BS0Tix
         CdC0HRrFK7wFqRo+BD4OijNzoRd74b0DsgkUWllGC19b2fyQ4zacURx1hubOHUEHczJ7L1GCm29g
         tIfzNg2cIdObMJJg0Sw0Zvmj4eVE+Ix6ToS6xaPP/a155rtb24AfjFRNNE4XsWJPGohsx+vaoNB4
         5nxi6aeWqYZMwILkycce02X89bjYoT+BrFI8iv4IWJPjWOB8qXrNNy9S3+S0Jh0Y7Ids7cuJtm77
         M3h7FnnSZpmwuAEvO/LxZ0VDliH6eszYtQJ+mQ4HW53+LWxHVVMgYqRib/GoUbOQwrLsks3gWSoF
         MB5zju8VEucFwTFqsl92jvXAmubKyBZR9O/YnsU6OBSRYHw3ShXLLooxHFiPpkzvpp2+ljq6VQkV
         AQck9QAPDYPYm3oReU9Hg5IbKKGv4DL4maMzlDDv5JNFFSRR01TLrmu3xBP5YTpRYsYvMIVZy5DA
         ==
Date:   Mon, 10 Jan 2022 22:42:02 +0800
From:   Conley Lee <conleylee@foxmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
X-OQ-MSGID: <YdxFullWXqeg8fmT@fedora>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
 <YdwvEKiKd0JKpG9T@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdwvEKiKd0JKpG9T@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/10/22 at 03:05下午, Leon Romanovsky wrote:
> Date: Mon, 10 Jan 2022 15:05:20 +0200
> From: Leon Romanovsky <leon@kernel.org>
> To: Conley Lee <conleylee@foxmail.com>
> Cc: davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
>  wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
>  linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number
>  with macro
> 
> On Mon, Jan 10, 2022 at 07:35:49PM +0800, Conley Lee wrote:
> > This patch remove magic numbers in sun4i-emac.c and replace with macros
> > defined in sun4i-emac.h
> > 
> > Change since v1
> > ---------------
> > - reformat
> > - merge commits
> > - add commit message
> 
> This changelog should be placed after "---" below your SOB.
> 
> Thanks
> 
> > 
> > Signed-off-by: Conley Lee <conleylee@foxmail.com>
> > ---
> >  drivers/net/ethernet/allwinner/sun4i-emac.c | 30 ++++++++++++---------
> >  drivers/net/ethernet/allwinner/sun4i-emac.h | 18 +++++++++++++
> >  2 files changed, 35 insertions(+), 13 deletions(-)
I will reformat it and submit again, thanks ~
