Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0329340F964
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbhIQNiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343541AbhIQNhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:37:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D08EE6112E;
        Fri, 17 Sep 2021 13:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631885774;
        bh=XUprm54eUjikJd8MsoP206lnyZ1x/5YgMkkAxcualnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ch4hDU0FrNLeJlcD/MK9a47DD9o7uxIfdXK6Dr0SR+A7syumCAoFnQEPC1JxpaUsU
         bURNaHLgtY5Z++pe8+Fmacqdf7NKoYWJF8/jggJeiNP2VyHXkk+PpSlYlz1E8yJKmZ
         Bi099NuqsCwnvPHd2VRmbffjiM0S1UHTLaAmSkKQ=
Date:   Fri, 17 Sep 2021 15:36:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        linux-staging@lists.linux.dev, Daniel Drake <drake@endlessos.org>
Subject: Re: [PATCH v2] MAINTAINERS: Move Daniel Drake to credits
Message-ID: <YUSZy0fH0oKuFsLV@kroah.com>
References: <20210917102834.25649-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917102834.25649-1-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 12:28:34PM +0200, Krzysztof Kozlowski wrote:
> Daniel Drake's @gentoo.org email bounces (is listed as retired Gentoo
> developer) and there was no activity from him regarding zd1211rw driver.
> Also his second address @laptop.org bounces.
> 
> Cc: Daniel Drake <drake@endlessos.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
