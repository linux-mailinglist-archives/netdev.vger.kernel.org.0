Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8002A36E293
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 02:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhD2AY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 20:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhD2AY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 20:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47FA5613E8;
        Thu, 29 Apr 2021 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619655852;
        bh=mVDLppftIrMyDVj29z/pPPx8/CD2HdrW4LTgnoD3D3g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GP8zho80rQwCqkHD3Y+biJN/7VYyAob08owEKk7RVQszsaBQ9/zH0te09YlXzEL68
         uOWZrmTNqi3xLWDlqwtlWuRRO+sEG9MDmKt2JZDB9O8nw1/Zhpsy286o8cpSUGxXYk
         Es7CQAabj4CYqHGPUROitHmWpCXSdE6CWvV36ZASOTnL5dNP1UWLEia367hvV+ABFM
         hkmFNAeZSFqxAyryyZ4HHCBoBZFpJ7Y31JFEtXkOzaMpPd5YSnT51AgQ9vR1ArOcrR
         uPLCjnO7J35uv0wcQ3Iemsk5ziWNu3JP1IrSV6hJJXRZiuOvdRDTtpLohoDPfdgpsN
         k5GtDZiC43Q9A==
Date:   Wed, 28 Apr 2021 17:24:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2021-04-23
Message-ID: <20210428172411.78473936@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210423120248.248EBC4338A@smtp.codeaurora.org>
References: <20210423120248.248EBC4338A@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Apr 2021 12:02:48 +0000 (UTC) Kalle Valo wrote:
> mt76: debugfs: introduce napi_threaded node

Folks, why is the sysfs knob not sufficient?
