Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA68A2D1A65
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgLGURg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGURf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:17:35 -0500
Date:   Mon, 7 Dec 2020 12:16:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607372215;
        bh=Y3MQJe4leHFXAn/AseRv0a+ADPnTHgHc/7DjclXErSE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nc9bUHhPIEuQZ6CImjLqDz3gqCiXSfBcfT3Y/jdAESzryZhwDsF8oFhW9F5P+V1yK
         zJanNwIAKquByskId06H6PI+Gl4kfNmMPeACM4vir5Zwq6vOmoFOBr6XF9I2TR8LZA
         Tejkf+gcZVggoRAml4O9CszKkPNeDyD9RelEpb4PHD7tGdQ263D7jZPVW8uiLEasAU
         CTWxY43IIaiTFOfbfVSXIfGdsGmPJCJg0VpghGiIJh3l6sWhM5/N6ywtl/Vqur1YWd
         Z12M1y8Xh0obTqxEDzPZQnKHyVZT7zOn6L3OxDatBSAYOs1YNghgo8Kiv36TxQdvxX
         iadjyz3f0DcCA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: rmnet: Adjust virtual device MTU on real device
 capability
Message-ID: <20201207121654.17fac0ef@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAMZdPi-Nrus0JrHpjg02QaVwr0TKGU=p96BjXAtd4LALAvk2HQ@mail.gmail.com>
References: <1607017240-10582-1-git-send-email-loic.poulain@linaro.org>
        <3a2ca2c269911de71df6dca2e981f7fe@codeaurora.org>
        <CAMZdPi-Nrus0JrHpjg02QaVwr0TKGU=p96BjXAtd4LALAvk2HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Dec 2020 17:45:17 +0100 Loic Poulain wrote:
> > This would need similar checks in the NETDEV_PRECHANGEMTU
> > netdev notifier.  
> 
> What about just returning an error on NETDEV_PRECHANGEMTU notification
> to prevent real device MTU change while virtual rmnet devices are
> linked? Not sure there is a more proper and thread safe way to manager
> that otherwise.

Can't you copy what vlan devices do?  That'd seem like a reasonable and
well tested precedent, no?
