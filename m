Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1C4A4AF0
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379842AbiAaPt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:49:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45876 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241992AbiAaPt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:49:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42B4461463;
        Mon, 31 Jan 2022 15:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9529C340E8;
        Mon, 31 Jan 2022 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643644167;
        bh=RfzxGIAeIl9NFVKKuAGZG8H+QSlcGmJPcZgA7EV8CbY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tFoIX7sRZRLWnUdCKbZG0GPzcrBewtNA6uZGA9mlHt56/KG1sWli7EvjxYA12PWAS
         XAsFDMnNIVfujCt/fgfzGGw5eXLYrg2+CPZ8pFFzxzRrGvJMdb53DtTTDysHdXHQNg
         XRVgdJdlGLmPhibyOoIKLDo9BNs0NHNjKgUInCj6F6QuCoNwrCItRXsK+tXZ0c9qI3
         yf/cuEICJrhtT/4mDunelqTs8eHQ8pmFuaekrXQXX1bHhftpR2XWWDGcSKc9RO/tWz
         R0QchJxu8rfnTSQaAszaT0ccLdJWr5K/gYqy1XQaOIoRsqns7irC9mHjp4ru4gaIzp
         XFMa+bjilsGsg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: wsm: make array queue_id_to_wmm_aci static const
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220109230921.58766-1-colin.i.king@gmail.com>
References: <20220109230921.58766-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164364416428.21641.10643273039618096010.kvalo@kernel.org>
Date:   Mon, 31 Jan 2022 15:49:25 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Don't populate the read-only array queue_id_to_wmm_aci on the stack
> but instead make it static. Also makes the object code a little smaller.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Patch applied to wireless-next.git, thanks.

fe683faecc7a cw1200: wsm: make array queue_id_to_wmm_aci static const

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220109230921.58766-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

