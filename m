Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D982230355B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbhAZFjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbhAZDe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:34:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC87B2256F;
        Tue, 26 Jan 2021 03:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611632058;
        bh=24HMPQ5KBU07aAaSWFCm7Hw0EU4+OQOjiR7tdKvjwPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nm+zXjykcxUTXpSMGgyXXLQAtfzbqqCxgaP25ucAkuMnoTCAa/e9KPs2Zr3z51p1Q
         ZNybeuOqYBTzqiFZC2oO2NWhXmXRJ9vYIJTtBJGnVcFsm6ixcLyYT54rQ1ML/IsN1g
         rbepJOqgrP0ZFuYgdQjM8ri07ktb0/unKey7ZDlYwmCsNtYo9dvyJLZmTfyjalwqDB
         brmInUA77epSIEZKIGCpMqftCeceiAI6RKIOFM5dDnUilFR2EnCO9sahdVs2CJdvK2
         Q4A/8+ENmUW4ZH/KMr+7JkV4ERiJa2omBdbwHgJAxcghrismRUI9KhIpyGMVWtsGJ8
         RFalLFgz0hdeA==
Date:   Mon, 25 Jan 2021 19:34:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] nfc/ftp: fix typo issue
Message-ID: <20210125193416.7b26b264@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123074835.9448-1-samirweng1979@163.com>
References: <20210123074835.9448-1-samirweng1979@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 15:48:35 +0800 samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> change 'paquet' to 'packet'
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

s/ftp/fdp/

Applied, thanks.
