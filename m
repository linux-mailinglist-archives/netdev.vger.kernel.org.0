Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643C3492E67
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 20:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbiARTWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 14:22:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58634 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343530AbiARTVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 14:21:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FAEB60AFF;
        Tue, 18 Jan 2022 19:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC096C340E0;
        Tue, 18 Jan 2022 19:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642533710;
        bh=qWkShJH2TbRNtnHC5fQMNTh4h6rrTjQ6/Ri5U/KLWRk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iOYDcKp0OHD7uuMi/pb2JXOwuGOdqqoF2Ie7hT9HgpPEaVxrGCK1I9k8zAkuC0kh7
         P4gOh4aIvdsenYK2efrmmSOQzUuol2Ik4edOIPPJyuUG+WEtVfCOCVlUfuwogLvaOh
         9KD125NusJnAbPfug20zDgaffLztteOAyErpQuYaOr9pDL9NnVNUx98qymcna4iPbJ
         p0YLQLeJ4Wgg3FyT5Mga1MWHb9IlqUnQmsWCZyaxLb09M7oOobECMAh69MUI9gOLRW
         qlGp+KY+IU5bzYdtwLpw3LsfMm9nptapEZD8IF6ro5dDF84mVRT/cOoQ5AkB7i4lMk
         eH9Z25IXARXMA==
Date:   Tue, 18 Jan 2022 11:21:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>
Subject: Re: [PATCH] ipv4: Namespaceify min_adv_mss sysctl knob
Message-ID: <20220118112148.3e1acad4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118124055.927605-1-xu.xin16@zte.com.cn>
References: <20220118124055.927605-1-xu.xin16@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Jan 2022 12:40:55 +0000 cgel.zte@gmail.com wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Different netns have different requirement on the setting of min_adv_mss
> sysctl that the advertised MSS will be never lower than. The sysctl
> min_adv_mss can indirectly affects the segmentation efficiency of TCP.
> 
> So enable min_adv_mss to be visible and configurable inside the netns.
> 
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>

CGEL ZTE, whatever it is, is most definitely not a person so it can't
sign off patches. Please stop adding the CGEL task, you can tell us
what it stands for it you want us to suggest an alternative way of
marking.

As for the patch:

# Form letter - net-next is closed

We have already sent the networking pull request for 5.17
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.17-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
