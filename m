Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EEF446C19
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 03:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhKFCvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 22:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232660AbhKFCvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 22:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C772261165;
        Sat,  6 Nov 2021 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636166917;
        bh=0Q1qqv0Kd+XHjRnxqFbShLNfYNLIMdw5y4oufaAhDS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gb4YNvDSSDZFfNy9+aDPxKGQD1jvht4qYsXou3UIpuTwKh0UHrX3ROeI4qah5teq3
         d+Gtr0vUqsdv1fkiLN7HT0/vwKnczkn3voMZI/bnb2JuwoNpi+KmGCXgNiZCVwmI9m
         x6JORCrpThK0rxEr3VBw/j7bTXoVaLEEi1uvMFaN3Rh/ZL3fmYAoLlbxeSsCyMFa4r
         fIpOybRzqACxEvSWWI9WzJxc+Rr5AnrjtJmesM/YYm1Cg5nCG+iHT7kY4yy2T83ieT
         93LR2U7HexAaRZDphjjgNcGRBNT388Hv9vDPFq8+oDIZAFJpg9nYItFrfmV9KLcoUU
         sjPNu+5hoeh6Q==
Date:   Fri, 5 Nov 2021 19:48:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     krzysztof.kozlowski@canonical.com, yashsri421@gmail.com,
        davem@davemloft.net, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: nfcmrvl: add unanchor after anchor
Message-ID: <20211105194835.43270314@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1636016141-3645490-1-git-send-email-jiasheng@iscas.ac.cn>
References: <1636016141-3645490-1-git-send-email-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 08:55:41 +0000 Jiasheng Jiang wrote:
> In the error path, the anchored urb is unanchored.
> But in the successful path, the anchored urb is not.
> Therefore, it might be better to add unanchor().
> 
> Fixes: f26e30c ("NFC: nfcmrvl: Initial commit for Marvell NFC driver")

Apart from answering Krzysztof's comment please also mend the Fixes tag.
The hash should be at least 12 digits long.
