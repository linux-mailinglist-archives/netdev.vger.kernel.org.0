Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAAA41606F
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbhIWOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241440AbhIWOAH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 10:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6A860F44;
        Thu, 23 Sep 2021 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632405515;
        bh=u9b5QwJMwGCIEbtmqwFKNbTeb+cSMOEzVd1q1mym8LU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZkAYRjidPAcuZLcGUO8AQwIxXrXCarYQJ+WSe30Zd9A7In0cf+nK9Le/Lpd1t6eF
         YxY9S/u8MZJ+MCUDkcxPA/u+hPhiJFFEDUBlqEV8inx7HLdhmL7b6ypW604HBSk0R6
         YS4FFfrWyfajKXIH3otAAE1bjtbKzVZ3xluD5d0M=
Date:   Thu, 23 Sep 2021 15:58:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Tony Luck <tony.luck@intel.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/13] get_abi.pl undefined: improve precision and
 performance
Message-ID: <YUyICHTRdfL8Ul7X@kroah.com>
References: <cover.1632402570.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1632402570.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 03:29:58PM +0200, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> It follows a series of improvements for get_abi.pl. it is on the top of next-20210923.

Hm, looks like I hadn't pushed my -testing tree out so that it will show
up in linux-next yet, so we got a bunch of conflicts here.

I've done so now, can you rebase against my tree and resend?  I think
only 4 patches are new here.

thanks,

greg k-h
