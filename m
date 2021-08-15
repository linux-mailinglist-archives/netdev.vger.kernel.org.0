Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D663EC82D
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 10:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhHOIoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 04:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhHOIn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 04:43:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C4CC061764
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 01:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZJ7WM+qJEzmDgDs+8QUsAwjfTkuIP8lbbYsS2pydqeo=; b=kj5N3thLMD8jD8j+r81hKWAU5R
        iWlp3Vr9ByXuY72diwTkvBh/ZxZ77/LAl1jbLNmDID1b0UXUTwte7xipaUufJPSziIZ2cDBz/v/uj
        rb0XDBt+qp+wWUkoh7/kamjg3NlIWF77Zgp1hb8SygC4oisUZ0z+KKtJ3hFuQlkMpaHAWt4tCKc+t
        97P28lA55Ve5adfMl5aslWpo7V6C7r41F23uXSpx3MI6g2warWB6rIKPkiL2vQoyKxzrqfgXVfxvG
        Ml2Ufomo9DxdnCEFdv/hVBOjbk+RzaJNIGJkQoHMlLaETHVnBnT85xlkV/wzWmY+U7vF+ZTomQtqN
        MLUVYg0g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFBib-00HYdH-R3; Sun, 15 Aug 2021 08:42:30 +0000
Date:   Sun, 15 Aug 2021 09:42:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Hilse <andreas.hilse@googlemail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: lan743x driver fails to map DMA during initialization on
 Raspberry CM4IO
Message-ID: <YRjTYUykl+4/KAXv@infradead.org>
References: <CANabuZeqrpk-gsZnCz-CYZKo5pRfWW0MGSY2DAWqz1060bReGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANabuZeqrpk-gsZnCz-CYZKo5pRfWW0MGSY2DAWqz1060bReGw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 02:45:12PM +0200, Andreas Hilse wrote:
> +
> +       if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
> DMA_BIT_MASK(64))) {

Setting the 64-bit mask never fails, no need for the error handling
here.
