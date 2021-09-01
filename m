Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223653FE62D
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhIAX5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 19:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhIAX5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 19:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BDB660FC4;
        Wed,  1 Sep 2021 23:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630540573;
        bh=8VER2c1SZIg8XYDfKaaqTZusmvfwZzuktFGzQWsFY2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GIEZAvmNzFeMK5NIHDrcoQBlVeH+j/ko6cdVQAg7xoyFr3nxkSFN7hOh/vVGo8Odv
         Vdmo+5hGEVASkcBrvszAtisI5r2mvdE61S8y4l0k4tZ6mGP6gQRiyzmqhJ2FCZQeZm
         w6JHiCOyGD/LVShFeXwdZqAtI9LXZVRikWtJ0bgDNyvOCc2m4iefvoerHW4bqra/z4
         j7G4T8Bg0Zknl4nrXAgCVBWg+aqhfXVWi8S+v4g7TSAQQjt0xzLi7A8IFGofy00v1Q
         /zkXlGBGBiG5Awi0+4NVP16tTOEIMdCl9N3joJUrejss+2w6V5wWfHFSmA6DNl/FIR
         PYhxSEvPA9pRA==
Date:   Wed, 1 Sep 2021 16:56:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 06/11] ptp: ocp: Add SMA selector and controls
Message-ID: <20210901165612.77cac1b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830235236.309993-7-jonathan.lemon@gmail.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
        <20210830235236.309993-7-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 16:52:31 -0700 Jonathan Lemon wrote:
>  static int
> -ptp_ocp_clock_val_from_name(const char *name)
> +select_val_from_name(struct ocp_selector *tbl, const char *name)

Why not prefix the helpers with ptp_ocp_ ? Makes code easier to follow
IMHO.
