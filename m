Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1848D48EBF2
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbiANOqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbiANOqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:46:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D7EC061574;
        Fri, 14 Jan 2022 06:46:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC4FAB821B8;
        Fri, 14 Jan 2022 14:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92087C36AEA;
        Fri, 14 Jan 2022 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642171597;
        bh=CkdMvZCwQYDA8ZJ4QcAkC/rvfnqM2RFL97I2ZNXR9oE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FwN5NvX99Ai2YFk9WMXWg4Al4ov5HkRmkwehtaWAMYg97AylSYtjypJFsjf5RmkhI
         CUZL0GfLgf7v3mZ1ldBryhzv6JsqXMrak1GKRUzRpLSuKLgvYPTiTBiHs5TfrONNY6
         e64RAzEgaWcXI55YejlcghnWVNKAnDTR4Rc7px4M/SnYJHjMWSSNLtj1Dzz05i1ZlH
         UEb8wE8iUU1c2D5hpOzL+tvIRlMMglAr+0MLcxGB+KEuhlkxyEuhOedCGUiQBlpf+U
         6O13K9klAyIj4hOEvcXBXzxv/RhF0G0E133m1g0NfM0JGWQtilsg19i2/U3QsTza4t
         ZQh5w19/3WYyw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     kernel test robot <lkp@intel.com>, ath10k@lists.infradead.org,
        kbuild-all@lists.01.org, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ath10k: search for default BDF name provided in DT
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
        <202201110851.5qAxfQJj-lkp@intel.com>
        <CACTWRwtCjXbpxkixAyRrmK5gRjWW7fMv5==9j=YcsdN-mnYhJw@mail.gmail.com>
Date:   Fri, 14 Jan 2022 16:46:30 +0200
In-Reply-To: <CACTWRwtCjXbpxkixAyRrmK5gRjWW7fMv5==9j=YcsdN-mnYhJw@mail.gmail.com>
        (Abhishek Kumar's message of "Thu, 13 Jan 2022 22:47:31 -0800")
Message-ID: <87y23is7cp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abhishek Kumar <kuabhs@chromium.org> writes:

> On this patch I have a kernel bot warning, which I intend to fix along
> with all the comments and discussion and push out V3. So, any
> comments/next steps are appreciated.

Please wait my comments before sending v3, I think this is something
which is also needed in ath11k and I need to look at it in detail.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
