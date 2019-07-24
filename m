Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F1E72E04
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfGXLpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:45:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48448 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfGXLpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:45:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C71D160398; Wed, 24 Jul 2019 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968744;
        bh=ZuhfMbHMLI0hvi4ZXIAZVY0yoatWa3wtQrh3+kOQraM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gKoiSrClFSy5Oq1FdDOlSjDGtU+is2W55tKdyvMxC9PE8tEMukUQwBPAHDkjs1CVQ
         3kKd7XRdLFYhSfsU5HHpfuUVAn66yfBhOXuESlzX0lAJABuzWzOhZLCC6cT0AdF+YS
         lAutrpjjUtm4GSEtNFV7+qu5o4c+sRBPtpYtVBEA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90F006044E;
        Wed, 24 Jul 2019 11:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968742;
        bh=ZuhfMbHMLI0hvi4ZXIAZVY0yoatWa3wtQrh3+kOQraM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=f5Fhs597BaWvsfG72SYmLDYsDvVtV9k8KfHjwzlDZSZbFXB33N72RjNH+4i2KvDL1
         Iy9/Bzen7WJsi8eADsKE+jN+MamFjP0JKwuuuOWTMM7NhJhXPz4Vo2sd8ZifkxBG7q
         hLDqSX3//7jjdqzfIe/exniGHmjuviqOeHTtVBxM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 90F006044E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wl3501_cs: remove redundant variable rc
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190705103732.30568-1-colin.king@canonical.com>
References: <20190705103732.30568-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114543.C71D160398@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:45:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable rc is being initialized with a value that is never
> read and it is being updated later with a new value that is returned.
> The variable is redundant and can be replaced with a return 0 as
> there are no other return points in this function.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

c032461936de wl3501_cs: remove redundant variable rc

-- 
https://patchwork.kernel.org/patch/11032441/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

