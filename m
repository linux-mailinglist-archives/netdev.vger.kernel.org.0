Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD3F3DE4D9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 05:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhHCDzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 23:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233546AbhHCDyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 23:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA8160EE7;
        Tue,  3 Aug 2021 03:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627962882;
        bh=83R5gSJMs7720hS5FX9qKDbfLZ7OuHfix9yqVcSaYqo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aXTtJIBMhSs/5urJwrwkSFtlno1qO6AqIHxGD5VRABOUou9QdkR8cIKhRuR+Pr8ki
         OYWJuA1JfqbJgRR1033WLJEoi4nTrjvugEOY67LirKpVtpIo3s+Qidwy0PbYp+dtII
         +3OBoAlQJMQcSGs8kw/E54dDao47sOraZtH20Sz7P+hSwVFgo3ZKTPvuEChWZ64XYl
         Hm+DZY4Voiu26IyIveGMVr9BgWW1i3O1iHWnNF1QXgTIyQvAdA8VzG6Npkf7V94D3G
         XGEGusGgAJR+PWHT9IW1H3pekw+nu9/DflJrE8KrP2NTKB25yKYBFrmt7umICmR00O
         4qKtJ5XynFHAg==
Message-ID: <848f7c251f1a51e74c186a202e34cfb5fb076b6d.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: Fix typo in comments
From:   Saeed Mahameed <saeed@kernel.org>
To:     Cai Huoqing <caihuoqing@baidu.com>, leonro@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Mon, 02 Aug 2021 20:54:42 -0700
In-Reply-To: <20210730030300.2459-1-caihuoqing@baidu.com>
References: <20210730030300.2459-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-30 at 11:03 +0800, Cai Huoqing wrote:
> Fix typo:
> *vectores  ==> vectors
> *realeased  ==> released
> *erros  ==> errors
> *namepsace  ==> namespace
> *trafic  ==> traffic
> *proccessed  ==> processed
> *retore  ==> restore
> *Currenlty  ==> Currently
> *crated  ==> created
> *chane  ==> change
> *cannnot  ==> cannot
> *usuallly  ==> usually
> *failes  ==> fails
> *importent  ==> important
> *reenabled  ==> re-enabled
> *alocation  ==> allocation
> *recived  ==> received
> *tanslation  ==> translation
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

applied to net-next-mlx5, thanks !


