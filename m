Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC70CBC1B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388806AbfJDNqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:46:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50854 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388733AbfJDNqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:46:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 62F9D61A37; Fri,  4 Oct 2019 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196801;
        bh=7z8K8z1kVtW4QRmy9LQUNBsQnTcmL+HKDaKSTRVrlrk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jN7pYUj2OrIhhdjp/i8GP2SYmK6REE/SkjCzJwZvh4FlUWwxB14XZpz9n/ulXpeue
         ikaeeDigxkc9pO0IXRR1GXLLbY1moi0FKgATgM8OSxxGvDockGl4qbS+VTY+x9+Owr
         08eOjd2JjsNQZvTfLFkKPYplzOXGP5hpWB6I9lbU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 40FD2613A8;
        Fri,  4 Oct 2019 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570196800;
        bh=7z8K8z1kVtW4QRmy9LQUNBsQnTcmL+HKDaKSTRVrlrk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ViTfqnTxmBIMf4p1Hx277E8BubfHs+nBxCPzvrE/JNSgJ1JjSfbBjO+SzAWFQpDWw
         NMi5PtAtTJw96KeSqS0vcM8BKX82vv3jiQ542DUG6ovIS6xMyT6P6IfNWdFefh0iOO
         7gKaeeclOdMMHzX/S8JIFNdXaEeMeAGqlqB+a/gE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 40FD2613A8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: remove redundant assignment to variable ret
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191002101517.10836-1-colin.king@canonical.com>
References: <20191002101517.10836-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191004134641.62F9D61A37@smtp.codeaurora.org>
Date:   Fri,  4 Oct 2019 13:46:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being assigned a value that is never read and is
> being re-assigned a little later on. The assignment is redundant and hence
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied to wireless-drivers-next.git, thanks.

60b5b49f6a6e libertas: remove redundant assignment to variable ret

-- 
https://patchwork.kernel.org/patch/11170731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

