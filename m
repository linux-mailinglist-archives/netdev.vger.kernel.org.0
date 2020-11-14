Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988E72B308C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKNUJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgKNUJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 15:09:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB72A222EA;
        Sat, 14 Nov 2020 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605384568;
        bh=zKMvbDCZHKRWvy5cjeZ6p0aHm0PizayGBh+ZITU30AY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fJ8Tip6uDozSb3pvq6/ji29M73k4E7+8eUiJEy8DOIAUyxhBxriAyEKYD7WeDzsTh
         Y/C5HgRcT7/1W7fiYacC3XlaJCiFlfJ5lvhtSo2ogktRUefwWLMR6r+eCH0XBAzBJ8
         TrNNIFX2KdpcYf78GYlHSJQRNIw6RB8zlu0PjE18=
Date:   Sat, 14 Nov 2020 12:09:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Morris <jmorris@namei.org>
Cc:     Paul Moore <paul@paul-moore.com>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH] netlabel: fix an uninitialized warning in
 netlbl_unlabel_staticlist()
Message-ID: <20201114120922.07ec38a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <alpine.LRH.2.21.2011141803490.23236@namei.org>
References: <160530304068.15651.18355773009751195447.stgit@sifl>
        <alpine.LRH.2.21.2011141803490.23236@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 18:03:56 +1100 (AEDT) James Morris wrote:
> > Static checking revealed that a previous fix to
> > netlbl_unlabel_staticlist() leaves a stack variable uninitialized,
> > this patches fixes that.
> > 
> > Fixes: 866358ec331f ("netlabel: fix our progress tracking in netlbl_unlabel_staticlist()")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>  
> 
> Reviewed-by: James Morris <jamorris@linux.microsoft.com>

Applied, thanks!
